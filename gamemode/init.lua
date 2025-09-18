-- gamemodes/cm15/gamemode/init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Add client files
AddCSLuaFile("core/sh_config.lua")
AddCSLuaFile("core/sh_teams.lua") 
AddCSLuaFile("core/sh_roles.lua")
AddCSLuaFile("client/cl_fonts.lua")
AddCSLuaFile("client/cl_menus.lua")
AddCSLuaFile("client/cl_team_menu.lua")
AddCSLuaFile("client/cl_alien_menu.lua")
AddCSLuaFile("client/cl_human_menu.lua")
AddCSLuaFile("client/cl_networking.lua")
AddCSLuaFile("client/cl_xeno_animations.lua")
AddCSLuaFile("core/sh_xeno_config.lua")


-- Weapons are auto-loaded from lua/weapons/ folder
-- Just ensure the weapon file is AddCSLuaFile'd if it's not in autorun
if file.Exists("weapons/weapon_cm15_xeno_warrior.lua", "LUA") then
    AddCSLuaFile("weapons/weapon_cm15_xeno_warrior.lua")
end

-- Load server modules
include("server/sv_main.lua")
include("server/sv_slots.lua")
include("server/sv_aliens.lua")
include("server/sv_humans.lua")
include("server/sv_admin.lua")
include("server/sv_player.lua")
include("server/sv_networking.lua")
include("server/sv_xeno_player.lua")
include("core/sh_xeno_config.lua")
include("core/sh_roles.lua")

-- Register network strings
util.AddNetworkString(CM15_NET.OpenTeamMenu)
util.AddNetworkString(CM15_NET.PickTeam)
util.AddNetworkString(CM15_NET.OpenRoleMenu)
util.AddNetworkString(CM15_NET.PickRole)
util.AddNetworkString(CM15_NET.SyncSlots)
util.AddNetworkString(CM15_NET.BackToPrev)

hook.Add("Initialize", "CM15_ServerInit", function()
    timer.Simple(0.1, function()
        CM15_Slots.InitializeAlienSlots()
        print("[CM15] Server initialized successfully")
        print("[CM15] VJ Base Alien control system loaded")
        print("[CM15] Direct xeno player control system loaded")
        print("[CM15] Xeno warrior SWEP loaded")
    end)
end)