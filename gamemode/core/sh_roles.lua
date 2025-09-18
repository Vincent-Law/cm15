-- gamemodes/cm15/gamemode/core/sh_roles.lua
-- Simplified to use centralized xeno config

CM15_ROLES = {
    Humans = {
        Marines = {
            type = "category",
            squads = { "Alpha", "Bravo", "Charlie", "Delta" },
            perSquad = {
                SquadLead         = 1,
                FireteamLeader    = 2,
                WeaponSpecialist  = 1,
                SmartGunner       = 1,
                HospitalCorpsman  = 4,
                CombatTechnician  = 3,
                Rifleman          = CM15_UNLIMITED
            },
            displayOrder = { 
                "SquadLead", "FireteamLeader", "WeaponSpecialist", 
                "SmartGunner", "HospitalCorpsman", "CombatTechnician", "Rifleman" 
            },
            iconModels = {
                SquadLead = "models/ariter/aliens/colonial_marine_camo_male_06_ply.mdl",
                FireteamLeader = "models/ariter/aliens/colonial_marine_camo_male_07_ply.mdl",
                WeaponSpecialist = "models/ariter/aliens/colonial_marine_camo_male_09_ply.mdl",
                SmartGunner = "models/ariter/aliens/colonial_marine_camo_male_08_ply.mdl",
                HospitalCorpsman = "models/ariter/aliens/colonial_marine_camo_male_03_ply.mdl",
                CombatTechnician = "models/ariter/aliens/colonial_marine_camo_male_02_ply.mdl",
                Rifleman = "models/ariter/aliens/colonial_marine_camo_male_04_ply.mdl"
            }
        },
        Survivors = {
            type = "category",
            roles = {
                { 
                    id = "Survivor", 
                    name = "Survivor", 
                    slots = CM15_UNLIMITED, 
                    model = "models/ariter/aliens/colonial_marine_camo_barney_ply.mdl" 
                }
            }
        },
        Command = {
            type = "category",
            roles = {
                { 
                    id = "CommandingOfficer", 
                    name = "Commanding Officer", 
                    slots = 1, 
                    model = "models/ariter/aliens/colonial_marine_camo_ply.mdl" 
                },
                { 
                    id = "ExecutiveOfficer", 
                    name = "Executive Officer", 
                    slots = 1, 
                    model = "models/ariter/aliens/colonial_marine_camo_npc.mdl" 
                },
                { 
                    id = "StaffOfficer", 
                    name = "Staff Officer", 
                    slots = 2, 
                    model = "models/ariter/aliens/colonial_marine_camo_male_03_ply.mdl" 
                },
                { 
                    id = "SeniorEnlisted", 
                    name = "Senior Enlisted Advisor", 
                    slots = 1, 
                    model = "models/ariter/aliens/colonial_marine_camo_barney_ply.mdl" 
                }
            }
        }
    },
    Aliens = {
        Queen = { 
            slots = 1,
            -- Model now comes from CM15_XENO_CONFIG.Models.Queen
            npc = "npc_vj_avp_xeno_queen",
            name = "Queen",
            description = "Massive alien matriarch",
        },
        Praetorian = { 
            slots = 2,
            npc = "npc_vj_avp_xeno_praetorian",
            name = "Praetorian",
            description = "Royal guard, tough fighter",
        },
        Ravager = {
            slots = 2,
            npc = "npc_vj_avp_xeno_ravager",
            name = "Ravager",
            description = "Berserker assault caste",
        },
        Carrier = {
            slots = 3,
            npc = "npc_vj_avp_xeno_carrier",
            name = "Carrier",
            description = "Facehugger transport",
        },
        Warrior = { 
            slots = 4,
            -- Model now comes from CM15_XENO_CONFIG.Models.Warrior
            npc = "npc_vj_avp_xeno_warrior",
            name = "Warrior",
            description = "Strong assault caste",
        },
        Drone = { 
            slots = 6,
            npc = "npc_vj_avp_xeno_drone",
            name = "Drone",
            description = "Worker and support caste",
        },
        Runner = { 
            slots = CM15_UNLIMITED,
            npc = "npc_vj_avp_xeno_runner",
            name = "Runner",
            description = "Fast, agile scout",
        },
        Facehugger = {
            slots = CM15_UNLIMITED,
            npc = "npc_vj_avp_xeno_facehugger",
            name = "Facehugger",
            description = "Infection vector",
        }
    }
}

-- Helper function to get alien model (shared for client/server)
function CM15_GetAlienModel(role)
    -- Check centralized config first
    if CM15_XENO_CONFIG and CM15_XENO_CONFIG.Models and CM15_XENO_CONFIG.Models[role] then
        return CM15_XENO_CONFIG.Models[role]
    end
    
    -- Fallback for older code
    local lowerRole = string.lower(role)
    if lowerRole == "warrior" then
        return "models/warrior.mdl"
    end
    return "models/cpthazama/avp/xeno/" .. lowerRole .. ".mdl"
end