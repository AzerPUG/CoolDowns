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
                Name = "",
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
                Name = "",
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
                Name = "",
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
                Spells = {62618},
            },
            [2] =
            {
                Name = "Holy",
                Spells = {64843, 265202},
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
                Name = "",
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
                Name = "",
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
                Name = "",
                Spells = {},
            }
        }
    },
    [10] =
    {
        Name = "Monk",
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
                Spells = {115310}, -- 115310, 356722
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
                Name = "",
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
     [1] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000}, [3] = {00000, 00000, 00000},                             }, 
     [2] = {[1] = {17565, 17567, 17569}, [2] = {22428, 22558, 23469}, [3] = {22590, 22557, 23467},                             }, -- Holy / Protection / Retribution
     [3] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000}, [3] = {00000, 00000, 00000},                             }, -- Discipline / Holy / Shadow
     [4] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000}, [3] = {00000, 00000, 00000},                             }, 
     [5] = {[1] = {19752, 22313, 22329}, [2] = {22312, 19753, 19754}, [3] = {22328, 22136, 22314},                             }, 
     [6] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000}, [3] = {00000, 00000, 00000},                             }, 
     [7] = {[1] = {22356, 22357, 22358}, [2] = {22354, 22355, 22353}, [3] = {19262, 19263, 19264},                             }, -- Elemental / Enhancement / Restoration
     [8] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000}, [3] = {00000, 00000, 00000},                             }, 
     [9] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000}, [3] = {00000, 00000, 00000},                             }, 
    [10] = {[1] = {00000, 00000, 00000}, [2] = {19823, 19820, 20185}, [3] = {00000, 00000, 00000},                             }, -- Brewmaster / Mistweaver / Windwalker
    [11] = {[1] = {22385, 22386, 22387}, [2] = {22363, 22364, 22365}, [3] = {22419, 22418, 22420}, [4] = {18569, 18574, 18572},}, -- Balance / Feral / Guardian / Restoration
    [12] = {[1] = {00000, 00000, 00000}, [2] = {00000, 00000, 00000},                                                          }, 
}

AZP.CoolDowns.SpellList =
{
       [740] = {Name =         "Tranquility", NameShort =     "Tranq", CoolDown = 180, Duration =  7, CDAdjust = -60, CDAdjustDescr = "Talent"},
     [31821] = {Name =        "Aura Mastery", NameShort =   "AMaster", CoolDown = 180, Duration =  8, CDAdjust = nil, CDAdjustDescr =      nil},
     [98008] = {Name =   "Spirit Link Totem", NameShort =     "SLink", CoolDown = 180, Duration =  6, CDAdjust = nil, CDAdjustDescr =      nil},
    [108280] = {Name =  "Healing Tide Totem", NameShort =     "HTide", CoolDown = 180, Duration = 10, CDAdjust = nil, CDAdjustDescr =      nil},
     [64843] = {Name =         "Divine Hymn", NameShort =     "DHymn", CoolDown = 180, Duration = 10, CDAdjust = nil, CDAdjustDescr =      nil},
    [265202] = {Name =           "Salvation", NameShort = "Salvation", CoolDown = 300, Duration = 10, CDAdjust = nil, CDAdjustDescr =      nil},
     [62618] = {Name = "Power Word: Barrier", NameShort =   "Barrier", CoolDown = 180, Duration = 10, CDAdjust = nil, CDAdjustDescr =      nil},
    [115310] = {Name =             "Revival", NameShort =   "Revival", CoolDown = 180, Duration =  1, CDAdjust = nil, CDAdjustDescr =      nil},
    [356722] = {Name =             "Revival", NameShort =   "Revival", CoolDown = 180, Duration =  1, CDAdjust = nil, CDAdjustDescr =      nil},

    --[48438] = {Name = "Wild Growth", NameShort =   "WG", CoolDown = 10, Duration = 7, CDAdjust = nil, CDAdjustDescr =      nil},
}