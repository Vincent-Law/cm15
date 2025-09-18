-- PLACE THIS FILE AT: lua/weapons/weapon_cm15_xeno_warrior.lua
-- COMPLETELY CLEAN VERSION - NO OLD 312 CODE

SWEP.Base = "weapon_base"
SWEP.PrintName = "Xenomorph Warrior"
SWEP.Author = "CM15"
SWEP.Category = "CM15 - Aliens"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 130

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.UseHands = false

-- Warrior specific variables
SWEP.IsCrawling = false
SWEP.NextCrawlToggle = 0
SWEP.CrawlSpeedBuildup = 0
SWEP.NextSpeedBuild = 0
SWEP.BurstPlayed = false
SWEP.NextAttack = 0
SWEP.IsAttacking = false
SWEP.AttackEndTime = 0

-- NEW Charge attack variables
SWEP.IsCharging = false
SWEP.ChargeStartTime = 0
SWEP.ChargeLevel = 0
SWEP.QuickTapTime = 0.15


-- Taunt sounds for normal claw attacks
SWEP.SoundTbl_Attack = {
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_04.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_06.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_08.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_10.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_12.ogg",
}

-- Jump grunts for jumping attacks (future use)
SWEP.SoundTbl_JumpAttack = {
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_03.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_05.ogg",
}

SWEP.SoundTbl_Jump = {
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_03.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_jump_grunt_04.ogg",
}

SWEP.SoundTbl_ClawHit = {
    "cpthazama/avp/weapons/alien/claws/alien_claw_impact_flesh_01.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_impact_flesh_02.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_impact_flesh_03.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_impact_flesh_04.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_impact_flesh_05.ogg",
}

SWEP.SoundTbl_ClawMiss = {
    "cpthazama/avp/weapons/alien/claws/alien_claw_swipe_01.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_swipe_02.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_swipe_03.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_swipe_04.ogg",
    "cpthazama/avp/weapons/alien/claws/alien_claw_swipe_05.ogg",
}

SWEP.SoundTbl_TailHit = {
    "cpthazama/avp/weapons/alien/tail/alien_tail_impact_flesh_01.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tail_impact_flesh_02.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tail_impact_flesh_03.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tail_impact_flesh_04.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tail_impact_flesh_05.ogg",
}

SWEP.SoundTbl_TailMiss = {
    "cpthazama/avp/weapons/alien/tail/alien_tailswipe_tp_1.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tailswipe_tp_2.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tailswipe_tp_3.ogg",
    "cpthazama/avp/weapons/alien/tail/alien_tailswipe_tp_4.ogg",
}

function SWEP:Initialize()
    self:SetHoldType("normal")
    
    -- Initialize attack state
    self.IsAttacking = false
    self.IsCharging = false
    self.AttackEndTime = 0
    
    if CLIENT then
        -- Initialize HUD materials
        self.matHud = Material("hud/cpthazama/avp/alien_hud.png", "smooth additive")
        self.matHP = Material("hud/cpthazama/avp/avp_a_health_bar_new.png", "smooth additive")
        self.matHP_Base = Material("hud/cpthazama/avp/avp_a_health_bg_full.png", "smooth additive")
        self.matHP_Full = Material("hud/cpthazama/avp/avp_a_health_bar_full.png", "smooth additive")
        self.matOrient = Material("hud/cpthazama/avp/avp_a_orient_ret2.png", "smooth additive")
        
        -- Stance icons
        self.matStandIcon = Material("materials/hud/xeno_stand.png", "smooth")
        self.matCrawlIcon = Material("materials/hud/xeno_crawl.png", "smooth")
        
        -- Fallback materials if AVP ones don't exist
        if not self.matHud or self.matHud:IsError() then
            self.matHud = Material("vgui/white")
        end
        if not self.matHP or self.matHP:IsError() then
            self.matHP = Material("vgui/white")
        end
        
        self.HPLerp = 0
        self.HPColor = Vector(191, 255, 127)
    end
end

