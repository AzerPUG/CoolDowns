if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["CoolDowns"] = 4
if AZP.CoolDowns == nil then AZP.CoolDowns = {} end
if AZP.CoolDowns.Events == nil then AZP.CoolDowns.Events = {} end

local CoolDownTicker = nil
local CurrentlyRequested = nil

PlayerCheckedSinceGRU = {}

local CoolDownBarFrame = nil
local EventFrame, UpdateFrame = nil, nil

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

function AZP.CoolDowns.Events:GroupRosterUpdate()
    AZP.CoolDowns:ResetCoolDowns()
    PlayerCheckedSinceGRU = {}
    for i = 1, 40 do
        local target = "raid" .. i
        local curGUID = UnitGUID(target)
        
        if curGUID ~= nil then 
            local unitRole = UnitGroupRolesAssigned(target)
            if unitRole == "HEALER" then
                PlayerCheckedSinceGRU[curGUID] = {Checked = false, Target = target}
            end
        end
    end
    CoolDownBarFrame.CoolDowns = {}
    CoolDownBarFrame.CoolDowns.Identifiers = {}
    NotifyInspect("raid1")
end

function AZP.CoolDowns:GetClassAndSpec(curPlayer)
    local _, _, curClass = UnitClass(curPlayer.Target)
    local curSpec = nil

    local totSpecs = 0
    if curClass == 11 then totSpecs = 4
    elseif curClass == 12 then totSpecs = 2
    else totSpecs = 3 end

    local curTalentList = AZP.CoolDowns.SpecIdentifiers[curClass]

    for columns = 1, 3 do
        local talentID, _, _, selected = GetTalentInfo(1, columns, 1, true, curPlayer.Target)
        if selected == true then
            for specNumber = 1, totSpecs do
                for talentNumber = 1, 3 do
                    if curTalentList[specNumber][talentNumber] == talentID then curSpec = specNumber break end
                end
            end
        end
    end

    return curClass, curSpec
end

function AZP.CoolDowns:InspectNextPlayer()
    for _, state in pairs(PlayerCheckedSinceGRU) do
        if state.Checked == false and CanInspect(state.Target) then
            NotifyInspect(state.Target)
            return
        end
    end
end

function AZP.CoolDowns.Events:InspectReady(curGUID)
    local curPlayer = PlayerCheckedSinceGRU[curGUID]
    if curPlayer ~= nil and curPlayer.Checked == false then
        local class, spec = AZP.CoolDowns:GetClassAndSpec(curPlayer)
        -- if spec == nil then AZP.CoolDowns:CheckNextPlayer(curIndex) return end -- For when player is out of range.
        local list = AZP.CoolDowns.CDList
        local curClass = list[class]
        local curSpec = curClass.Specs[spec]
        local curSpecCDs = curSpec.Spells
        if #curSpecCDs >= 0 then
            for i = 1, #curSpecCDs do
                AZP.CoolDowns:AddCoolDownsToList(curSpecCDs[i], curGUID)
            end
        end
        PlayerCheckedSinceGRU[curGUID].Checked = true

        if InspectFrame == nil or InspectFrame:IsShown() == false then
			ClearInspectPlayer()
		end
    end
    C_Timer.After(0.25, function() AZP.CoolDowns:InspectNextPlayer() end)
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