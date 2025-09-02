-- gamemodes/cm15/gamemode/player_classes/player_xeno_warrior.lua
-- REPLACE YOUR EXISTING PLAYER CLASS WITH THIS SIMPLIFIED VERSION

AddCSLuaFile()

PLAYER_CLASS = {}

-- Basic properties
PLAYER_CLASS.DisplayName = "Xenomorph Warrior"
PLAYER_CLASS.WalkSpeed = 200
PLAYER_CLASS.RunSpeed = 350
PLAYER_CLASS.CrouchedWalkSpeed = 0.3
PLAYER_CLASS.DuckSpeed = 0.3
PLAYER_CLASS.UnDuckSpeed = 0.3
PLAYER_CLASS.JumpPower = 300
PLAYER_CLASS.TeammateNoCollide = true
PLAYER_CLASS.CanUseFlashlight = false
PLAYER_CLASS.MaxHealth = 150
PLAYER_CLASS.StartArmor = 0
PLAYER_CLASS.StartHealth = 150
PLAYER_CLASS.DropWeaponOnDie = false
PLAYER_CLASS.UseVMHands = false

-- Xeno-specific properties
PLAYER_CLASS.XenoType = "Warrior"
PLAYER_CLASS.XenoModel = "models/cpthazama/avp/xeno/warrior.mdl"
PLAYER_CLASS.XenoWeapons = {} -- We'll add weapons later

function PLAYER_CLASS:Spawn(ply)
    -- Set model
    ply:SetModel(self.XenoModel)
    
    -- Hull size for xeno
    ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
    ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
    ply:SetViewOffset(Vector(0, 0, 64))
    ply:SetViewOffsetDucked(Vector(0, 0, 32))
    
    -- Dark appearance
    ply:SetColor(Color(15, 15, 15, 255))
    
    -- Set xeno flags
    ply:SetNWBool("IsDirectXeno", true)
    ply:SetNWString("XenoType", self.XenoType)
    
    -- Strip weapons for now
    ply:StripWeapons()
    
    -- Give basic weapons if any are defined
    for _, weapon in ipairs(self.XenoWeapons) do
        ply:Give(weapon)
    end
    
    -- Messages
    ply:ChatPrint("You are a Xenomorph Warrior!")
    ply:ChatPrint("Use WASD to move, Space to jump")
end

function PLAYER_CLASS:Think(ply)
    -- Basic think - we don't need to do anything here anymore
    -- The animation system handles everything client-side
end

function PLAYER_CLASS:OnDeath(ply)
    -- Death effects
    if IsValid(ply) then
        ply:EmitSound("ambient/explosions/explode_4.wav")
        
        -- Create acid splash effect
        local effect = EffectData()
        effect:SetOrigin(ply:GetPos())
        effect:SetScale(2)
        util.Effect("Explosion", effect)
    end
end

-- Register the class
player_manager.RegisterClass("xeno_warrior", PLAYER_CLASS, "player_default")