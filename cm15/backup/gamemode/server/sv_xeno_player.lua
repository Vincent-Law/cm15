-- gamemodes/cm15/gamemode/server/sv_xeno_player.lua
-- COMPLETE REPLACEMENT - DELETE ALL OLD CONTENT AND USE ONLY THIS

CM15_XenoPlayer = CM15_XenoPlayer or {}

-- Track players using direct xeno control
local DirectXenos = {}

function CM15_XenoPlayer.SpawnAsWarrior(ply)
    local steamId = ply:SteamID()
    
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
    
    -- Set xeno model directly on player
    ply:SetModel("models/cpthazama/avp/xeno/warrior.mdl")
    --ply:SetModel("models/player/kleiner.mdl") --human test for animations
    -- Adjust player properties for xeno
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(350)
    ply:SetJumpPower(350)
    ply:SetMaxHealth(150)
    ply:SetHealth(150)
    
    -- Custom hull size for xeno
    ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
    ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
    ply:SetViewOffset(Vector(0, 0, 64))
    ply:SetViewOffsetDucked(Vector(0, 0, 32))
    
    -- Dark xeno color
    ply:SetColor(Color(15, 15, 15, 255))
    
    -- Strip weapons and give xeno weapons (when we create them)
    ply:StripWeapons()
    
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
    ply:ChatPrint("Direct player control - use WASD to move")
    
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
        
        -- Acid splash effect
        timer.Simple(0.1, function()
            if IsValid(ply) then
                local effect = EffectData()
                effect:SetOrigin(ply:GetPos())
                effect:SetScale(2)
                util.Effect("Explosion", effect)
                
                ply:EmitSound("ambient/explosions/explode_4.wav")
                
                -- Damage nearby humans
                for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 80)) do
                    if IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_HUMANS then
                        local dmg = DamageInfo()
                        dmg:SetDamage(15)
                        dmg:SetDamageType(DMG_ACID)
                        dmg:SetAttacker(ply)
                        dmg:SetInflictor(ply)
                        ent:TakeDamageInfo(dmg)
                    end
                end
            end
        end)
        
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

-- Debug command to list all sequences
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

-- Debug command to check current animation state
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