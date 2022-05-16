if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["CoolDowns"] = 1
if AZP.CoolDowns == nil then AZP.CoolDowns = {} end
if AZP.CoolDowns.Events == nil then AZP.CoolDowns.Events = {} end

local CoolDownTicker = nil

PlayerCheckedSinceGRU = {}
local ContinueScanning = false

local PlayerScanQueue = {}
local PlayerScanticker = nil
local CoolDownBarFrame = nil
local EventFrame, UpdateFrame = nil, nil
local FailOffset = 1
local LastUnitScanned = nil
local ScanBusy = false
function AZP.CoolDowns:OnLoadSelf()
    EventFrame = CreateFrame("FRAME", nil)
    EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    EventFrame:RegisterEvent("INSPECT_READY")
    EventFrame:SetScript("OnEvent", function(...) AZP.CoolDowns:OnEvent(...) end)

    CoolDownBarFrame = CreateFrame("FRAME", nil, UIParent, "BackDropTemplate")
    CoolDownBarFrame:SetSize(225, 150)
    CoolDownBarFrame:SetPoint("CENTER", -700, -100)
    CoolDownBarFrame:EnableMouse(true)
    CoolDownBarFrame:SetMovable(true)
    CoolDownBarFrame:RegisterForDrag("LeftButton")
    CoolDownBarFrame:SetScript("OnDragStart", CoolDownBarFrame.StartMoving)
    CoolDownBarFrame:SetScript("OnDragStop", CoolDownBarFrame.StopMovingOrSizing)
    CoolDownBarFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 24,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    })

    CoolDownBarFrame.Header = CoolDownBarFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    CoolDownBarFrame.Header:SetSize(CoolDownBarFrame:GetWidth(), 25)
    CoolDownBarFrame.Header:SetPoint("TOP", 0, -5)
    CoolDownBarFrame.Header:SetText("|cFF00FFFFAzerPUG's CoolDowns|r")

    CoolDownBarFrame.ReScan = CreateFrame("BUTTON", nil, CoolDownBarFrame, "UIPanelButtonTemplate")
    CoolDownBarFrame.ReScan:SetSize(20, 20)
    CoolDownBarFrame.ReScan:SetPoint("TOPRIGHT", -5, -5)
    CoolDownBarFrame.ReScan:SetText("+")
    CoolDownBarFrame.ReScan:SetScript("OnClick", function() AZP.CoolDowns.Events:GroupRosterUpdate() end)

    CoolDownBarFrame.CoolDowns = {}
    CoolDownBarFrame.CoolDowns.Identifiers = {}
    CoolDownBarFrame.Bars = {}
end

function AZP.CoolDowns:GetClassColor(classIndex)
--     if classIndex ==  0 then return 0.00, 0.00, 0.00          -- None
--     elseif classIndex ==  1 then return 0.78, 0.61, 0.43      -- Warrior
--     elseif classIndex ==  2 then return 0.96, 0.55, 0.73      -- Paladin
--     elseif classIndex ==  3 then return 0.67, 0.83, 0.45      -- Hunter
--     elseif classIndex ==  4 then return 1.00, 0.96, 0.41      -- Rogue
--     elseif classIndex ==  5 then return 1.00, 1.00, 1.00      -- Priest
--     elseif classIndex ==  6 then return 0.77, 0.12, 0.23      -- Death Knight
--     elseif classIndex ==  7 then return 0.00, 0.44, 0.87      -- Shaman
--     elseif classIndex ==  8 then return 0.25, 0.78, 0.92      -- Mage
--     elseif classIndex ==  9 then return 0.53, 0.53, 0.93      -- Warlock
--     elseif classIndex == 10 then return 0.00, 1.00, 0.60      -- Monk
--     elseif classIndex == 11 then return 1.00, 0.49, 0.04      -- Druid
--     elseif classIndex == 12 then return 0.64, 0.19, 0.79      -- Demon Hunter
--     end
end

