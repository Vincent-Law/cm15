-- gamemodes/cm15/gamemode/client/cl_xeno_animations.lua
-- COMPLETE REPLACEMENT - This bypasses GMod's animation system entirely

-- Remove ALL existing animation hooks to prevent conflicts
hook.Remove("CalcMainActivity", "CM15_XenoMainActivity")  
hook.Remove("TranslateActivity", "CM15_XenoTranslateActivity")
hook.Remove("UpdateAnimation", "CM15_XenoUpdateAnimation")

-- Direct animation control - even more aggressive approach
local lastSetSequence = {}
local sequenceResetCount = {}
local lastCycle = {}

hook.Add("Think", "CM15_XenoDirectAnimationControl", function()
    for _, ply in pairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        if not ply:GetNWBool("IsDirectXeno", false) then continue end
        
        local steamID = ply:SteamID()
        local velocity = ply:GetVelocity():Length2D()
        local currentSeq = ply:GetSequence()
        local currentCycle = ply:GetCycle()
        local targetSeq = 11  -- Default to standing_idle
        local seqName = "standing_idle"
        
        -- Determine target animation based on movement
        if velocity > 250 then
            -- Running
            local runSeq = ply:LookupSequence("run")
            if runSeq >= 0 then
                targetSeq = runSeq
                seqName = "run"
            else
                local walkSeq = ply:LookupSequence("walk")  
                if walkSeq >= 0 then
                    targetSeq = walkSeq
                    seqName = "walk"
                end
            end
        elseif velocity > 0.5 then
            -- Walking
            local walkSeq = ply:LookupSequence("walk")
            if walkSeq >= 0 then
                targetSeq = walkSeq
                seqName = "walk"
            end
        end
        
        -- Track what we've set vs what it actually is
        local lastSet = lastSetSequence[steamID]
        local prevCycle = lastCycle[steamID] or 0
        
        -- Check if animation has finished/stopped progressing
        local animationStopped = (currentCycle >= 0.99) or (currentCycle == prevCycle and currentCycle > 0)
        
        if currentSeq ~= targetSeq then
            -- Different animation needed
            ply:SetSequence(targetSeq)
            ply:SetCycle(0)
            ply:SetPlaybackRate(1.0)
            lastSetSequence[steamID] = targetSeq
            
            -- Only print when we actually change to a different animation
            if lastSet ~= targetSeq then
                print("[CM15] Animation changed: " .. ply:Nick() .. " -> " .. seqName .. " (seq " .. targetSeq .. ") vel=" .. math.Round(velocity, 1))
            end
        elseif animationStopped and currentSeq == targetSeq then
            -- Same animation but it stopped - restart it
            ply:SetCycle(0)
            ply:SetPlaybackRate(1.0)
            print("[CM15] Looping animation: " .. seqName .. " (cycle was " .. math.Round(currentCycle, 2) .. ")")
        end
        
        -- Store current cycle for next check
        lastCycle[steamID] = currentCycle
        
        -- Handle playback rate
        if velocity > 0.2 then
            local rate = math.Clamp(velocity / 200, 0.5, 2.0)
            ply:SetPlaybackRate(rate)
        else
            ply:SetPlaybackRate(1.0)
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

-- Debug overlay
local showDebug = false
concommand.Add("cm15_anim_overlay", function()
    showDebug = not showDebug
    LocalPlayer():ChatPrint("Xeno animation overlay: " .. (showDebug and "ON" or "OFF"))
end)

hook.Add("HUDPaint", "CM15_XenoAnimDebugOverlay", function()
    if not showDebug then return end
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local x, y = 10, 10
    
    surface.SetTextColor(255, 255, 255, 255)
    surface.SetFont("DermaDefault")
    
    local lines = {
        "=== XENO DIRECT CONTROL ===",
        "Model: " .. ply:GetModel(),
        "Sequence: " .. ply:GetSequence() .. " (" .. (ply:GetSequenceName(ply:GetSequence()) or "unknown") .. ")",
        "Velocity: " .. math.Round(ply:GetVelocity():Length2D(), 1),
        "On Ground: " .. tostring(ply:OnGround()),
        "Playback Rate: " .. math.Round(ply:GetPlaybackRate(), 2),
        "Cycle: " .. math.Round(ply:GetCycle(), 2)
    }
    
    for i, line in ipairs(lines) do
        surface.SetTextPos(x, y + (i - 1) * 15)
        surface.DrawText(line)
    end
end)

-- Test command
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
        
        timer.Simple(1, function()
            if IsValid(LocalPlayer()) then
                local currentSeq = LocalPlayer():GetSequence()
                LocalPlayer():ChatPrint("After 1 second: sequence " .. currentSeq)
            end
        end)
    else
        LocalPlayer():ChatPrint("Animation not found: " .. animName)
    end
end)