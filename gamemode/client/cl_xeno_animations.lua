-- gamemodes/cm15/gamemode/client/cl_xeno_animations.lua
-- Updated with better SWEP integration and attack handling

-- Remove ALL existing animation hooks to prevent conflicts
hook.Remove("CalcMainActivity", "CM15_XenoMainActivity")  
hook.Remove("TranslateActivity", "CM15_XenoTranslateActivity")
hook.Remove("UpdateAnimation", "CM15_XenoUpdateAnimation")
hook.Remove("Think", "CM15_XenoDirectAnimationControl")

-- Direct animation control
local lastSetSequence = {}
local lastCycle = {}
local wasInAir = {}

hook.Add("Think", "CM15_XenoDirectAnimationControl", function()
    for _, ply in pairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        if not ply:GetNWBool("IsDirectXeno", false) then continue end
        
        local steamID = ply:SteamID()
        local velocity = ply:GetVelocity():Length2D()  -- Only needed for air/jump system
        local currentSeq = ply:GetSequence()
        local currentCycle = ply:GetCycle()
        local targetSeq = 11  -- Default to standing_idle
        local seqName = "standing_idle"
        
        -- Check if player is attacking (priority over all other animations)
        local isAttacking = ply:GetNWBool("XenoAttacking", false)
        local attackType = ply:GetNWString("XenoAttackType", "")
        local attackEnd = ply:GetNWFloat("XenoAttackEnd", 0)
        
        -- Check for forced sequences from SWEP (like the old working version)
        local forceSeq = ply:GetNWInt("ForceSequence", 0)
        local forceEnd = ply:GetNWFloat("ForceSequenceEnd", 0)
        
        if forceSeq > 0 and CurTime() < forceEnd then
            -- SWEP is forcing a specific sequence - use it!
            if currentSeq ~= forceSeq then
                ply:SetSequence(forceSeq)
                ply:SetCycle(0)
                ply:SetPlaybackRate(1.0)
                lastSetSequence[steamID] = forceSeq
                print("[ANIM] Forced sequence " .. forceSeq .. " from SWEP")
            end
            continue
        end
        
        -- Check if in an existing attack animation that needs to finish
        local isInAttackAnim = (currentSeq >= 70 and currentSeq <= 98) or -- various attack sequences
                              (currentSeq == 312) or -- tail_stab
                              (currentSeq >= 81 and currentSeq <= 92) or -- claw attacks
                              (currentSeq >= 228 and currentSeq <= 243) -- other attacks
        if isInAttackAnim and currentCycle < 0.8 then
            -- Let attack animation finish, update tracking
            lastSetSequence[steamID] = currentSeq
            lastCycle[steamID] = currentCycle
            continue
        end
        

        
        -- Get crawl state from networked variable (set by weapon)
        local isCrawling = ply:GetNWBool("IsCrawling", false)
        
        -- Get key states
        local forward = ply:KeyDown(IN_FORWARD)
        local back = ply:KeyDown(IN_BACK)
        local left = ply:KeyDown(IN_MOVELEFT)
        local right = ply:KeyDown(IN_MOVERIGHT)
        local shift = ply:KeyDown(IN_SPEED)
        local duck = ply:KeyDown(IN_DUCK)
        
        -- Check for pure directional movement first (most specific cases)
        local isPureLeft = left and not right and not forward and not back
        local isPureRight = right and not left and not forward and not back
        local isPureForward = forward and not back and not left and not right
        local isPureBack = back and not forward and not left and not right
        
        -- Check for diagonal movement
        local isForwardLeft = forward and left and not back and not right
        local isForwardRight = forward and right and not back and not left
        local isBackLeft = back and left and not forward and not right
        local isBackRight = back and right and not forward and not left
        
        -- Check if any movement keys are actually pressed
        local anyMovementKeys = forward or back or left or right
        

        -- Jump/air system
        -- Jump/air system
        if not ply:OnGround() then
            wasInAir[steamID] = true
            
            -- Don't override forced sequences (like crawling jumps)
            local forceSeq = ply:GetNWInt("ForceSequence", 0)
            local forceEnd = ply:GetNWFloat("ForceSequenceEnd", 0)
            if forceSeq > 0 and CurTime() < forceEnd then
                return -- Let the forced sequence continue
            end
            
            -- In air animations
            if velocity > 100 then
                targetSeq = 221  -- jump_fwd
                seqName = "jump_fwd"
            else
                targetSeq = 147  -- falling_pose
                seqName = "falling_pose"
            end
        -- Crawling mode animations
        elseif isCrawling then
            if anyMovementKeys then
                -- Crawl sprint animations - check weapon for speed buildup
                local weapon = ply:GetActiveWeapon()
                local hasSpeedBuildup = IsValid(weapon) and weapon.CrawlSpeedBuildup and weapon.CrawlSpeedBuildup > 0.5
                
                if shift then
                    -- Check if moving forward for fast crawl
                    if isPureForward and hasSpeedBuildup then
                        -- Fast crawl (max speed forward)
                        targetSeq = 93  -- crawl_fast
                        seqName = "crawl_fast"
                    else
                        -- Sprint crawl in other directions - use sneak animations at higher speed
                        if isPureLeft then
                            targetSeq = 363  -- sneak_left
                            seqName = "sneak_left_sprint"
                        elseif isPureRight then
                            targetSeq = 364  -- sneak_right
                            seqName = "sneak_right_sprint"
                        elseif isPureBack then
                            targetSeq = 362  -- sneak_backward
                            seqName = "sneak_backward_sprint"
                        elseif isPureForward then
                            targetSeq = 361  -- sneak_forward
                            seqName = "sneak_forward_sprint"
                        elseif isForwardLeft then
                            targetSeq = 365  -- sneak_forward_left
                            seqName = "sneak_forward_left_sprint"
                        elseif isForwardRight then
                            targetSeq = 366  -- sneak_forward_right
                            seqName = "sneak_forward_right_sprint"
                        elseif isBackLeft then
                            targetSeq = 367  -- sneak_backward_left
                            seqName = "sneak_backward_left_sprint"
                        elseif isBackRight then
                            targetSeq = 368  -- sneak_backward_right
                            seqName = "sneak_backward_right_sprint"
                        else
                            -- Fallback to forward sneak
                            targetSeq = 361  -- sneak_forward
                            seqName = "sneak_forward_sprint"
                        end
                    end
                else
                    -- Normal crawl movement - use sneak animations
                    if isPureLeft then
                        targetSeq = 363  -- sneak_left
                        seqName = "sneak_left"
                    elseif isPureRight then
                        targetSeq = 364  -- sneak_right
                        seqName = "sneak_right"
                    elseif isPureBack then
                        targetSeq = 362  -- sneak_backward
                        seqName = "sneak_backward"
                    elseif isPureForward then
                        targetSeq = 361  -- sneak_forward
                        seqName = "sneak_forward"
                    elseif isForwardLeft then
                        targetSeq = 365  -- sneak_forward_left
                        seqName = "sneak_forward_left"
                    elseif isForwardRight then
                        targetSeq = 366  -- sneak_forward_right
                        seqName = "sneak_forward_right"
                    elseif isBackLeft then
                        targetSeq = 367  -- sneak_backward_left
                        seqName = "sneak_backward_left"
                    elseif isBackRight then
                        targetSeq = 368  -- sneak_backward_right
                        seqName = "sneak_backward_right"
                    else
                        -- Fallback to forward sneak
                        targetSeq = 361  -- sneak_forward
                        seqName = "sneak_forward"
                    end
                end
            else
                -- Crawl idle
                targetSeq = 10  -- idle
                seqName = "crawl_idle"
            end
        -- Standing mode animations
        elseif anyMovementKeys then
            -- Sprinting (Shift held)
            if shift then
                -- For diagonal sprints, use walking animations instead
                if isForwardLeft then
                    targetSeq = 357  -- walk_forward_left
                    seqName = "sprint_forward_left_as_walk"
                elseif isForwardRight then
                    targetSeq = 358  -- walk_forward_right
                    seqName = "sprint_forward_right_as_walk"
                elseif isBackLeft then
                    targetSeq = 359  -- walk_backward_left
                    seqName = "sprint_backward_left_as_walk"
                elseif isBackRight then
                    targetSeq = 360  -- walk_backward_right
                    seqName = "sprint_backward_right_as_walk"
                elseif isPureLeft then
                    targetSeq = 281  -- sprint_left
                    seqName = "sprint_left"
                elseif isPureRight then
                    targetSeq = 282  -- sprint_right
                    seqName = "sprint_right"
                elseif isPureBack then
                    targetSeq = 280  -- sprint_backward
                    seqName = "sprint_backward"
                else
                    targetSeq = 279  -- sprint_forward
                    seqName = "sprint_forward"
                end
            -- Normal movement (no shift)
            else
                if isPureLeft then
                    targetSeq = 355  -- walk_left
                    seqName = "walk_left"
                elseif isPureRight then
                    targetSeq = 356  -- walk_right
                    seqName = "walk_right"
                elseif isPureBack then
                    targetSeq = 354  -- walk_backward
                    seqName = "walk_backward"
                elseif isPureForward then
                    targetSeq = 353  -- walk_forward
                    seqName = "walk_forward"
                elseif isForwardLeft then
                    targetSeq = 357  -- walk_forward_left
                    seqName = "walk_forward_left"
                elseif isForwardRight then
                    targetSeq = 358  -- walk_forward_right
                    seqName = "walk_forward_right"
                elseif isBackLeft then
                    targetSeq = 359  -- walk_backward_left
                    seqName = "walk_backward_left"
                elseif isBackRight then
                    targetSeq = 360  -- walk_backward_right
                    seqName = "walk_backward_right"
                else
                    -- Fallback to forward walk
                    targetSeq = 353  -- walk_forward
                    seqName = "walk_forward"
                end
            end
        else
            -- Idle animations
            if isCrawling then
                targetSeq = 10  -- idle (crawl)
                seqName = "idle_crawl"
            else
                targetSeq = 11  -- standing_idle
                seqName = "standing_idle"
            end
        end
        
        -- Track what we've set vs what it actually is
        local lastSet = lastSetSequence[steamID]
        local prevCycle = lastCycle[steamID] or 0
        
        -- Check if animation has finished/stopped progressing
        local animationStopped = (currentCycle >= 0.99) or (currentCycle == prevCycle and currentCycle > 0 and prevCycle > 0.1)
        
        if currentSeq ~= targetSeq then
            -- Different animation needed
            ply:SetSequence(targetSeq)
            ply:SetCycle(0)
            ply:SetPlaybackRate(1.0)
            
            lastSetSequence[steamID] = targetSeq
            
            -- Debug output (uncomment for testing)
            -- if lastSet ~= targetSeq then
            --     print("[CM15] Animation changed: " .. ply:Nick() .. " -> " .. seqName .. " (seq " .. targetSeq .. ") vel=" .. math.Round(velocity, 1))
            -- end
        elseif animationStopped and currentSeq == targetSeq then
            -- Restart all looping animations when they finish
            ply:SetCycle(0)
            ply:SetPlaybackRate(1.0)
        end
        
        -- Store current cycle for next check
        lastCycle[steamID] = currentCycle
        
        -- Handle playback rate
        if anyMovementKeys then
            -- Don't adjust playback rate during forced sequences or attacks
            local forceSeq = ply:GetNWInt("ForceSequence", 0)
            local forceEnd = ply:GetNWFloat("ForceSequenceEnd", 0)
            if not (forceSeq > 0 and CurTime() < forceEnd) then
                -- Adjust playback rate based on movement type
                if shift and (isForwardLeft or isForwardRight or isBackLeft or isBackRight) then
                    -- Speed up walk animations when used for sprinting
                    ply:SetPlaybackRate(2.0)
                elseif shift then
                    -- Normal sprint speed
                    ply:SetPlaybackRate(1.5)
                else
                    -- Normal movement speed
                    ply:SetPlaybackRate(1.0)
                end
            end
        else
            -- Don't reset playback rate if we're in a forced sequence
            local forceSeq = ply:GetNWInt("ForceSequence", 0)
            local forceEnd = ply:GetNWFloat("ForceSequenceEnd", 0)
            if not (forceSeq > 0 and CurTime() < forceEnd) then
                ply:SetPlaybackRate(1.0)
            end
        end
    end
end)

