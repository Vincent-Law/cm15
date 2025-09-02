-- gamemodes/cm15/gamemode/core/sh_config.lua
-- Shared configuration and constants - UPDATED

-- Network string keys
CM15_NET = {
    OpenTeamMenu = "cm15_open_teammenu",
    PickTeam     = "cm15_pick_team",
    OpenRoleMenu = "cm15_open_rolemenu",
    PickRole     = "cm15_pick_role",
    SyncSlots    = "cm15_sync_slots",
    BackToPrev   = "cm15_back",
    
    -- NEW: Xeno movement networking
    XenoModeChange = "cm15_xeno_mode_change",
    XenoModeSync   = "cm15_xeno_mode_sync"
}

-- Constants
CM15_UNLIMITED = -1

-- Round states
ROUND_WAITING = 0
ROUND_PREP    = 1
ROUND_LIVE    = 2
ROUND_ENDED   = 3

-- ConVars
CreateConVar("cm15_prep_time", "30", FCVAR_ARCHIVE, "Seconds of prep before LIVE")
CreateConVar("cm15_round_time", "900", FCVAR_ARCHIVE, "Seconds of LIVE round duration")
CreateConVar("cm15_reinforce_cd", "45", FCVAR_ARCHIVE, "Seconds between unlimited-role respawn waves")

-- NEW: Xeno movement configuration
CM15_XENO_MOVEMENT = {
    -- Standing mode speeds
    STANDING_WALK = 200,
    STANDING_RUN = 350,
    STANDING_SNEAK = 80,
    
    -- Crawling mode speeds (generally faster)
    CRAWLING_WALK = 280,
    CRAWLING_RUN = 450,
    CRAWLING_SNEAK = 120,
    
    -- Animation update rate (how often to check for animation changes)
    ANIMATION_THINK_RATE = 0.01
}