function SWEP:PlayXenoSound(soundTable, level, pitch)
    if not soundTable or #soundTable == 0 then return end
    local sound = soundTable[math.random(1, #soundTable)]
    self:GetOwner():EmitSound(sound, level or 75, pitch or 100)
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    if IsValid(owner) and owner:IsPlayer() then
        self:UpdateMovementSpeed()
        
        if SERVER then
            self.IsCrawling = owner:GetNWBool("IsCrawling", false)
            if self.SetCrawlingMode then
                self:SetCrawlingMode(self.IsCrawling)
            end
        end
    end
    return true
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "CrawlingMode")
end

function SWEP:Think()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if SERVER then
        -- Clear forced attack sequences after they expire
        local forceEnd = owner:GetNWFloat("ForceSequenceEnd", 0)
        if forceEnd > 0 and CurTime() >= forceEnd then
            owner:SetNWInt("ForceSequence", 0)
            owner:SetNWFloat("ForceSequenceEnd", 0)
        end
        
        -- Handle charge attack
        if self.IsCharging then
            if not owner:KeyDown(IN_ATTACK2) then
                local holdTime = CurTime() - self.ChargeStartTime
                self:UpdateMovementSpeed()
                
                if holdTime <= self.QuickTapTime then
                    self:DoQuickTailStab()
                else
                    self:FinishChargeAttack()
                end
            else
                local chargeTime = CurTime() - self.ChargeStartTime
                local newLevel = 1
                
                if chargeTime >= 1.0 then
                    newLevel = 3
                elseif chargeTime >= 0.5 then
                    newLevel = 2
                else
                    newLevel = 1
                end
                
                if newLevel ~= self.ChargeLevel then
                    self.ChargeLevel = newLevel
                    if newLevel == 2 then
                        owner:EmitSound("cpthazama/avp/weapons/alien/spit/aln_pre_spit_attack_01.ogg", 50, 120)
                    elseif newLevel == 3 then
                        owner:EmitSound("cpthazama/avp/weapons/alien/spit/aln_pre_spit_attack_02.ogg", 60, 100)
                    end
                end
            end
        end
        
        -- Handle attack state cleanup - SHORTENED TIMING
        if self.IsAttacking and CurTime() >= self.AttackEndTime then
            self.IsAttacking = false
            self.AttackEndTime = 0
            self:UpdateMovementSpeed() -- Restore movement immediately
        end
        
        -- Handle crawl toggle
        if owner:KeyPressed(IN_DUCK) and CurTime() > self.NextCrawlToggle then
            self:ToggleCrawlMode()
        end
        
        -- Update movement speeds
        if not self.IsAttacking and not self.IsCharging then
            self:UpdateMovementSpeed()
        end
        
        -- Handle crawl sprint buildup
        if self.IsCrawling and not self.IsAttacking and not self.IsCharging then
            self:HandleCrawlSprint()
        end
    end
end

function SWEP:ToggleCrawlMode()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    self.IsCrawling = not self.IsCrawling
    self.NextCrawlToggle = CurTime() + 0.5
    
    if self.SetCrawlingMode then
        self:SetCrawlingMode(self.IsCrawling)
    end
    owner:SetNWBool("IsCrawling", self.IsCrawling)
    
    if self.IsCrawling then
        owner:SetHull(Vector(-16, -16, 0), Vector(16, 16, 36))
        owner:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
        owner:SetViewOffset(Vector(0, 0, 32))
        owner:SetViewOffsetDucked(Vector(0, 0, 32))
        owner:ChatPrint("Crawling mode")
        self.CrawlSpeedBuildup = 0
        self.BurstPlayed = false
    else
        owner:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
        owner:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
        owner:SetViewOffset(Vector(0, 0, 64))
        owner:SetViewOffsetDucked(Vector(0, 0, 32))
        owner:ChatPrint("Standing mode")
        self.CrawlSpeedBuildup = 0
        self.BurstPlayed = false
    end
    
    self:UpdateMovementSpeed()
end

function SWEP:HandleCrawlSprint()
    local owner = self:GetOwner()
    if not owner:KeyDown(IN_SPEED) or owner:GetVelocity():Length2D() <= 10 then
        if self.CrawlSpeedBuildup > 0 then
            self.CrawlSpeedBuildup = math.max(self.CrawlSpeedBuildup - 0.2, 0)
            self.BurstPlayed = false
            self:UpdateMovementSpeed()
        end
        return
    end
    
    local vel = owner:GetVelocity()
    local forward = owner:EyeAngles():Forward()
    forward.z = 0
    forward:Normalize()
    vel.z = 0
    
    local dot = vel:GetNormalized():Dot(forward)
    
    if dot > 0.9 and CurTime() > self.NextSpeedBuild then
        if self.CrawlSpeedBuildup < 1 then
            self.CrawlSpeedBuildup = math.min(self.CrawlSpeedBuildup + 0.1, 1)
            self.NextSpeedBuild = CurTime() + 0.1
            self:UpdateMovementSpeed()
        end
    elseif dot <= 0.9 then
        if self.CrawlSpeedBuildup > 0 then
            self.CrawlSpeedBuildup = math.max(self.CrawlSpeedBuildup - 0.3, 0)
            self.BurstPlayed = false
            self:UpdateMovementSpeed()
        end
    end
end

function SWEP:UpdateMovementSpeed()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if self.IsCrawling then
        if owner:KeyDown(IN_SPEED) then
            local vel = owner:GetVelocity()
            local forward = owner:EyeAngles():Forward()
            forward.z = 0
            forward:Normalize()
            vel.z = 0
            
            local dot = vel:Length2D() > 10 and vel:GetNormalized():Dot(forward) or 0
            
            if dot > 0.9 then
                local baseSpeed = 250
                local maxSpeed = 490
                local currentSpeed = baseSpeed + (maxSpeed - baseSpeed) * self.CrawlSpeedBuildup
                owner:SetWalkSpeed(currentSpeed)
                owner:SetRunSpeed(currentSpeed)
            else
                owner:SetWalkSpeed(188)
                owner:SetRunSpeed(188)
            end
        else
            owner:SetWalkSpeed(120)
            owner:SetRunSpeed(120)
        end
    else
        if owner:KeyDown(IN_SPEED) then
            local vel = owner:GetVelocity()
            local forward = owner:EyeAngles():Forward()
            forward.z = 0
            forward:Normalize()
            vel.z = 0
            
            local dot = vel:Length2D() > 10 and vel:GetNormalized():Dot(forward) or 0
            
            if dot > 0.9 then
                owner:SetWalkSpeed(400)
                owner:SetRunSpeed(400)
            else
                owner:SetWalkSpeed(200)
                owner:SetRunSpeed(300)
            end
        else
            owner:SetWalkSpeed(200)
            owner:SetRunSpeed(300)
        end
    end
end

function SWEP:SetupMove(ply, mv, cmd)
    if ply ~= self:GetOwner() then return end
    
    if mv:KeyPressed(IN_JUMP) then
        if self.IsCrawling then
            -- Crawling jump behaviors
            local forward = mv:GetForwardSpeed()
            local side = mv:GetSideSpeed()
            
            if math.abs(side) > 10 and math.abs(forward) < 10 then
                -- Pure left/right dodge while crawling
                if side < 0 then -- Left
                    self:DoCrawlingDodge(145, "left")
                else -- Right
                    self:DoCrawlingDodge(146, "right")
                end
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            elseif forward > 10 and side < 5 and side > -5 then
                -- Forward jump while crawling - sequence 206
                self:DoCrawlingJump(206)
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            elseif math.abs(forward) < 10 and math.abs(side) < 10 then
                -- No movement jump while crawling - sequence 203
                self:DoCrawlingJump(203)
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            else
                -- Block all other movement combinations (including backward)
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            end
        else
            -- Standing jump behaviors (existing code)
            if ply:OnGround() then
                local forward = mv:GetForwardSpeed()
                local side = mv:GetSideSpeed()
                local sprinting = ply:KeyDown(IN_SPEED)
                
                -- Check for dodge left/right while standing
                if math.abs(side) > 10 and math.abs(forward) < 10 then
                    if side < 0 then -- Left dodge
                        self:DoStandingDodge("left")
                    else -- Right dodge
                        self:DoStandingDodge("right")
                    end
                    mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                    return
                end
                
                if forward > 10 then
                    if sprinting and ply:GetVelocity():Length2D() > 300 then
                        mv:SetUpSpeed(400)
                        local vel = mv:GetVelocity()
                        mv:SetVelocity(vel + ply:GetForward() * 500)
                    else
                        mv:SetUpSpeed(350)
                        local vel = mv:GetVelocity()
                        mv:SetVelocity(vel + ply:GetForward() * 300)
                    end
                elseif math.abs(forward) < 10 and math.abs(side) < 10 then
                    mv:SetUpSpeed(300)
                else
                    mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                    if SERVER then
                        ply:ChatPrint("Xenomorphs can only jump forward!")
                    end
                end
            end
        end
    end
end

function SWEP:RunDamageCode(damageMultiplier, range, damageType, damageAmount)
    local owner = self:GetOwner()
    if not IsValid(owner) then return {} end
    
    damageMultiplier = damageMultiplier or 1
    range = range or 120
    damageType = damageType or DMG_SLASH
    damageAmount = (damageAmount or 25) * damageMultiplier
    
    local hitEnts = {}
    local eyePos = owner:EyePos()
    local aimDir = owner:GetAimVector()
    
    local searchPos = eyePos + aimDir * (range * 0.5)
    for _, ent in pairs(ents.FindInSphere(searchPos, range)) do
        if ent ~= owner and IsValid(ent) then
            local isValidTarget = false
            
            if ent:IsPlayer() then
                if ent:Team() ~= TEAM_ALIENS then
                    isValidTarget = true
                end
            elseif ent:IsNPC() then
                isValidTarget = true
            elseif ent:GetClass() == "prop_ragdoll" then
                isValidTarget = true
            end
            
            if isValidTarget then
                local toTarget = (ent:GetPos() + ent:OBBCenter() - eyePos):GetNormalized()
                if aimDir:Dot(toTarget) > 0.7 then
                    local dmg = DamageInfo()
                    dmg:SetDamage(damageAmount)
                    dmg:SetDamageType(damageType)
                    dmg:SetAttacker(owner)
                    dmg:SetInflictor(self)
                    dmg:SetDamagePosition(ent:GetPos() + ent:OBBCenter())
                    ent:TakeDamageInfo(dmg)
                    
                    local effect = EffectData()
                    effect:SetOrigin(ent:GetPos() + ent:OBBCenter())
                    effect:SetNormal(-aimDir)
                    util.Effect("BloodImpact", effect)
                    
                    table.insert(hitEnts, ent)
                end
            end
        end
    end
    
    return hitEnts
end


function SWEP:PrimaryAttack()
    if CurTime() < self.NextAttack then return end
    if self.IsAttacking or self.IsCharging then return end
    
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.35
    self.NextAttack = CurTime() + 0.4
    
    if SERVER then
        owner:SetWalkSpeed(1)
        owner:SetRunSpeed(1)
    end
    
    self.SwingCount = (self.SwingCount or 0) + 1
    
    local attackAnim, damageDelay
    
    if self.IsCrawling then
        -- Crawling attacks - alternate between 70 and 72
        if not self.LastCrawlingAttack then
            self.LastCrawlingAttack = 70
        end
        
        attackAnim = (self.LastCrawlingAttack == 70) and 72 or 70
        self.LastCrawlingAttack = attackAnim
        damageDelay = 0.15
    else
        -- Standing attacks - alternate between 242 and 243
        if not self.LastStandingAttack then
            self.LastStandingAttack = 242
        end
        
        attackAnim = (self.LastStandingAttack == 242) and 243 or 242
        self.LastStandingAttack = attackAnim
        damageDelay = 0.15
        
        if SERVER then
            timer.Simple(0.1, function()
                if IsValid(owner) and owner:OnGround() then
                    local forwardVel = owner:GetForward() * 450
                    forwardVel.z = 0
                    owner:SetVelocity(owner:GetVelocity() + forwardVel)
                end
            end)
        end
    end
    
    owner:SetNWInt("ForceSequence", attackAnim)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.35)
    
    owner:SetSequence(attackAnim)
    owner:SetCycle(0)
    owner:SetPlaybackRate(2.0)
    
    if self.SwingCount % 3 == 0 then
        self:PlayXenoSound(self.SoundTbl_Attack, 75)
    end
    
    if SERVER then
        timer.Simple(damageDelay, function()
            if not IsValid(self) or not IsValid(owner) then return end
            local hitEnts = self:RunDamageCode(1, 50, DMG_SLASH, 25)
            
            if #hitEnts > 0 then
                self:PlayXenoSound(self.SoundTbl_ClawHit, 75)
            else
                self:PlayXenoSound(self.SoundTbl_ClawMiss, 75)
            end
        end)
    end
