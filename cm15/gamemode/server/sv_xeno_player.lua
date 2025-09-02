-- gamemodes/cm15/gamemode/server/sv_xeno_player.lua
-- UPDATED - Integrated with enhanced movement system

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
    
    -- Set initial health and jump power
    ply:SetMaxHealth(150)
    ply:SetHealth(150)
    ply:SetJumpPower(350)
    
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
    
    -- Initialize movement system
    if CM15_XenoMovement then
        -- Set initial movement mode to standing
        CM15_XenoMovement.SetPlayerMode(ply, "standing")
        -- Apply initial speeds
        timer.Simple(0.1, function()
            if IsValid(ply) then
                CM15_XenoMovement.UpdatePlayerSpeeds(ply)
            end
        end)
    else
        -- Fallback if movement system not loaded
        ply:SetWalkSpeed(200)
        ply:SetRunSpeed(350)
    end
    
    -- Store in tracking
    DirectXenos[steamId] = {
        player = ply,
        role = "Warrior",
        spawnTime = CurTime(),
        movementMode = "standing"
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
    
    -- Enhanced spawn messages
    ply:ChatPrint("You are now a Xenomorph Warrior!")
    ply:ChatPrint("=== CONTROLS ===")
    ply:ChatPrint("WASD: Move | Mouse: Look | Space: Jump")
    ply:ChatPrint("C: Toggle Standing/Crawling mode")
    ply:ChatPrint("Ctrl: Sneak | Shift: Sprint")
    ply:ChatPrint("Crawling mode is faster but lower profile!")
    
    return true
end

function CM15_XenoPlayer.IsDirectXeno(ply)
    return ply:GetNWBool("IsDirectXeno", false)
end

function CM15_XenoPlayer.GetMovementMode(ply)
    if not IsValid(ply) or not CM15_XenoPlayer.IsDirectXeno(ply) then return nil end
    local steamId = ply:SteamID()
    local data = DirectXenos[steamId]
    return data and data.movementMode or "standing"
end

function CM15_XenoPlayer.SetMovementMode(ply, mode)
    if not IsValid(ply) or not CM15_XenoPlayer.IsDirectXeno(ply) then return end
    if mode ~= "standing" and mode ~= "crawling" then return end
    
    local steamId = ply:SteamID()
    if DirectXenos[steamId] then
        DirectXenos[steamId].movementMode = mode
    end
    
    -- Use movement system if available
    if CM15_XenoMovement then
        CM15_XenoMovement.SetPlayerMode(ply, mode)
    end
end

function CM15_XenoPlayer.CleanupPlayer(steamId)
    DirectXenos[steamId] = nil
end

-- Enhanced think hook for xeno-specific behavior
hook.Add("Think", "CM15_DirectXenoThink", function()
    for steamId, data in pairs(DirectXenos) do
        local ply = data.player
        if not IsValid(ply) or not ply:Alive() then
            DirectXenos[steamId] = nil
            continue
        end
        
        -- Xeno-specific behaviors can go here
        -- For example: wall climbing, special abilities, etc.
        
        -- Handle wall climbing for crawling mode (basic implementation)
        if data.movementMode == "crawling" and ply:KeyDown(IN_USE) then
            local trace = util.TraceLine({
                start = ply:GetPos(),
                endpos = ply:GetPos() + ply:GetForward() * 60,
                filter = ply
            })
            
            if trace.Hit and trace.HitNormal then
                local angle = trace.HitNormal:Angle()
                angle:RotateAroundAxis(angle:Right(), -90)
                -- Gradually adjust player angle toward wall normal
                local currentAngle = ply:GetAngles()
                local lerpedAngle = LerpAngle(0.02, currentAngle, angle)
                ply:SetAngles(Angle(lerpedAngle.p, currentAngle.y, lerpedAngle.r))
            end
        end
    end
end)

-- Cleanup on disconnect
hook.Add("PlayerDisconnected", "CM15_DirectXenoCleanup", function(ply)
    CM15_XenoPlayer.CleanupPlayer(ply:SteamID())
end)

-- Enhanced death handling for direct xenos
hook.Add("PlayerDeath", "CM15_DirectXenoDeath", function(ply, weapon, killer)
    if CM15_XenoPlayer.IsDirectXeno(ply) then
        local steamId = ply:SteamID()
        
        -- Acid splash effect with enhanced damage
        timer.Simple(0.1, function()
            if IsValid(ply) then
                local effect = EffectData()
                effect:SetOrigin(ply:GetPos())
                effect:SetScale(3) -- Bigger effect
                util.Effect("Explosion", effect)
                
                -- Multiple sound effects for more impact
                ply:EmitSound("ambient/explosions/explode_4.wav")
                timer.Simple(0.2, function()
                    if IsValid(ply) then
                        ply:EmitSound("ambient/levels/labs/electric_explosion1.wav", 60, 150)
                    end
                end)
                
                -- Enhanced acid splash damage
                for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
                    if IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_HUMANS then
                        local distance = ent:GetPos():Distance(ply:GetPos())
                        local damage = math.Clamp(25 - (distance / 4), 5, 25) -- Damage falloff with distance
                        
                        local dmg = DamageInfo()
                        dmg:SetDamage(damage)
                        dmg:SetDamageType(DMG_ACID)
                        dmg:SetAttacker(ply)
                        dmg:SetInflictor(ply)
                        ent:TakeDamageInfo(dmg)
                        
                        -- Visual effect on hit players
                        ent:ScreenFade(SCREENFADE.IN, Color(0, 255, 0, 30), 1, 0.5)
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

-- ENHANCED DEBUG COMMANDS

-- Debug command to list all sequences with filtering
concommand.Add("cm15_list_sequences", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not CM15_XenoPlayer.IsDirectXeno(ply) then 
        ply:ChatPrint("You must be a direct control xeno to use this.")
        return 
    end
    
    local filter = args[1] and string.lower(args[1]) or ""
    
    ply:ChatPrint("=== SEQUENCES IN MODEL ===")
    ply:ChatPrint("Model: " .. ply:GetModel())
    if filter ~= "" then
        ply:ChatPrint("Filter: " .. filter)
    end
    
    local count = 0
    for i = 0, ply:GetSequenceCount() - 1 do
        local seqName = ply:GetSequenceName(i)
        if seqName and seqName ~= "" then
            if filter == "" or string.find(string.lower(seqName), filter, 1, true) then
                ply:ChatPrint(i .. ": " .. seqName)
                count = count + 1
            end
        end
    end
    ply:ChatPrint("Found " .. count .. " matching sequences")
    if filter == "" then
        ply:ChatPrint("Usage: cm15_list_sequences [filter] (e.g., 'walk', 'run', 'idle')")
    end
end)

-- Enhanced debug command
concommand.Add("cm15_anim_debug", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not CM15_XenoPlayer.IsDirectXeno(ply) then return end
    
    local currentSeq = ply:GetSequence()
    local seqName = ply:GetSequenceName(currentSeq)
    local vel = ply:GetVelocity()
    local mode = CM15_XenoPlayer.GetMovementMode(ply)
    
    ply:ChatPrint("=== XENO DEBUG INFO ===")
    ply:ChatPrint("Model: " .. ply:GetModel())
    ply:ChatPrint("Movement Mode: " .. string.upper(mode or "unknown"))
    ply:ChatPrint("Sequence: " .. currentSeq .. " (" .. (seqName or "unknown") .. ")")
    ply:ChatPrint("Velocity: " .. math.Round(vel:Length2D(), 1))
    ply:ChatPrint("Walk Speed: " .. ply:GetWalkSpeed())
    ply:ChatPrint("Run Speed: " .. ply:GetRunSpeed())
    ply:ChatPrint("On Ground: " .. tostring(ply:OnGround()))
    ply:ChatPrint("Sneaking: " .. tostring(ply:KeyDown(IN_DUCK)))
    ply:ChatPrint("Sprinting: " .. tostring(ply:KeyDown(IN_SPEED)))
end)

-- Command to test movement mode switching
concommand.Add("cm15_test_mode", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not CM15_XenoPlayer.IsDirectXeno(ply) then 
        ply:ChatPrint("You must be a direct control xeno to use this.")
        return 
    end
    
    local mode = args[1]
    if mode ~= "standing" and mode ~= "crawling" then
        ply:ChatPrint("Usage: cm15_test_mode <standing|crawling>")
        ply:ChatPrint("Current mode: " .. CM15_XenoPlayer.GetMovementMode(ply))
        return
    end
    
    CM15_XenoPlayer.SetMovementMode(ply, mode)
    ply:ChatPrint("Movement mode set to: " .. mode)
end)