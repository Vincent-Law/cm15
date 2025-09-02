-- entities/weapons/weapon_xeno_claws/shared.lua
AddCSLuaFile()

-- Don't include - copy the base weapon properties directly
SWEP.PrintName = "Xenomorph Claws"
SWEP.Category = "CM15 Xenomorph"
SWEP.Spawnable = false

-- Copy all base properties
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1  
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.2

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands = false

-- Xeno-specific properties
SWEP.XenoWeapon = true
SWEP.XenoType = "Claws"
SWEP.AttackRange = 80
SWEP.AttackDamage = 40
SWEP.AttackSound = "vj_avp/aliens/alien_claw.wav"
SWEP.DeploySound = "vj_avp/aliens/alien_hiss.wav"

function SWEP:Initialize()
    self:SetHoldType("fist")
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    if IsValid(owner) and owner:GetNWBool("IsXenomorph") then
        if self.DeploySound then
            self:EmitSound(self.DeploySound)
        end
        return true
    end
    return false
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    
    local owner = self:GetOwner()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    
    owner:SetAnimation(PLAYER_ATTACK1)
    
    if self.AttackSound then
        self:EmitSound(self.AttackSound)
    end
    
    local trace = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * self.AttackRange,
        filter = owner,
        mask = MASK_SHOT_HULL
    })
    
    if SERVER and trace.Hit and IsValid(trace.Entity) then
        local dmg = DamageInfo()
        dmg:SetDamage(self.AttackDamage)
        dmg:SetAttacker(owner)
        dmg:SetInflictor(self)
        dmg:SetDamageType(DMG_SLASH)
        dmg:SetDamagePosition(trace.HitPos)
        
        trace.Entity:TakeDamageInfo(dmg)
        
        local effect = EffectData()
        effect:SetOrigin(trace.HitPos)
        effect:SetNormal(trace.HitNormal)
        util.Effect("BloodImpact", effect)
    end
end

function SWEP:SecondaryAttack()
    if not IsValid(self:GetOwner()) then return end
    
    local owner = self:GetOwner()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
    
    owner:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("vj_avp/aliens/alien_roar.wav")
    
    local trace = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * (self.AttackRange * 1.5),
        filter = owner,
        mask = MASK_SHOT_HULL
    })
    
    if SERVER and trace.Hit and IsValid(trace.Entity) then
        local dmg = DamageInfo()
        dmg:SetDamage(self.AttackDamage * 1.6)
        dmg:SetAttacker(owner)
        dmg:SetInflictor(self)
        dmg:SetDamageType(DMG_SLASH)
        dmg:SetDamagePosition(trace.HitPos)
        
        trace.Entity:TakeDamageInfo(dmg)
        
        -- Knockback
        if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
            trace.Entity:SetVelocity(owner:GetAimVector() * 300 + Vector(0, 0, 100))
        end
        
        local effect = EffectData()
        effect:SetOrigin(trace.HitPos)
        effect:SetNormal(trace.HitNormal)
        util.Effect("BloodImpact", effect)
    end
end