function AZP.CoolDowns:AddCoolDownsToList(SpellID, playerGUID)
    local specificIdentifier = playerGUID .. "-" .. SpellID
    if not tContains(CoolDownBarFrame.CoolDowns.Identifiers, specificIdentifier) then
        local index = #CoolDownBarFrame.CoolDowns + 1
        local spellInfo = AZP.CoolDowns.SpellList[SpellID]
        local SpellName = spellInfo.Name
        local SpellNameShort = spellInfo.NameShort
        local playerName = nil
        for i = 1, 40 do
            local curGUID = UnitGUID("raid" .. i)
            if playerGUID == curGUID then
                playerName = UnitName("raid" .. i)
            end
        end
        local SpellCoolDown = spellInfo.CoolDown
        local SpellCurrentCoolDown = 0
        CoolDownBarFrame.CoolDowns.Identifiers[index] = specificIdentifier
        CoolDownBarFrame.CoolDowns[index] = {SpellNameShort, SpellID, playerName, playerGUID, SpellCoolDown, SpellCurrentCoolDown}

        AZP.CoolDowns:ResetCoolDowns()
    end
end

function AZP.CoolDowns:GetCDsFromList(index)
    local cur = CoolDownBarFrame.CoolDowns[index]
    return cur[1], cur[2], cur[3], cur[4],cur[5], cur[6]
end

function AZP.CoolDowns:ResetCoolDowns()
    if CoolDownBarFrame.Bars ~= nil then
        for i = 1, #CoolDownBarFrame.Bars do
            CoolDownBarFrame.Bars[i]:Hide()
            CoolDownBarFrame.Bars[i]:SetParent(nil)
            CoolDownBarFrame.Bars[i] = nil
        end
    end

    CoolDownBarFrame.Bars = {}

    for i = 1, #CoolDownBarFrame.CoolDowns do
        local SpellNameShort, _, playerName, _, SpellCoolDown = AZP.CoolDowns:GetCDsFromList(i)
        CoolDownBarFrame.Bars[i] = CreateFrame("StatusBar", nil, CoolDownBarFrame)
        CoolDownBarFrame.Bars[i].Max = SpellCoolDown
        CoolDownBarFrame.Bars[i]:SetSize(CoolDownBarFrame:GetWidth() - 20, 18)
        CoolDownBarFrame.Bars[i]:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        CoolDownBarFrame.Bars[i]:SetPoint("TOP", 0, -20 * i - 10)
        CoolDownBarFrame.Bars[i]:SetMinMaxValues(0, SpellCoolDown)
        CoolDownBarFrame.Bars[i]:SetValue(CoolDownBarFrame.Bars[i].Max)
        CoolDownBarFrame.Bars[i].CDName = CoolDownBarFrame.Bars[i]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        CoolDownBarFrame.Bars[i].CDName:SetSize(50, 16)
        CoolDownBarFrame.Bars[i].CDName:SetPoint("CENTER", 0, -1)
        CoolDownBarFrame.Bars[i].CDName:SetText(SpellNameShort)
        CoolDownBarFrame.Bars[i].CharName = CoolDownBarFrame.Bars[i]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        CoolDownBarFrame.Bars[i].CharName:SetSize(50, 16)
        CoolDownBarFrame.Bars[i].CharName:SetPoint("LEFT", 5, -1)
        CoolDownBarFrame.Bars[i].CharName:SetText(playerName)
        CoolDownBarFrame.Bars[i].bg = CoolDownBarFrame.Bars[i]:CreateTexture(nil, "BACKGROUND")
        CoolDownBarFrame.Bars[i].bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        CoolDownBarFrame.Bars[i].bg:SetAllPoints(true)
        CoolDownBarFrame.Bars[i].bg:SetVertexColor(1, 0, 0)
        CoolDownBarFrame.Bars[i].cooldown = CoolDownBarFrame.Bars[i]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        CoolDownBarFrame.Bars[i].cooldown:SetSize(25, 16)
        CoolDownBarFrame.Bars[i].cooldown:SetPoint("RIGHT", -5, 0)
        CoolDownBarFrame.Bars[i].cooldown:SetText("")
        CoolDownBarFrame.Bars[i]:SetStatusBarColor(0, 0.75, 1)
    end
