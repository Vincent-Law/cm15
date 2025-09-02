-- gamemodes/cm15/gamemode/server/sv_xeno_movement.lua
-- Server-side xeno movement mode handling

CM15_XenoMovement = CM15_XenoMovement or {}

-- Track player movement modes on server
local PlayerMovementModes = {}

-- Movement speed configurations
local MOVEMENT_SPEEDS = {
    standing = {
        walk = 200,
        run = 350,
        sneak = 80
    },
    crawling = {
        walk = 280,    -- Faster in crawling mode
        run = 450,     -- Faster sprint when crawling  
        sneak = 120    -- Faster sneak when crawling
    }
}

-- Initialize player movement mode
local function InitPlayerMovement(steamID)
    if not PlayerMovementModes[steamID] then
        PlayerMovementModes[steamID] = "standing"
    end
end

-- Get player's current movement mode
function CM15_XenoMovement.GetPlayerMode(ply)
    if not IsValid(ply) then return "standing" end
    local steamID = ply:SteamID()
    InitPlayerMovement(steamID)
    return PlayerMovementModes[steamID]
end

-- Set player's movement mode
function CM15_XenoMovement.SetPlayerMode(ply, mode)
    if not IsValid(ply) then return end
    if mode ~= "standing" and mode ~= "crawling" then return end
    
    local steamID = ply:SteamID()
    PlayerMovementModes[steamID] = mode
    
    -- Update movement speeds immediately
    CM15_XenoMovement.UpdatePlayerSpeeds(ply)
    
    -- Sync to client
    net.Start("CM15_XenoModeSync")
    net.WriteString(mode)
    net.Send(ply)
end

-- Update player movement speeds based on current mode
function CM15_XenoMovement.UpdatePlayerSpeeds(ply)
    if not IsValid(ply) then return end
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local mode = CM15_XenoMovement.GetPlayerMode(ply)
    local speeds = MOVEMENT_SPEEDS[mode]
    
    if speeds then
        ply:SetWalkSpeed(speeds.walk)
        ply:SetRunSpeed(speeds.run)
        -- Store sneak speed for reference
        ply:SetNWFloat("XenoSneakSpeed", speeds.sneak)
    end
end

-- Handle movement mode changes from client
net.Receive("CM15_XenoModeChange", function(len, ply)
    if not IsValid(ply) then return end
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local newMode = net.ReadString()
    if newMode ~= "standing" and newMode ~= "crawling" then return end
    
    CM15_XenoMovement.SetPlayerMode(ply, newMode)
    
    -- Optional: Add sound effect for mode change
    local soundFile = (newMode == "crawling") and "npc/headcrab/headcrab_attack1.wav" or "npc/zombie/foot1.wav"
    ply:EmitSound(soundFile, 50, math.random(80, 120))
end)

-- Think hook to handle movement speed adjustments
hook.Add("Think", "CM15_XenoMovementThink", function()
    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        if not ply:GetNWBool("IsDirectXeno", false) then continue end
        if not ply:Alive() then continue end
        
        local mode = CM15_XenoMovement.GetPlayerMode(ply)
        local speeds = MOVEMENT_SPEEDS[mode]
        if not speeds then continue end
        
        -- Handle sneaking (Ctrl key)
        if ply:KeyDown(IN_DUCK) then
            -- Apply sneak speed
            if ply:GetWalkSpeed() ~= speeds.sneak then
                ply:SetWalkSpeed(speeds.sneak)
                ply:SetRunSpeed(speeds.sneak) -- Same speed for run while sneaking
            end
        else
            -- Apply normal speeds
            if ply:GetWalkSpeed() ~= speeds.walk then
                ply:SetWalkSpeed(speeds.walk)
                ply:SetRunSpeed(speeds.run)
            end
        end
    end
end)

-- Initialize movement mode when xeno spawns
hook.Add("PlayerSpawn", "CM15_XenoMovementInit", function(ply)
    if not IsValid(ply) then return end
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    timer.Simple(0.1, function()
        if IsValid(ply) then
            CM15_XenoMovement.UpdatePlayerSpeeds(ply)
        end
    end)
end)

-- Clean up on disconnect
hook.Add("PlayerDisconnected", "CM15_XenoMovementCleanup", function(ply)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID()
    PlayerMovementModes[steamID] = nil
end)

-- Admin command to set movement mode
concommand.Add("cm15_set_xeno_mode", function(ply, cmd, args)
    if not CM15_Admin or not CM15_Admin.IsAdmin(ply) then 
        ply:ChatPrint("Admin only command.")
        return 
    end
    
    if not ply:GetNWBool("IsDirectXeno", false) then
        ply:ChatPrint("You must be a direct control xeno.")
        return
    end
    
    local mode = args[1]
    if mode ~= "standing" and mode ~= "crawling" then
        ply:ChatPrint("Usage: cm15_set_xeno_mode <standing|crawling>")
        return
    end
    
    CM15_XenoMovement.SetPlayerMode(ply, mode)
    ply:ChatPrint("[ADMIN] Movement mode set to: " .. mode)
end)

-- Debug command for testing speeds
concommand.Add("cm15_debug_xeno_speeds", function(ply, cmd, args)
    if not IsValid(ply) then return end
    if not ply:GetNWBool("IsDirectXeno", false) then return end
    
    local mode = CM15_XenoMovement.GetPlayerMode(ply)
    ply:ChatPrint("=== XENO MOVEMENT DEBUG ===")
    ply:ChatPrint("Current Mode: " .. mode)
    ply:ChatPrint("Walk Speed: " .. ply:GetWalkSpeed())
    ply:ChatPrint("Run Speed: " .. ply:GetRunSpeed())
    ply:ChatPrint("Sneak Speed: " .. ply:GetNWFloat("XenoSneakSpeed", 80))
    ply:ChatPrint("Is Sneaking: " .. tostring(ply:KeyDown(IN_DUCK)))
end)