end



function SWEP:SecondaryAttack()
    if self.IsCrawling then
        -- Crawling secondary attack - use sequence 314
        if not self.IsAttacking and CurTime() >= self.NextAttack then
            self:DoCrawlingSecondaryAttack()
        end
    else
        -- Standing secondary attack - charge system
        if not self.IsCharging and not self.IsAttacking and CurTime() >= self.NextAttack then
            self:StartChargeAttack()
        end
    end
end




function SWEP:StartChargeAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    print("[DEBUG] Starting charge attack - blocking movement input")
    
    self.IsCharging = true
    self.ChargeStartTime = CurTime()
    self.ChargeLevel = 1
    
    -- Store original position for reference
    self.ChargeStartPos = owner:GetPos()
    
    -- Set walk/run speed to nearly 0 as backup
    owner:SetWalkSpeed(1)
    owner:SetRunSpeed(1)
    
    -- Start charge animation (sequence 252)
    owner:SetNWInt("ForceSequence", 252)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 10)
    
    owner:SetSequence(252)
    owner:SetCycle(0)
    owner:SetPlaybackRate(0.8)
    
    print("[DEBUG] Set charge sequence 252, movement blocked")
    
    owner:EmitSound("cpthazama/avp/weapons/alien/spit/aln_pre_spit_attack_01.ogg", 60, 150)