end

function AZP.CoolDowns:CreateResetTicker()
    if CoolDownTicker ~= nil then
        CoolDownTicker:Cancel()
        CoolDownTicker = nil
    end
    local longestCDActive = 0
    for i = 1, #CoolDownBarFrame.CoolDowns do
        local curCD = CoolDownBarFrame.CoolDowns[i][6]
        if curCD > longestCDActive then longestCDActive = curCD end
    end

    CoolDownTicker = C_Timer.NewTicker(1, function() AZP.CoolDowns:TickCoolDowns() end, longestCDActive)
end

function AZP.CoolDowns:TickCoolDowns()
    for i = 1, #CoolDownBarFrame.CoolDowns do
        local curCD = CoolDownBarFrame.CoolDowns[i]
        local curCDBar = CoolDownBarFrame.Bars[i]
        if curCD[6] > 1 then
            curCD[6] = curCD[6] - 1
            curCDBar:SetValue(curCD[6])
            curCDBar.cooldown:SetText(curCD[6])
        elseif curCD[6] == 1 then
            curCDBar:SetValue(curCDBar.Max)
            curCD[6] = 0
            curCDBar.cooldown:SetText("")
        elseif curCD[6] < 1 then
        end
        CoolDownBarFrame.CoolDowns[i] = curCD
    end
end

function AZP.CoolDowns:OnEvent(self, event, ...)
    if event == "GROUP_ROSTER_UPDATE" then
        AZP.CoolDowns.Events:GroupRosterUpdate()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local v1, combatEvent, v3, UnitGUID, casterName, v6, v7, destGUID, destName, v10, v11, spellID, v13, v14, v15 = CombatLogGetCurrentEventInfo()
        if AZP.CoolDowns.SpellList[spellID] ~= nil then
            if combatEvent == "SPELL_CAST_SUCCESS" then
                if CoolDownBarFrame.CoolDowns.Identifiers[1] ~= nil then
                    local identifier = UnitGUID .. "-" .. spellID
                    for i = 1, #CoolDownBarFrame.CoolDowns.Identifiers do
                        if CoolDownBarFrame.CoolDowns.Identifiers[i] == identifier then
                            CoolDownBarFrame.CoolDowns[i][6] = CoolDownBarFrame.CoolDowns[i][5]
                            AZP.CoolDowns:CreateResetTicker()
                        end
                    end
                end
            end
        end
    elseif event == "INSPECT_READY" then
        local curGUID = ...
        AZP.CoolDowns.Events:InspectReady(curGUID)
    end
end

function AZP.CoolDowns:GetIndexOfChecked(curGUID)
    for i = 1, #PlayerCheckedSinceGRU do
        if PlayerCheckedSinceGRU[i].GUID == curGUID then return i end
    end
end

function AZP.CoolDowns.Events:GroupRosterUpdate()
    AZP.CoolDowns:ResetCoolDowns()
    local ActiveCombat = UnitAffectingCombat("PLAYER")
    if ActiveCombat == false then
        AZP.CoolDowns.QueueNewPlayers()
    end
end

function AZP.CoolDowns.StartPlayerScanner()
    if PlayerScanticker == nil then
        PlayerScanticker = C_Timer.NewTicker(1, function() AZP.CoolDowns.ScanForPlayers() end)
    end
end

function AZP.CoolDowns.ScanForPlayers()
    if #PlayerScanQueue == 0 then
        PlayerScanticker:Cancel()
        PlayerScanticker = nil
        return
    end

    if FailOffset > #PlayerScanQueue then
        FailOffset = 1
    end

    local PlayerToScan = PlayerScanQueue[FailOffset]
    
    if LastUnitScanned and PlayerToScan.id == LastUnitScanned.id then
        print("Failed to scan " .. PlayerToScan.id)
        FailOffset = FailOffset + 1
        return
    end

    if PlayerToScan ~= nil then
        print("Scanning " .. PlayerToScan.id .. "-" .. PlayerToScan.guid, "-", FailOffset)
        if CanInspect(PlayerToScan.id, false) and ScanBusy == false then
            NotifyInspect(PlayerToScan.id)
            LastUnitScanned = PlayerToScan
        end
    end