-- Try to catch what's resetting animations using a more aggressive hook
hook.Add("PostPlayerDraw", "CM15_XenoPostDraw", function(ply)
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local steamID = ply:SteamID()
    local currentSeq = ply:GetSequence()
    local lastSet = lastSetSequence[steamID]
    
    -- If our animation got reset between Think and PostPlayerDraw
    if lastSet and currentSeq ~= lastSet and currentSeq == 0 then
        -- Something reset it during the draw process - force it back
        ply:SetSequence(lastSet)
        ply:SetPlaybackRate(1.0)
    end
end)

-- Also try hooking the render process
hook.Add("PrePlayerDraw", "CM15_XenoPreDraw", function(ply)
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local steamID = ply:SteamID()
    local currentSeq = ply:GetSequence()
    local lastSet = lastSetSequence[steamID]
    
    -- If our animation got reset before drawing
    if lastSet and currentSeq ~= lastSet and currentSeq == 0 then
        -- Force it back before drawing
        ply:SetSequence(lastSet)
        ply:SetPlaybackRate(1.0)
    end
end)

-- Prevent GMod from overriding our animations
hook.Add("DoAnimationEvent", "CM15_BlockXenoAnimEvents", function(ply, event, data)
    if ply:GetNWBool("IsDirectXeno", false) then
        return true  -- Block the event
    end
end)

-- Force dark color for xenos
hook.Add("PlayerColor", "CM15_XenoPlayerColor", function(ply)
    if ply:GetNWBool("IsDirectXeno", false) then
        return Vector(0.1, 0.1, 0.1)
    end
end)