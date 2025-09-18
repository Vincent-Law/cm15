-- gamemodes/cm15/gamemode/server/sv_xeno_player.lua
-- SIMPLIFIED - Using centralized config

CM15_XenoPlayer = CM15_XenoPlayer or {}

-- Track players using direct xeno control
local DirectXenos = {}

function CM15_XenoPlayer.SpawnAsWarrior(ply)
    local steamId = ply:SteamID()
    local config = CM15_GetXenoConfig("Warrior")
    
    -- Clean up any existing alien control
    if CM15_Aliens then
        CM15_Aliens.CleanupPlayer(steamId)
    end
    
    -- Clear VJ Base properties
    ply.VJ_IsControllingNPC = false
    ply.VJ_TheController = nil
    ply.VJ_TheControlledNPC = nil
    
    -- Set team and role
    ply:SetTeam(TEAM_ALIENS)
    ply:SetNWString("CM15_Role", "Warrior")
    ply:UnSpectate()
    
    -- Set xeno model from config
    ply:SetModel(CM15_XENO_CONFIG.Models.Warrior)
    
    -- Apply properties from config
    ply:SetWalkSpeed(config.WalkSpeed)
    ply:SetRunSpeed(config.RunSpeed)
    ply:SetJumpPower(config.JumpPower)
    ply:SetMaxHealth(config.Health)
    ply:SetHealth(config.Health)
    ply:SetGravity(config.Gravity)
    ply:SetArmor(config.Armor)
    
    -- Apply hull settings
    CM15_ApplyXenoHull(ply, "Warrior", false)
    
    -- Visual settings
    ply:SetColor(config.Color)
    
    -- Strip weapons and give xeno weapon
    ply:StripWeapons()
    ply:Give(config.Weapon)
    ply:SelectWeapon(config.Weapon)
    
    -- Mark as direct control xeno
    ply:SetNWBool("IsDirectXeno", true)
    ply:SetNWString("XenoType", "Warrior")
    
    -- Store in tracking
    DirectXenos[steamId] = {
        player = ply,
        role = "Warrior",
        spawnTime = CurTime()
    }
    
    -- Also register in alien tracking for compatibility
    if CM15_Aliens then
        local AlienNPCs = CM15_Aliens.GetNPCs()
        AlienNPCs[steamId] = {
            npc = ply,  -- Store player as "npc" for slot tracking
            player = ply,
            role = "Warrior",
            spawnTime = CurTime(),
            directControl = true
        }
    end
    
    ply:ChatPrint("You are now a Xenomorph Warrior!")
    ply:ChatPrint("Crouch to toggle crawl mode, use Shift to sprint")
    
    return true
end

function CM15_XenoPlayer.IsDirectXeno(ply)
    return ply:GetNWBool("IsDirectXeno", false)
end

function CM15_XenoPlayer.CleanupPlayer(steamId)
    DirectXenos[steamId] = nil
end

-- Cleanup on disconnect
hook.Add("PlayerDisconnected", "CM15_DirectXenoCleanup", function(ply)
    CM15_XenoPlayer.CleanupPlayer(ply:SteamID())
end)

-- Death handling for direct xenos
hook.Add("PlayerDeath", "CM15_DirectXenoDeath", function(ply, weapon, killer)
    if CM15_XenoPlayer.IsDirectXeno(ply) then
        local steamId = ply:SteamID()
        
        -- Handle respawn/lockout
        local limited = ply:GetNWBool("CM15_LimitedRole", false)
        if limited then
            ply:ChatPrint("Your Warrior has been destroyed. You cannot respawn as this caste this round.")
        else
            ply:ChatPrint("Your Warrior has been destroyed. You will respawn in 30 seconds.")
        end
        
        -- Clean up
        CM15_XenoPlayer.CleanupPlayer(steamId)
        
        -- Set to spectator
        ply:SetTeam(TEAM_SPECTATOR)
        ply:Spectate(OBS_MODE_ROAMING)
    end
end)

-- DEBUG COMMANDS
concommand.Add("cm15_list_sequences", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not CM15_XenoPlayer.IsDirectXeno(ply) then 
        ply:ChatPrint("You must be a direct control xeno to use this.")
        return 
    end
    
    ply:ChatPrint("=== ALL SEQUENCES IN MODEL ===")
    ply:ChatPrint("Model: " .. ply:GetModel())
    
    for i = 0, ply:GetSequenceCount() - 1 do
        local seqName = ply:GetSequenceName(i)
        if seqName and seqName != "" then
            ply:ChatPrint(i .. ": " .. seqName)
        end
    end
end)

concommand.Add("cm15_anim_debug", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not CM15_XenoPlayer.IsDirectXeno(ply) then return end
    
    local currentSeq = ply:GetSequence()
    local seqName = ply:GetSequenceName(currentSeq)
    local vel = ply:GetVelocity()
    
    ply:ChatPrint("=== XENO ANIMATION DEBUG ===")
    ply:ChatPrint("Model: " .. ply:GetModel())
    ply:ChatPrint("Current sequence: " .. currentSeq .. " (" .. (seqName or "unknown") .. ")")
    ply:ChatPrint("Velocity: " .. math.Round(vel:Length2D(), 1))
    ply:ChatPrint("On ground: " .. tostring(ply:OnGround()))
    ply:ChatPrint("Playback rate: " .. ply:GetPlaybackRate())
    ply:ChatPrint("Cycle: " .. math.Round(ply:GetCycle(), 2))
    ply:ChatPrint("Total sequences: " .. ply:GetSequenceCount())
end)