end

function SWEP:DoQuickTailStab()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    self.IsCharging = false
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.25  -- Reduced from 0.4
    self.NextAttack = CurTime() + 0.35     -- Reduced from 0.6
    
    self:UpdateMovementSpeed()
    
    -- Use sequence 36 for crawling, 255 for standing
    local attackSeq = self.IsCrawling and 36 or 255
    
    owner:SetNWInt("ForceSequence", attackSeq)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.25)
    
    owner:SetSequence(attackSeq)
    owner:SetCycle(0)
    owner:SetPlaybackRate(2.5)  -- Even faster for quick stab
    
    self:PlayXenoSound(self.SoundTbl_TailMiss, 75, 140)
    
    if SERVER then
        timer.Simple(0.08, function()  -- Very quick damage
            if not IsValid(self) or not IsValid(owner) then return end
            local hitEnts = self:RunDamageCode(1.2, 150, DMG_SLASH, 30)
            
            if #hitEnts > 0 then
                self:PlayXenoSound(self.SoundTbl_TailHit, 75)
            end
        end)
    end
end

function SWEP:DoCrawlingSecondaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.35
    self.NextAttack = CurTime() + 0.5
    
    if SERVER then
        owner:SetWalkSpeed(1)
        owner:SetRunSpeed(1)
    end
    
    owner:SetNWInt("ForceSequence", 203)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.35)
    
    owner:SetSequence(314)
    owner:SetCycle(0)
    owner:SetPlaybackRate(2.0)
    
    self:PlayXenoSound(self.SoundTbl_TailMiss, 75, 120)
    
    if SERVER then
        timer.Simple(0.15, function()
            if not IsValid(self) or not IsValid(owner) then return end
            local hitEnts = self:RunDamageCode(1, 100, DMG_SLASH, 35)
            
            if #hitEnts > 0 then
                self:PlayXenoSound(self.SoundTbl_TailHit, 75)
            end
        end)
    end
