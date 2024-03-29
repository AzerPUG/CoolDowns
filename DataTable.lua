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
     [1] = {[1] = {}, [2] = {}, [3] = { },},
     [2] = {[1] = {17565, 17567, 17569}, [2] = {22428, 22558, 23469}, [3] = {22590, 22557, 23467},},
     [3] = {[1] = {}, [2] = {}, [3] = {},},
     [4] = {[1] = {}, [2] = {}, [3] = {},},
     [5] = {[1] = {19752, 22313, 22329}, [2] = {22312, 19753, 19754}, [3] = {22328, 22136, 22314},},
     [6] = {[1] = {}, [2] = {}, [3] = {},},
     [7] = {[1] = {22356, 22357, 22358}, [2] = {22354, 22355, 22353}, [3] = {19262, 19263, 19264},},
     [8] = {[1] = {}, [2] = {}, [3] = {},},
     [9] = {[1] = {}, [2] = {}, [3] = {},},
    [10] = {[1] = {23106, 19820, 20185}, [2] = {19823, 19820, 20185}, [3] = {23106, 19820, 20185},},
    [11] = {[1] = {22385, 22386, 22387}, [2] = {22363, 22364, 22365}, [3] = {22419, 22418, 22420}, [4] = {18569, 18574, 18572},},
    [12] = {[1] = {}, [2] = {},},
}

AZP.CoolDowns.SpellList =
{
    [740] =    {Name = "Tranquility",        NameShort =   "Tranq", CoolDown = 180, Duration =  7, CDAdjust = -60, CDAdjustDescr = "Talent"},
    [31821] =  {Name = "Aura Mastery",       NameShort = "AMaster", CoolDown = 180, Duration =  8, CDAdjust = nil, CDAdjustDescr =      nil},
    [98008] =  {Name = "Spirit Link Totem",  NameShort =   "SLink", CoolDown = 180, Duration =  6, CDAdjust = nil, CDAdjustDescr =      nil},
    [108280] = {Name = "Healing Tide Totem", NameShort =   "HTide", CoolDown = 180, Duration = 10, CDAdjust = nil, CDAdjustDescr =      nil},

    [48438] = {Name = "Wild Growth", NameShort =   "WG", CoolDown = 10, Duration = 7, CDAdjust = nil, CDAdjustDescr =      nil},
}