if AZP == nil then AZP = {} end
if AZP.CoolDowns == nil then AZP.CoolDowns = {} end

AZP.CoolDowns.CDList =
{
    [1] =
    {
        Name = "Warrior",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Arms",
                Spells = {},
            },
            [2] =
            {
                Name = "Fury",
                Spells = {},
            },
            [3] =
            {
                Name = "Protection",
                Spells = {},
            }
        }
    },
    [2] =
    {
        Name = "Paladin",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Holy",
                Spells = {31821},
            },
            [2] =
            {
                Name = "Protection",
                Spells = {},
            },
            [3] =
            {
                Name = "Retribution",
                Spells = {},
            },
        }
    },
    [3] =
    {
        Name = "Hunter",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Beast Mastery",
                Spells = {},
            },
            [2] =
            {
                Name = "Marksmanship",
                Spells = {},
            },
            [3] =
            {
                Name = "Survival",
                Spells = {},
            }
        }
    },
    [4] =
    {
        Name = "Rogue",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Assassination",
                Spells = {},
            },
            [2] =
            {
                Name = "Outlaw",
                Spells = {},
            },
            [3] =
            {
                Name = "Subtlety",
                Spells = {},
            }
        }
    },
    [5] =
    {
        Name = "Priest",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Discipline",
                Spells = {},
            },
            [2] =
            {
                Name = "Holy",
                Spells = {},
            },
            [3] =
            {
                Name = "Shadow",
                Spells = {},
            },
        }
    },
    [6] =
    {
        Name = "Death Knight",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Blood",
                Spells = {},
            },
            [2] =
            {
                Name = "Frost",
                Spells = {},
            },
            [3] =
            {
                Name = "Unholy",
                Spells = {},
            }
        }
    },
    [7] =
    {
        Name = "Shaman",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Elemental",
                Spells = {},
            },
            [2] =
            {
                Name = "Enhancement",
                Spells = {},
            },
            [3] =
            {
                Name = "Restoration",
                Spells = {98008, 108280},
            },
        }
    },
    [8] =
    {
        Name = "Mage",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Arcane",
                Spells = {},
            },
            [2] =
            {
                Name = "Fire",
                Spells = {},
            },
            [3] =
            {
                Name = "Frost",
                Spells = {},
            }
        }
    },
    [9] =
    {
        Name = "Warlock",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Affliction",
                Spells = {},
            },
            [2] =
            {
                Name = "Demonology",
                Spells = {},
            },
            [3] =
            {
                Name = "Destruction",
                Spells = {},
            }
        }
    },
    [10] =
    {
        Name = "Monk",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Brewmaster",
                Spells = {},
            },
            [2] =
            {
                Name = "Mistweaver",
                Spells = {},
            },
            [3] =
            {
                Name = "Windwalker",
                Spells = {},
            },
        }
    },
    [11] =
    {
        Name = "Druid",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Balance",
                Spells = {},
            },
            [2] =
            {
                Name = "Feral",
                Spells = {},
            },
            [3] =
            {
                Name = "Guardian",
                Spells = {},
            },
            [4] =
            {
                Name = "Restoration",
                Spells = {740},
            },
        }
    },
    [12] =
    {
        Name = "Demon Hunter",
        Spells = {},
        Specs =
        {
            [1] =
            {
                Name = "Havoc",
                Spells = {},
            },
            [2] =
            {
                Name = "Vengeance",
                Spells = {},
            }
        }
    },
}

--[[

    /script for i = 1, 3 do local talentID, talentName, _, _, _, _, _, _, _, known, _ = GetTalentInfo(1, i, 1) print(talentID, talentName) end

]]

AZP.CoolDowns.SpecIdentifiers =
{
     [1] = {[71] = 1, [72] = 2, [73] = 3,},
     [2] = {[65] = 1, [66] = 2, [70] = 3,},
     [3] = {[253] = 1, [254] = 2, [255] = 3,},
     [4] = {[259] = 1, [260] = 2, [261] = 3,},
     [5] = {[256] = 1, [257] = 2, [258] = 3,},
     [6] = {[250] = 1, [251] = 2, [252] = 3,},
     [7] = {[262] = 1, [263] = 2, [264] = 3,},
     [8] = {[62] = 1, [63] = 2, [64] = 3,},
     [9] = {[265] = 1, [266] = 2, [267] = 3,},
    [10] = {[268] = 1, [270] = 2, [269] = 3,},
    [11] = {[102] = 1, [103] = 2, [104] = 3, [105] = 4,},
    [12] = {[577] = 1, [581] = 2,},
}

AZP.CoolDowns.SpellList =
{
    [740] =    {Name = "Tranquility",        NameShort =   "Tranq", CoolDown = 180, Duration =  7, CDAdjust = -60, CDAdjustDescr = "Talent"},
    [31821] =  {Name = "Aura Mastery",       NameShort = "AMaster", CoolDown = 180, Duration =  8, CDAdjust = nil, CDAdjustDescr =      nil},
    [98008] =  {Name = "Spirit Link Totem",  NameShort =   "SLink", CoolDown = 180, Duration =  6, CDAdjust = nil, CDAdjustDescr =      nil},
    [108280] = {Name = "Healing Tide Totem", NameShort =   "HTide", CoolDown = 180, Duration = 10, CDAdjust = nil, CDAdjustDescr =      nil},

    [48438] = {Name = "Wild Growth", NameShort =   "WG", CoolDown = 10, Duration = 7, CDAdjust = nil, CDAdjustDescr =      nil},
}