end

function SWEP:DoCrawlingDodge(sequence, direction)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if self.IsAttacking or CurTime() < self.NextAttack then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.6
    self.NextAttack = CurTime() + 0.8
    
    owner:SetNWInt("ForceSequence", sequence)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.6)
    
    owner:SetSequence(sequence)
    owner:SetCycle(0)
    owner:SetPlaybackRate(1.5)
    
    if SERVER then
        timer.Simple(0.25, function()  -- Longer delay
            if IsValid(owner) then
                local dodgeVel = owner:GetRight() * (direction == "right" and 1350 or -1350)
                dodgeVel.z = 50
                owner:SetVelocity(dodgeVel)
            end
        end)
    end
end

function SWEP:DoCrawlingJump(sequence)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if self.IsAttacking or CurTime() < self.NextAttack then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.5
    self.NextAttack = CurTime() + 0.7
    
    owner:SetNWInt("ForceSequence", sequence)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.5)
    
    owner:SetSequence(sequence)
    owner:SetCycle(0)
    owner:SetPlaybackRate(1.2)
    
    if SERVER then
        if sequence == 203 then
            -- No movement hop - more vertical with slight forward momentum, delayed
            timer.Simple(0.25, function()
                if IsValid(owner) then
                    local jumpVel = Vector(0, 0, 500) + owner:GetForward() * 200  -- Add forward momentum
                    owner:SetVelocity(jumpVel)
                end
            end)
        elseif sequence == 206 then
            -- Forward jump - 10x further and faster, delayed
            timer.Simple(0.25, function()
                if IsValid(owner) then
                    local jumpVel = Vector(0, 0, 200) + owner:GetForward() * 3125
                    owner:SetVelocity(jumpVel)  -- Set velocity, don't add to existing
                end
            end)
        end
    end
end

function SWEP:DoStandingDodge(direction)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if self.IsAttacking or CurTime() < self.NextAttack then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.5
    self.NextAttack = CurTime() + 0.7
    
    local sequence = (direction == "left") and 194 or 195
    
    owner:SetNWInt("ForceSequence", sequence)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.5)
    
    owner:SetSequence(sequence)
    owner:SetCycle(0)
    owner:SetPlaybackRate(1.2)
    
    if SERVER then
        timer.Simple(0.25, function()  -- Longer delay
            if IsValid(owner) then
                local dodgeVel = owner:GetRight() * (direction == "right" and 1800 or -1800)
                dodgeVel.z = 150
                owner:SetVelocity(dodgeVel)
            end
        end)
    end
end

function SWEP:FinishChargeAttack()
    if not self.IsCharging then return end
    
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    self:UpdateMovementSpeed()
    
    local chargeTime = CurTime() - self.ChargeStartTime
    local attackSeq, attackDuration, damage, slideDistance
    
    if chargeTime < 0.5 then
        attackSeq = 255
        attackDuration = 0.3  -- Reduced from 0.5
        damage = 35
        slideDistance = 0
        self.ChargeLevel = 1
    elseif chargeTime < 1.0 then
        attackSeq = 254
        attackDuration = 0.4  -- Reduced from 0.7
        damage = 50
        slideDistance = 800
        self.ChargeLevel = 2
    else
        attackSeq = 253
        attackDuration = 0.5  -- Reduced from 1.0
        damage = 75
        slideDistance = 1200
        self.ChargeLevel = 3
    end
    
    self.IsCharging = false
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + attackDuration
    self.NextAttack = CurTime() + attackDuration + 0.1  -- Reduced gap from 0.2
    
    if slideDistance > 0 then
        local slideVel = owner:GetForward() * slideDistance
        slideVel.z = 100
        owner:SetVelocity(slideVel)
    end
    
    owner:SetNWInt("ForceSequence", attackSeq)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + attackDuration)
    
    owner:SetSequence(attackSeq)
    owner:SetCycle(0)
    owner:SetPlaybackRate(2.0)  -- Faster playback rate
    
    self:PlayXenoSound(self.SoundTbl_Attack, 80)
    
    if SERVER then
        local damageDelay = attackDuration * 0.3  -- Earlier damage timing
        timer.Simple(damageDelay, function()
            if not IsValid(self) or not IsValid(owner) then return end
            self:DealChargeTailDamage_NPC(damage)
        end)
    end
