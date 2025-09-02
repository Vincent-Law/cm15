-- gamemodes/cm15/gamemode/client/cl_xeno_animations.lua
-- COMPLETE REPLACEMENT - Enhanced xeno animation system with dual movement modes

-- Remove ALL existing animation hooks to prevent conflicts
hook.Remove("CalcMainActivity", "CM15_XenoMainActivity")  
hook.Remove("TranslateActivity", "CM15_XenoTranslateActivity")
hook.Remove("UpdateAnimation", "CM15_XenoUpdateAnimation")

-- Enhanced tracking variables
local lastSetSequence = {}
local lastCycle = {}
local playerMovementMode = {} -- "standing" or "crawling"
local playerMovementState = {} -- Current movement state for smoother transitions

-- Initialize movement mode for new players
local function InitPlayerMovement(steamID)
    if not playerMovementMode[steamID] then
        playerMovementMode[steamID] = "standing" -- Default to standing
        playerMovementState[steamID] = {
            lastDirection = "forward",
            lastSpeed = "idle",
            transitionTime = 0
        }
    end
end

-- Determine movement direction based on player input and velocity
local function GetMovementDirection(ply, velocity2D)
    if velocity2D < 0.5 then return "idle" end
    
    local forward = ply:GetForward()
    local right = ply:GetRight()
    local vel = ply:GetVelocity()
    vel.z = 0 -- Remove vertical component
    vel:Normalize()
    
    local forwardDot = vel:Dot(forward)
    local rightDot = vel:Dot(right)
    
    -- Determine primary direction based on strongest component
    if math.abs(forwardDot) > math.abs(rightDot) then
        return forwardDot > 0 and "forward" or "backward"
    else
        return rightDot > 0 and "right" or "left"
    end
end

