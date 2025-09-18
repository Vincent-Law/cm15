-- gamemodes/cm15/gamemode/core/sh_xeno_config.lua
-- Centralized xenomorph configuration to avoid redundancy

CM15_XENO_CONFIG = {
    -- Model definitions
    Models = {
        Queen = "models/cpthazama/avp/xeno/queen.mdl",
        Praetorian = "models/cpthazama/avp/xeno/praetorian.mdl",
        Ravager = "models/cpthazama/avp/xeno/ravager.mdl",
        Carrier = "models/cpthazama/avp/xeno/carrier.mdl",
        Warrior = "models/warrior.mdl",
        Drone = "models/cpthazama/avp/xeno/drone.mdl",
        Runner = "models/cpthazama/avp/xeno/runner.mdl",
        Facehugger = "models/cpthazama/avp/xeno/facehugger.mdl"
    },
    
    -- Warrior specific configuration
    Warrior = {
        -- Health/armor
        Health = 150,
        Armor = 0,
        
        -- Movement speeds (base values - SWEP can override)
        WalkSpeed = 200,
        RunSpeed = 350,
        CrawlWalkSpeed = 120,
        CrawlRunSpeed = 188,
        CrawlSprintMax = 490,
        JumpPower = 350,
        Gravity = 1.5,
        
        -- Hull sizes
        StandingHull = {
            mins = Vector(-16, -16, 0),
            maxs = Vector(16, 16, 72)
        },
        CrouchingHull = {
            mins = Vector(-16, -16, 0),
            maxs = Vector(16, 16, 36)
        },
        
        -- View offsets
        StandingView = Vector(0, 0, 64),
        CrouchingView = Vector(0, 0, 32),
        
        -- Visual
        Color = Color(15, 15, 15, 255),
        
        -- Weapon
        Weapon = "weapon_cm15_xeno_warrior",
        
        -- Attack damages
        ClawDamage = 25,
        TailStabQuick = 30,
        TailStabLight = 35,
        TailStabMedium = 50,
        TailStabHeavy = 75
    },
    
    -- Other castes can be added here later
    Drone = {
        Health = 100,
        WalkSpeed = 250,
        RunSpeed = 400,
        -- etc...
    }
}

-- Helper function to get xeno config
function CM15_GetXenoConfig(xenoType)
    return CM15_XENO_CONFIG[xenoType] or CM15_XENO_CONFIG.Warrior
end

-- Helper function to apply hull settings
function CM15_ApplyXenoHull(ply, xenoType, isCrawling)
    local config = CM15_GetXenoConfig(xenoType)
    if not config then return end
    
    if isCrawling then
        ply:SetHull(config.CrouchingHull.mins, config.CrouchingHull.maxs)
        ply:SetHullDuck(config.CrouchingHull.mins, config.CrouchingHull.maxs)
        ply:SetViewOffset(config.CrouchingView)
        ply:SetViewOffsetDucked(config.CrouchingView)
    else
        ply:SetHull(config.StandingHull.mins, config.StandingHull.maxs)
        ply:SetHullDuck(config.CrouchingHull.mins, config.CrouchingHull.maxs)
        ply:SetViewOffset(config.StandingView)
        ply:SetViewOffsetDucked(config.CrouchingView)
    end
end