end

function SWEP:DealClawDamage()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    local eyePos = owner:EyePos()
    local aimDir = owner:GetAimVector()
    local hitSomething = false
    
    for _, ent in pairs(ents.FindInSphere(eyePos + aimDir * 50, 80)) do
        if ent ~= owner and IsValid(ent) then
            local isValidTarget = false
            
            if ent:IsPlayer() then
                if ent:Team() ~= TEAM_ALIENS then
                    isValidTarget = true
                end
            elseif ent:IsNPC() then
                isValidTarget = true
            end
            
            if isValidTarget then
                local toTarget = (ent:GetPos() - eyePos):GetNormalized()
                if aimDir:Dot(toTarget) > 0.7 then
                    local dmg = DamageInfo()
                    dmg:SetDamage(25)
                    dmg:SetDamageType(DMG_SLASH)
                    dmg:SetAttacker(owner)
                    dmg:SetInflictor(self)
                    dmg:SetDamagePosition(ent:GetPos() + ent:OBBCenter())
                    ent:TakeDamageInfo(dmg)
                    
                    local effect = EffectData()
                    effect:SetOrigin(ent:GetPos() + ent:OBBCenter())
                    effect:SetNormal(-aimDir)
                    util.Effect("BloodImpact", effect)
                    
                    hitSomething = true
                    break
                end
            end
        end
    end
    
    -- Play appropriate sound
    if hitSomething then
        self:PlayXenoSound(self.SoundTbl_ClawHit, 75)
    else
        self:PlayXenoSound(self.SoundTbl_ClawMiss, 75)
        
        -- Check for environmental impact
        local tr = util.TraceLine({
            start = eyePos,
            endpos = eyePos + aimDir * 120,
            filter = {owner, self}
        })
        if tr.Hit then
            local matType = tr.MatType
            local metallicMats = {
                [MAT_CONCRETE] = true, [MAT_METAL] = true, [MAT_VENT] = true,
                [MAT_COMPUTER] = true, [MAT_GLASS] = true, [MAT_GRATE] = true, [MAT_TILE] = true,
            }
            
            if metallicMats[matType] then
                -- Sparks effect from addon
                local effectdata = EffectData()
                effectdata:SetOrigin(tr.HitPos)
                effectdata:SetNormal(tr.HitNormal)
                effectdata:SetScale(math.Rand(1, 2))
                effectdata:SetMagnitude(math.Rand(1, 3))
                util.Effect("Sparks", effectdata)
                owner:EmitSound("cpthazama/avp/weapons/alien/claws/claw_impact_tp/alien_clawhit_metal_tp_2.ogg", 75, math.random(94, 104))
            end
        end
    end
end

function SWEP:DealChargeTailDamage_NPC(damage)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Halved radius damage range from 200 to 100
    local centerPos = owner:GetPos() + owner:OBBCenter()
    local attackRange = 100  -- Reduced from 200
    local hitTargets = {}
    local aimDir = owner:GetAimVector()
    
    for _, ent in pairs(ents.FindInSphere(centerPos, attackRange)) do
        if ent ~= owner and IsValid(ent) then
            local isValidTarget = false
            
            if ent:IsPlayer() then
                if ent:Team() ~= TEAM_ALIENS then
                    isValidTarget = true
                end
            elseif ent:IsNPC() then
                isValidTarget = true
            elseif ent:GetClass() == "prop_ragdoll" then
                isValidTarget = true
            end
            
            if isValidTarget then
                local toTarget = (ent:GetPos() + ent:OBBCenter() - centerPos):GetNormalized()
                local dot = aimDir:Dot(toTarget)
                
                local coneAngle = 0.7 - (self.ChargeLevel * 0.15)
                
                if dot > coneAngle then
                    table.insert(hitTargets, ent)
                end
            end
        end
    end
    
    local hitCount = 0
    for _, target in ipairs(hitTargets) do
        local dmg = DamageInfo()
        dmg:SetDamage(damage)
        dmg:SetDamageType(bit.bor(DMG_SLASH, DMG_VEHICLE))
        dmg:SetAttacker(owner)
        dmg:SetInflictor(self)
        dmg:SetDamagePosition(target:GetPos() + target:OBBCenter())
        target:TakeDamageInfo(dmg)
        
        local effect = EffectData()
        effect:SetOrigin(target:GetPos() + target:OBBCenter())
        effect:SetNormal(-aimDir)
        util.Effect("BloodImpact", effect)
        
        hitCount = hitCount + 1
    end
    
    if hitCount > 0 then
        self:PlayXenoSound(self.SoundTbl_TailHit, 75)
        
        if hitCount > 1 then
            owner:EmitSound("cpthazama/avp/weapons/alien/tail/alien_heavyattack_tailstab_mn_01.ogg", 75, 110)
        end
    else
        self:PlayXenoSound(self.SoundTbl_TailMiss, 75)
        
        local tr = util.TraceLine({
            start = centerPos,
            endpos = centerPos + aimDir * attackRange,
            filter = {owner, self},
            mask = MASK_SOLID_BRUSHONLY
        })
        
        if tr.Hit then
            local matType = tr.MatType
            local metallicMats = {
                [MAT_CONCRETE] = true, [MAT_METAL] = true, [MAT_VENT] = true,
                [MAT_COMPUTER] = true, [MAT_GLASS] = true, [MAT_GRATE] = true, [MAT_TILE] = true,
            }
            
            if metallicMats[matType] then
                local effectdata = EffectData()
                effectdata:SetOrigin(tr.HitPos)
                effectdata:SetNormal(tr.HitNormal)
                effectdata:SetScale(2)
                effectdata:SetMagnitude(3)
                util.Effect("Sparks", effectdata)
                owner:EmitSound("cpthazama/avp/weapons/alien/claws/claw_impact_tp/alien_clawhit_metal_tp_2.ogg", 75)
            end
        end
    end
    
    print("[DEBUG] NPC-style tail attack hit " .. hitCount .. " target(s) in " .. attackRange .. " unit radius")