-- Get appropriate animation sequence based on mode, direction, and speed
local function GetXenoAnimation(ply, direction, speed, mode, isSneaking)
    local seqName = ""
    local fallbackSeq = 11 -- standing_idle fallback
    
    -- Animation naming patterns (adjust these based on your model's actual sequence names)
    if mode == "crawling" then
        if direction == "idle" then
            seqName = isSneaking and "crawl_idle_stealth" or "crawl_idle"
        elseif direction == "forward" then
            if speed == "run" then
                seqName = isSneaking and "crawl_run_stealth" or "crawl_run"
            else
                seqName = isSneaking and "crawl_walk_stealth" or "crawl_walk"
            end
        elseif direction == "backward" then
            seqName = isSneaking and "crawl_backward_stealth" or "crawl_backward"
        elseif direction == "left" then
            seqName = isSneaking and "crawl_left_stealth" or "crawl_left"  
        elseif direction == "right" then
            seqName = isSneaking and "crawl_right_stealth" or "crawl_right"
        end
    else -- standing mode
        if direction == "idle" then
            seqName = isSneaking and "standing_idle_stealth" or "standing_idle"
        elseif direction == "forward" then
            if speed == "run" then
                seqName = isSneaking and "run_stealth" or "run"
            else
                seqName = isSneaking and "walk_stealth" or "walk"
            end
        elseif direction == "backward" then
            seqName = isSneaking and "walk_backward_stealth" or "walk_backward"
        elseif direction == "left" then
            seqName = isSneaking and "strafe_left_stealth" or "strafe_left"
        elseif direction == "right" then
            seqName = isSneaking and "strafe_right_stealth" or "strafe_right"
        end
    end
    
    -- Try to find the sequence, with fallbacks
    local seq = ply:LookupSequence(seqName)
    if seq >= 0 then
        return seq, seqName
    end
    
    -- Try without stealth suffix if stealth version not found
    if isSneaking then
        local baseSeqName = seqName:gsub("_stealth", "")
        seq = ply:LookupSequence(baseSeqName)
        if seq >= 0 then
            return seq, baseSeqName
        end
    end
    
    -- Fallback to basic animations
    if direction == "forward" and speed == "run" then
        seq = ply:LookupSequence("run")
        if seq >= 0 then return seq, "run" end
    elseif direction == "forward" then
        seq = ply:LookupSequence("walk")
        if seq >= 0 then return seq, "walk" end
    end
    
    -- Final fallback
    seq = ply:LookupSequence("standing_idle")
    if seq >= 0 then return seq, "standing_idle" end
    
    return fallbackSeq, "standing_idle"
end

-- Main animation control hook
hook.Add("Think", "CM15_XenoEnhancedAnimationControl", function()
    for _, ply in pairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        if not ply:GetNWBool("IsDirectXeno", false) then continue end
        
        local steamID = ply:SteamID()
        InitPlayerMovement(steamID)
        
        local velocity2D = ply:GetVelocity():Length2D()
        local currentSeq = ply:GetSequence()
        local currentCycle = ply:GetCycle()
        
        -- Get current movement mode
        local mode = playerMovementMode[steamID] or "standing"
        local state = playerMovementState[steamID]
        
        -- Determine if player is sneaking (holding Ctrl)
        local isSneaking = ply:KeyDown(IN_DUCK)
        
        -- Determine movement speed
        local speed = "walk"
        local isRunning = ply:KeyDown(IN_SPEED)
        
        if velocity2D > 250 and isRunning then
            speed = "run"
        elseif velocity2D > 0.5 then
            speed = "walk"
        else
            speed = "idle"
        end
        
        -- Determine movement direction
        local direction = GetMovementDirection(ply, velocity2D)
        if speed == "idle" then direction = "idle" end
        
        -- Get target animation
        local targetSeq, seqName = GetXenoAnimation(ply, direction, speed, mode, isSneaking)
        
        -- Track what we've set vs what it actually is
        local lastSet = lastSetSequence[steamID]
        local prevCycle = lastCycle[steamID] or 0
        
        -- Check if animation has finished/stopped progressing
        local animationStopped = (currentCycle >= 0.99) or (currentCycle == prevCycle and currentCycle > 0)
        
        -- Set animation if needed
        if currentSeq ~= targetSeq then
            ply:SetSequence(targetSeq)
            ply:SetCycle(0)
            ply:SetPlaybackRate(1.0)
            lastSetSequence[steamID] = targetSeq
            
            -- Only print when we actually change to a different animation
            if lastSet ~= targetSeq then
                local modeText = mode == "crawling" and "[CRAWL]" or "[STAND]"
                local sneakText = isSneaking and "[SNEAK]" or ""
                print("[CM15] " .. modeText .. sneakText .. " Animation: " .. ply:Nick() .. " -> " .. seqName .. " (seq " .. targetSeq .. ") vel=" .. math.Round(velocity2D, 1))
            end
        elseif animationStopped and currentSeq == targetSeq then
            -- Same animation but it stopped - restart it
            ply:SetCycle(0)
            ply:SetPlaybackRate(1.0)
        end
        
        -- Store current cycle for next check
        lastCycle[steamID] = currentCycle
        
        -- Handle playback rate based on movement mode and speed
        if velocity2D > 0.2 then
            local baseRate = 1.0
            
            -- Adjust rate based on mode
            if mode == "crawling" then
                baseRate = 1.2 -- Crawling animations might need to be faster
            end
            
            -- Adjust for movement speed
            if isSneaking then
                baseRate = baseRate * 0.6 -- Slower for sneaking
            elseif speed == "run" then
                baseRate = baseRate * math.Clamp(velocity2D / 300, 0.8, 1.8)
            else
                baseRate = baseRate * math.Clamp(velocity2D / 150, 0.7, 1.3)
            end
            
            ply:SetPlaybackRate(baseRate)
        else
            ply:SetPlaybackRate(1.0)
        end
        
        -- Update state tracking
        state.lastDirection = direction
        state.lastSpeed = speed
    end
end)

-- Handle movement mode toggling (C key)
hook.Add("KeyPress", "CM15_XenoMovementMode", function(ply, key)
    if not IsValid(ply) then return end
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    if key ~= IN_BULLRUSH then return end -- C key is IN_BULLRUSH
    
    local steamID = ply:SteamID()
    InitPlayerMovement(steamID)
    
    -- Toggle movement mode
    local currentMode = playerMovementMode[steamID]
    local newMode = (currentMode == "standing") and "crawling" or "standing"
    playerMovementMode[steamID] = newMode
    
    -- Network the mode change to server for speed adjustments
    net.Start("CM15_XenoModeChange")
    net.WriteString(newMode)
    net.SendToServer()
    
    -- Notify player
    ply:ChatPrint("Movement mode: " .. string.upper(newMode))
    
    -- Force immediate animation update
    lastSetSequence[steamID] = nil
end)

-- Network string for mode changes
if CLIENT then
    net.Receive("CM15_XenoModeSync", function()
        local steamID = LocalPlayer():SteamID()
        local mode = net.ReadString()
        playerMovementMode[steamID] = mode
    end)
end

-- Prevent GMod from overriding our animations
hook.Add("DoAnimationEvent", "CM15_BlockXenoAnimEvents", function(ply, event, data)
    if ply:GetNWBool("IsDirectXeno", false) then
        return true  -- Block the event
    end
end)

-- Keep existing post-draw hooks for animation protection
hook.Add("PostPlayerDraw", "CM15_XenoPostDraw", function(ply)
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local steamID = ply:SteamID()
    local currentSeq = ply:GetSequence()
    local lastSet = lastSetSequence[steamID]
    
    if lastSet and currentSeq ~= lastSet and currentSeq == 0 then
        ply:SetSequence(lastSet)
        ply:SetPlaybackRate(1.0)
    end
end)

hook.Add("PrePlayerDraw", "CM15_XenoPreDraw", function(ply)
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local steamID = ply:SteamID()
    local currentSeq = ply:GetSequence()
    local lastSet = lastSetSequence[steamID]
    
    if lastSet and currentSeq ~= lastSet and currentSeq == 0 then
        ply:SetSequence(lastSet)
        ply:SetPlaybackRate(1.0)
    end
end)

-- Enhanced debug overlay
local showDebug = false
concommand.Add("cm15_anim_overlay", function()
    showDebug = not showDebug
    LocalPlayer():ChatPrint("Xeno animation overlay: " .. (showDebug and "ON" or "OFF"))
end)

hook.Add("HUDPaint", "CM15_XenoEnhancedDebugOverlay", function()
    if not showDebug then return end
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local steamID = ply:SteamID()
    InitPlayerMovement(steamID)
    
    local x, y = 10, 10
    surface.SetTextColor(255, 255, 255, 255)
    surface.SetFont("DermaDefault")
    
    local velocity2D = ply:GetVelocity():Length2D()
    local direction = GetMovementDirection(ply, velocity2D)
    local mode = playerMovementMode[steamID] or "standing"
    local isSneaking = ply:KeyDown(IN_DUCK)
    local isRunning = ply:KeyDown(IN_SPEED)
    
    local lines = {
        "=== XENO ENHANCED CONTROL ===",
        "Model: " .. ply:GetModel(),
        "Mode: " .. string.upper(mode) .. (isSneaking and " [SNEAK]" or "") .. (isRunning and " [SPRINT]" or ""),
        "Direction: " .. string.upper(direction),
        "Sequence: " .. ply:GetSequence() .. " (" .. (ply:GetSequenceName(ply:GetSequence()) or "unknown") .. ")",
        "Velocity: " .. math.Round(velocity2D, 1),
        "On Ground: " .. tostring(ply:OnGround()),
        "Playback Rate: " .. math.Round(ply:GetPlaybackRate(), 2),
        "Cycle: " .. math.Round(ply:GetCycle(), 2),
        "",
        "Controls:",
        "C - Toggle Standing/Crawling",
        "Ctrl - Sneak",
        "Shift - Sprint"
    }
    
    for i, line in ipairs(lines) do
        surface.SetTextPos(x, y + (i - 1) * 15)
        surface.DrawText(line)
    end
end)

-- Enhanced test command with mode support
concommand.Add("cm15_force_anim", function(ply, cmd, args)
    if not IsValid(LocalPlayer()) then return end
    if not LocalPlayer():GetNWBool("IsDirectXeno", false) then 
        LocalPlayer():ChatPrint("You must be a direct control xeno to use this.")
        return 
    end
    
    local animName = args[1] or "standing_idle"
    local seq = LocalPlayer():LookupSequence(animName)
    
    if seq >= 0 then
        LocalPlayer():SetSequence(seq)
        LocalPlayer():SetCycle(0) 
        LocalPlayer():SetPlaybackRate(1)
        LocalPlayer():ChatPrint("Forced animation: " .. animName .. " (seq " .. seq .. ")")
    else
        LocalPlayer():ChatPrint("Animation not found: " .. animName)
        LocalPlayer():ChatPrint("Try: standing_idle, walk, run, crawl_idle, crawl_walk, strafe_left, etc.")
    end
end)

-- Command to toggle movement mode manually
concommand.Add("cm15_toggle_mode", function()
    if not IsValid(LocalPlayer()) then return end
    if not LocalPlayer():GetNWBool("IsDirectXeno", false) then return end
    
    local steamID = LocalPlayer():SteamID()
    InitPlayerMovement(steamID)
    
    local currentMode = playerMovementMode[steamID]
    local newMode = (currentMode == "standing") and "crawling" or "standing"
    playerMovementMode[steamID] = newMode
    
    LocalPlayer():ChatPrint("Movement mode: " .. string.upper(newMode))
end)