end

function AZP.CoolDowns.QueueNewPlayers()
    PlayerScanQueue = {}

    for i = 1, 40 do
        local unitID = string.format("raid%d", i)
        local curGUID = UnitGUID(unitID)
        if curGUID ~= nil then
            --if ContainsIf(PlayerScanQueue, function(unit) return unit.guid == curGUID end) == false then
                tinsert(PlayerScanQueue, {id=unitID, guid=curGUID})
            --end
        end
    end
    AZP.CoolDowns.StartPlayerScanner()
end

function AZP.CoolDowns:GetClassAndSpec(unitID)
    local _, _, curClass = UnitClass(unitID)
    local curSpec = GetInspectSpecialization(unitID)

    return curClass, curSpec
end

function AZP.CoolDowns.Events:InspectReady(curGUID)
    ScanBusy = true
    print( "length was: ", #PlayerScanQueue, " - ", curGUID)
    local QueuePos, QueueItem = FindInTableIf(PlayerScanQueue, function (unit) return unit.guid == curGUID end)
    if QueuePos == nil then print("Player not found for scanning: ", curGUID) ScanBusy = false return end
    local class, spec = AZP.CoolDowns:GetClassAndSpec(QueueItem.id)
    if spec ~= nil then
        local curClass = AZP.CoolDowns.CDList[class]
        local curSpec = curClass.Specs[AZP.CoolDowns.SpecIdentifiers[class][spec]]
        local curSpecCDs = curSpec.Spells
        if #curSpecCDs >= 0 then
            for i = 1, #curSpecCDs do
                AZP.CoolDowns:AddCoolDownsToList(curSpecCDs[i], curGUID)
            end
        end

        print("Inspected " .. QueueItem.id, "with GUID", curGUID, "removing from queue", QueuePos)
        table.remove(PlayerScanQueue, QueuePos)
        print("afterwards length was: ", #PlayerScanQueue)
        
        if LastUnitScanned and LastUnitScanned.guid == curGUID then
            ClearInspectPlayer()
        end
    end
    ScanBusy = false
end

AZP.CoolDowns:OnLoadSelf()

--[[

    Death Knight
        250	Blood                   .   Class + Role
        251	Frost                   .   
        252	Unholy                  .   
    Demon Hunter
        577	Havoc                   .   Class + Role
        581	Vengeance               .   Class + Role
    Druid
        102	Balance                 .   Class + Role + MainStat
        103	Feral                   .   Class + Role + MainStat
        104	Guardian                .   Class + Role
        105	Restoration             .   Class + Role
    Hunter
        253	Beast Mastery           .   
        254	Marksmanship            .   
        255	Survival                .   
    Mage
        62	Arcane                  .   
        63	Fire                    .    
        64	Frost                   .   
    Monk
        268	Brewmaster              .   Class + Role
        270	Mistweaver              .   Class + Role
        269	Windwalker              .   Class + Role
    Paladin
        65	Holy                    .   Class + Role
        66	Protection              .   Class + Role
        70	Retribution             .   Class + Role
    Priest
        256	Discipline              .   
        257	Holy                    .   
        258	Shadow                  .   Class + Role
    Rogue
        259	Assassination           .   
        260	Outlaw                  .   
        261	Subtlety                .   
    Shaman
        262	Elemental               .   Class + Role + MainStat
        263	Enhancement             .   Class + Role + MainStat
        264	Restoration             .   Class + Role
    Warlock
        265	Affliction              .   
        266	Demonology              .   
        267	Destruction             .   
    Warrior
        71	Arms                    .   
        72	Fury                    .   
        73	Protection              .   Class + Role

]]