end

-- CLIENT HUD
if CLIENT then
    local function ScreenPos(x, y)
        local w, h = ScrW(), ScrH()
        return {
            x = w * 0.5 + w * x * 0.01,
            y = h * 0.5 + w * y * 0.01
        }
    end

    local function ScreenScale(x, y)
        local w = ScrW()
        return {
            x = w * x * 0.01,
            y = w * y * 0.01
        }
    end

    function SWEP:DrawHUD()
        local owner = LocalPlayer()
        if not IsValid(owner) then return end
        
        -- Draw alien HUD overlay if available
        if self.matHud and not self.matHud:IsError() then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.matHud)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        end
        
        -- Helper functions from AVP addon (from your original)
        local function ScreenPos(x, y)
            local w = ScrW()
            local h = ScrH()
            local pos = {}
            pos.x = w * 0.5 + w * x * 0.01
            pos.y = h * 0.5 + w * y * 0.01
            return pos
        end

        local function ScreenScale(x, y)
            local w = ScrW()
            local h = ScrH()
            local size = {}
            size.x = (w * x * 0.01)
            size.y = (w * y * 0.01)
            return size
        end

        local function DrawIcon(mat, x, y, width, height, r, g, b, a, ang)
            surface.SetDrawColor(Color(r or 255, g or 255, b or 255, a or 255))
            surface.SetMaterial(mat)
            local pos = ScreenPos(x, y)
            local size = ScreenScale(width, height)
            surface.DrawTexturedRectRotated(pos.x, pos.y, size.x, size.y, ang or 0)
        end

        local function DrawIcon_UV(mat, x, y, width, height, uv, r, g, b, a)
            local uv = uv or {0, 0, 1, 1}
            surface.SetDrawColor(Color(r or 255, g or 255, b or 255, a or 255))
            surface.SetMaterial(mat)
            local pos = ScreenPos(x, y)
            local size = ScreenScale(width, height)
            surface.DrawTexturedRectUV(pos.x, pos.y, size.x, size.y, uv[1], uv[2], uv[3], uv[4])
        end
        
        -- Health bar (original style from your code)
        self.HPLerp = Lerp(FrameTime() * 5, self.HPLerp or 0, owner:Health())
        local maxHP = owner:GetMaxHealth()
        local hpPer = self.HPLerp / maxHP
        local hpColor = Color(191, 255, 127)
        
        if hpPer <= 0.5 and hpPer > 0.25 then
            hpColor = Color(255, 145, 0)
        elseif hpPer <= 0.24 then
            hpColor = Color(255, 0, 0)
        end
        
        DrawIcon(self.matHP_Base, 0, -22.3, 70, 5, hpColor.r, hpColor.g, hpColor.b, 255)
        DrawIcon_UV(self.matHP_Full, -22.85, -23.9, 45 * hpPer, 2.2, {0, 0, hpPer, 1}, hpColor.r, hpColor.g, hpColor.b, 255)
        
        -- Orientation reticle (original)
        DrawIcon(self.matOrient, 0, 0, 8, 8, hpColor.r, hpColor.g, hpColor.b, 255, 0)
        
        -- Stance indicator (original style with icons)
        local isCrawling = self.GetCrawlingMode and self:GetCrawlingMode() or self.IsCrawling
        local iconSize = 64
        local iconX = 50
        local iconY = ScrH() - 120
        
        -- Draw the appropriate stance icon
        surface.SetDrawColor(255, 255, 255, 200)
        if isCrawling then
            if self.matCrawlIcon and not self.matCrawlIcon:IsError() then
                surface.SetMaterial(self.matCrawlIcon)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
            end
        else
            if self.matStandIcon and not self.matStandIcon:IsError() then
                surface.SetMaterial(self.matStandIcon)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
            end
        end
        
        -- Sprint indicator for standing mode (from original)
        if not isCrawling and owner:KeyDown(IN_SPEED) then
            draw.SimpleText("SPRINT", "DermaDefaultBold", iconX + iconSize/2, iconY + iconSize + 10, Color(255, 200, 100), TEXT_ALIGN_CENTER)
        end
        
        -- Attack cooldown
        if CurTime() < self.NextAttack then
            local remaining = self.NextAttack - CurTime()
            draw.SimpleText("Attack Ready: " .. string.format("%.1f", remaining), "DermaDefault", 
                ScrW()/2, 50, Color(255, 100, 100), TEXT_ALIGN_CENTER)
        end
        
        -- Charge indicator
        if self.IsCharging then
            local chargeTime = CurTime() - self.ChargeStartTime
            local chargeText = "CHARGING: "
            local chargeColor = Color(255, 255, 100)
            
            if chargeTime >= 2.0 then
                chargeText = chargeText .. "HEAVY"
                chargeColor = Color(255, 50, 50)
            elseif chargeTime >= 1.0 then
                chargeText = chargeText .. "MEDIUM"
                chargeColor = Color(255, 150, 50)
            else
                chargeText = chargeText .. "LIGHT"
                chargeColor = Color(255, 255, 100)
            end
            
            draw.SimpleText(chargeText, "DermaDefaultBold", ScrW()/2, 80, chargeColor, TEXT_ALIGN_CENTER)
            
            -- Charge progress bar
            local barW, barH = 200, 10
            local barX, barY = ScrW()/2 - barW/2, 100
            local progress = math.min(chargeTime / 1.25, 1.0)  -- Was / 2.5, now faster
            
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawRect(barX - 2, barY - 2, barW + 4, barH + 4)
            
            surface.SetDrawColor(chargeColor.r, chargeColor.g, chargeColor.b, 255)
            surface.DrawRect(barX, barY, barW * progress, barH)
        end
        
        -- Crosshair
        local centerX, centerY = ScrW()/2, ScrH()/2
        surface.SetDrawColor(hpColor.r, hpColor.g, hpColor.b, 200)
        surface.DrawLine(centerX - 10, centerY, centerX + 10, centerY)
        surface.DrawLine(centerX, centerY - 10, centerX, centerY + 10)
    end
end

function SWEP:Reload()
end

function SWEP:Holster()
    if SERVER then
        local owner = self:GetOwner()
        if IsValid(owner) then
            self.IsAttacking = false
            self.IsCharging = false
            self.AttackEndTime = 0
            
            -- Restore normal movement
            owner:SetMoveType(MOVETYPE_WALK)
            
            owner:SetNWInt("ForceSequence", 0)
            owner:SetNWFloat("ForceSequenceEnd", 0)
        end
    end
    return true
end

function SWEP:OnRemove()
    local owner = self:GetOwner()
    if IsValid(owner) and owner:IsPlayer() then
        -- Restore normal movement
        owner:SetMoveType(MOVETYPE_WALK)
        owner:SetWalkSpeed(200)
        owner:SetRunSpeed(350)
        
        if SERVER then
            self.IsAttacking = false
            self.IsCharging = false
            self.AttackEndTime = 0
            
            owner:SetNWInt("ForceSequence", 0)
            owner:SetNWFloat("ForceSequenceEnd", 0)
        end
    end
end

-- Server-side movement hook
if SERVER then
    hook.Add("SetupMove", "XenoWarriorMovement", function(ply, mv, cmd)
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "weapon_cm15_xeno_warrior" then
            wep:SetupMove(ply, mv, cmd)
        end
    end)
end

-- Update your existing StartCommand hook
hook.Add("StartCommand", "XenoWarriorChargeBlock", function(ply, cmd)
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == "weapon_cm15_xeno_warrior" then
        if wep.IsCharging or wep.IsAttacking then  -- Added wep.IsAttacking
            cmd:SetForwardMove(0)
            cmd:SetSideMove(0)
            cmd:SetUpMove(0)
            
            local buttons = cmd:GetButtons()
            buttons = bit.band(buttons, bit.bnot(IN_FORWARD))
            buttons = bit.band(buttons, bit.bnot(IN_BACK))
            buttons = bit.band(buttons, bit.bnot(IN_MOVELEFT))
            buttons = bit.band(buttons, bit.bnot(IN_MOVERIGHT))
            buttons = bit.band(buttons, bit.bnot(IN_JUMP))
            buttons = bit.band(buttons, bit.bnot(IN_DUCK))
            buttons = bit.band(buttons, bit.bnot(IN_SPEED))
            cmd:SetButtons(buttons)
        end
    end
end)