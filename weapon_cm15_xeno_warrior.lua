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

-- Add to SWEP init:
SWEP.LastHealthQuarter = 4

-- Warrior specific variables
SWEP.IsCrawling = false
SWEP.NextCrawlToggle = 0
SWEP.CrawlSpeedBuildup = 0
SWEP.NextSpeedBuild = 0
SWEP.BurstPlayed = false
SWEP.NextAttack = 0
SWEP.IsAttacking = false
SWEP.AttackEndTime = 0

-- Add to SWEP init:
SWEP.LastSprintSound = 0
SWEP.SprintSoundCooldown = 10

-- NEW Charge attack variables
SWEP.IsCharging = false
SWEP.ChargeStartTime = 0
SWEP.ChargeLevel = 0
SWEP.QuickTapTime = 0.15

-- Add to SWEP initialization variables
SWEP.NextDodge = 0        -- 3 second cooldown for any dodge
SWEP.NextJumpTime = 0     -- 3 second cooldown for any jump
SWEP.NextTailAttack = 0   -- 10 second cooldown for standing tail

-- Add these variables to SWEP init:
SWEP.NextBreathSound = 0
SWEP.BreathSoundInterval = 8  -- Breathing every 8 seconds

-- Sound cooldown tracking
SWEP.LastTauntSound = 0
SWEP.LastTailSound = 0
SWEP.TauntCooldown = 8  -- 8 seconds between taunts
SWEP.TailSoundCooldown = 8  -- 8 seconds between tail sounds

-- Add these variables to SWEP initialization
SWEP.WasInAir = false
SWEP.FootstepsDisabledUntil = 0

-- Add these to your variable declarations
SWEP.VisionMode = 0  -- 0 = off, 1 = normal vision, 2 = six vision, 3 = grid vision
SWEP.NextVisionToggle = 0
SWEP.VisionSound = nil



-- Additional vocal sounds
SWEP.SoundTbl_Growl = {
    "cpthazama/avp/xeno/alien/vocals/alien_growl_short_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_growl_short_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_growl_short_03.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_growl_short_04.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_growl_short_05.ogg",
}

SWEP.SoundTbl_Hiss = {
    "cpthazama/avp/xeno/alien/vocals/alien_hiss_long_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_hiss_long_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_hiss_short_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_hiss_short_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_hiss_scream_long_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_hiss_scream_long_02.ogg",
}

SWEP.SoundTbl_Pain = {
    "cpthazama/avp/xeno/alien/vocals/aln_pain_small_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_pain_small_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_pain_small_03.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_pain_small_04.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_pain_small_05.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_pain_small_06.ogg",
}

SWEP.SoundTbl_DeathScream = {
    "cpthazama/avp/xeno/alien/vocals/aln_death_scream_20.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_death_scream_21.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_death_scream_22.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_death_scream_23.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_death_scream_24.ogg",
}

SWEP.SoundTbl_Spotted = {
    "cpthazama/avp/xeno/alien/vocals/alien_spotted_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_spotted_02.ogg",
}

SWEP.SoundTbl_CallScream = {
    "cpthazama/avp/xeno/alien/vocals/alien_call_scream_01.ogg",
    "cpthazama/avp/xeno/alien/vocals/alien_call_scream_02.ogg",
}

-- Add to your sound tables (near line 60)
SWEP.SoundTbl_Land = {
    "cpthazama/avp/xeno/alien/footsteps/land/alien_land_stone_10.ogg",
    "cpthazama/avp/xeno/alien/footsteps/land/alien_land_stone_11.ogg",
    "cpthazama/avp/xeno/alien/footsteps/land/alien_land_stone_12.ogg",
}

-- Taunt sounds for normal claw attacks
SWEP.SoundTbl_Attack = {
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_02.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_04.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_06.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_08.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_10.ogg",
    "cpthazama/avp/xeno/alien/vocals/aln_taunt_12.ogg",
}


-- Tail movement sounds
SWEP.SoundTbl_TailMove = {
    "cpthazama/avp/xeno/alien/bodymove/alien_tail_move_01.ogg",
    "cpthazama/avp/xeno/alien/bodymove/alien_tail_move_02.ogg",
    "cpthazama/avp/xeno/alien/bodymove/alien_tail_move_03.ogg",
}

-- Footstep sounds for different surfaces
SWEP.SoundTbl_FootstepsDirt = {
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_dirt_walk_01.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_dirt_walk_02.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_dirt_walk_03.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_dirt_walk_04.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_dirt_walk_05.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_dirt_walk_06.ogg",
}

SWEP.SoundTbl_FootstepsMetal = {
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_metal_walk_01.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_metal_walk_02.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_metal_walk_03.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_metal_walk_04.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_metal_walk_05.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_metal_walk_06.ogg",
}

SWEP.SoundTbl_FootstepsStone = {
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_stone_walk_01.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_stone_walk_02.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_stone_walk_03.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_stone_walk_04.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_stone_walk_05.ogg",
    "cpthazama/avp/xeno/alien/footsteps/new_oct_09/fs_alien_stone_walk_06.ogg",
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
    
    -- Initialize variables for sounds
    self.LastHealthQuarter = 4
    self.LastCombatIdle = 0
    self.CombatIdleInterval = 30
    
    if SERVER then
        -- Pain sound hook
        local weapon = self
        hook.Add("EntityTakeDamage", "XenoWarriorPain_" .. self:EntIndex(), function(target, dmginfo)
            if target == weapon:GetOwner() and IsValid(weapon) then
                local health = target:Health()
                local maxHealth = target:GetMaxHealth()
                local currentQuarter = math.ceil((health / maxHealth) * 4)
                
                if currentQuarter < weapon.LastHealthQuarter then
                    local painSound = "cpthazama/avp/xeno/alien/vocals/aln_pain_small_" .. string.format("%02d", math.random(1, 10)) .. ".ogg"
                    target:EmitSound(painSound, 75, math.random(90, 110))
                    weapon.LastHealthQuarter = currentQuarter
                end
            end
        end)
        
        -- Death sound hook
        hook.Add("PlayerDeath", "XenoWarriorDeath_" .. self:EntIndex(), function(victim)
            if victim == weapon:GetOwner() and IsValid(weapon) then
                -- Play both death sounds
                victim:EmitSound("cpthazama/avp/xeno/alien/vocals/alien_death_scream_iconic_elephant.ogg", 85, 100)
                timer.Simple(0.1, function()
                    if IsValid(victim) then
                        local deathSound = "cpthazama/avp/xeno/alien/vocals/aln_death_scream_" .. math.random(20, 27) .. ".ogg"
                        victim:EmitSound(deathSound, 80, 100)
                    end
                end)
            end
        end)
    end

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

if CLIENT then
    -- Vision color modification tables
    local tab_xeno = {
        ["$pp_colour_addr"] = 0.65,
        ["$pp_colour_addg"] = 0.03,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0.2,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0,
        ["$pp_colour_inv"] = 1,
    }
    
    -- Hook for screen effects
    hook.Add("RenderScreenspaceEffects", "XenoWarriorVision", function()
        local wep = LocalPlayer():GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "weapon_cm15_xeno_warrior" and wep.VisionMode > 0 then
            DrawColorModify(tab_xeno)
        end
    end)
    
    -- Hook for entity halos
    hook.Add("PreDrawHalos", "XenoWarriorHalos", function()
        local wep = LocalPlayer():GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "weapon_cm15_xeno_warrior" and wep.VisionMode > 0 then
            wep:DrawVisionHalos()
        end
    end)
    
    -- Add method for drawing halos
    function SWEP:DrawVisionHalos()
        local owner = self:GetOwner()
        if not IsValid(owner) then return end
        
        local alienEnts = {}
        local humanEnts = {}
        
        -- Categorize players by team
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply != owner and ply:Alive() then
                local dist = ply:GetPos():Distance(owner:GetPos())
                if dist < 3000 then  -- Vision range
                    if ply:Team() == TEAM_ALIENS then
                        table.insert(alienEnts, ply)
                    elseif ply:Team() == TEAM_HUMANS then
                        table.insert(humanEnts, ply)
                    end
                end
            end
        end
        
        -- Add NPCs if they exist
        for _, npc in ipairs(ents.FindByClass("npc_vj_avp_xeno_*")) do
            if IsValid(npc) then
                local dist = npc:GetPos():Distance(owner:GetPos())
                if dist < 3000 then
                    table.insert(alienEnts, npc)
                end
            end
        end
        
        -- Draw halos
        if #alienEnts > 0 then
            halo.Add(alienEnts, Color(203, 120, 120), 10, 10, 15, true, true)  -- Red-ish for aliens
        end
        if #humanEnts > 0 then
            halo.Add(humanEnts, Color(0, 170, 255), 10, 10, 15, true, true)  -- Blue for humans
        end
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
    -- We'll use SetNWFloat instead of NetworkVar for the tail attack
end

function SWEP:Think()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    
    if SERVER then
        -- Track if any sound was played this frame
        local soundPlayed = false
        
        -- Enhanced landing detection - check every frame
        if not owner:OnGround() then
            if not self.WasInAir then
                self.WasInAir = true
                self.LastAirTime = CurTime()
            end
        elseif self.WasInAir and owner:OnGround() then
            -- Just landed - play landing sound if not already handled
            if not self.JumpLandingHandled then
                local airTime = CurTime() - (self.LastAirTime or 0)
                if airTime > 0.1 then
                    self:PlayXenoSound(self.SoundTbl_Land, 75, math.random(90, 110))
                    soundPlayed = true
                end
            end
            self.WasInAir = false
            self.LastAirTime = nil
        end
        
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
                
                -- HALVED charge times
                if chargeTime >= 0.5 then  -- Was 1.0
                    newLevel = 3
                elseif chargeTime >= 0.25 then  -- Was 0.5
                    newLevel = 2
                else
                    newLevel = 1
                end
                
                if newLevel ~= self.ChargeLevel then
                    self.ChargeLevel = newLevel
                    if newLevel == 1 then
                        -- Level 1 reached immediately (no sound needed)
                    elseif newLevel == 2 then
                        -- Level 2 at 0.25 seconds
                        owner:EmitSound("cpthazama/avp/weapons/alien/spit/aln_pre_spit_attack_01.ogg", 50, 120)
                        soundPlayed = true
                    elseif newLevel == 3 then
                        -- Level 3 at 0.5 seconds
                        owner:EmitSound("cpthazama/avp/weapons/alien/spit/aln_pre_spit_attack_02.ogg", 60, 100)
                        soundPlayed = true
                    end
                end
            end
        end
        
        -- Handle attack state cleanup
        if self.IsAttacking and CurTime() >= self.AttackEndTime then
            self.IsAttacking = false
            self.AttackEndTime = 0
            self:UpdateMovementSpeed()
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
        
        -- Handle footsteps
        self:HandleFootsteps()
        
        -- Check if we're currently in combat or making noise
        local isActive = self.IsAttacking or self.IsCharging or 
                        (owner:GetVelocity():Length2D() > 50) or
                        (CurTime() < self.LastTauntSound + 1) or
                        (CurTime() < self.LastTailSound + 1) or
                        (CurTime() < self.LastFootstep + 0.5)
        
        -- Combat idle growl (only when standing)
        if not self.IsCrawling and not isActive and CurTime() > self.LastCombatIdle + self.CombatIdleInterval then
            local growlSound = "cpthazama/avp/xeno/alien/vocals/alien_growl_short_0" .. math.random(1, 5) .. ".ogg"
            owner:EmitSound(growlSound, 65, math.random(95, 105))
            self.LastCombatIdle = CurTime()
            soundPlayed = true
        end
        
        -- Breathing sound loop - only when idle and no other sounds
        if not isActive and not soundPlayed and CurTime() > self.NextBreathSound then
            owner:EmitSound("cpthazama/avp/xeno/alien/vocals/alien_breathing_steady_01.ogg", 35, 100) -- Much quieter (was 50)
            self.NextBreathSound = CurTime() + self.BreathSoundInterval
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
    
    local forward = owner:KeyDown(IN_FORWARD)
    local back = owner:KeyDown(IN_BACK)
    local left = owner:KeyDown(IN_MOVELEFT)
    local right = owner:KeyDown(IN_MOVERIGHT)
    
    local isForwardOnly = forward and not back and not left and not right
    
    if not owner:KeyDown(IN_SPEED) or not isForwardOnly or owner:GetVelocity():Length2D() <= 10 then
        if self.CrawlSpeedBuildup > 0 then
            self.CrawlSpeedBuildup = 0
            self.BurstPlayed = false
            owner:SetNWBool("CrawlSprintForward", false)
            owner:SetNWFloat("CrawlSpeedBuildup", 0)  -- Network it
            self:UpdateMovementSpeed()
        end
        return
    end
    
    if isForwardOnly then
        local vel = owner:GetVelocity()
        local forwardDir = owner:EyeAngles():Forward()
        forwardDir.z = 0
        forwardDir:Normalize()
        vel.z = 0
        
        local dot = vel:GetNormalized():Dot(forwardDir)
        
        if dot > 0.9 and CurTime() > self.NextSpeedBuild then
            if self.CrawlSpeedBuildup < 1 then
                self.CrawlSpeedBuildup = math.min(self.CrawlSpeedBuildup + 0.1, 1)
                self.NextSpeedBuild = CurTime() + 0.1
                owner:SetNWFloat("CrawlSpeedBuildup", self.CrawlSpeedBuildup)  -- Network it
                self:UpdateMovementSpeed()
            end
            
            -- Force sequence 93 when fast crawling
            if self.CrawlSpeedBuildup > 0.5 then
                owner:SetNWInt("ForceSequence", 93)
                owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.5)
                owner:SetNWBool("CrawlSprintForward", true)
            end
        else
            self.CrawlSpeedBuildup = 0
            owner:SetNWBool("CrawlSprintForward", false)
            owner:SetNWFloat("CrawlSpeedBuildup", 0)
            self:UpdateMovementSpeed()
        end
    end
end

function SWEP:UpdateMovementSpeed()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if self.IsCrawling then
        local forward = owner:KeyDown(IN_FORWARD)
        local back = owner:KeyDown(IN_BACK)
        local left = owner:KeyDown(IN_MOVELEFT)
        local right = owner:KeyDown(IN_MOVERIGHT)
        local isForwardOnly = forward and not back and not left and not right
        
        if owner:KeyDown(IN_SPEED) and isForwardOnly then
            -- Play sprint burst sound if haven't recently
            if CurTime() > self.LastSprintSound + self.SprintSoundCooldown then
                local sprintSound = "cpthazama/avp/xeno/alien/footsteps/sprint/alien_sprint_burst_0" .. math.random(1,3) .. ".ogg"
                owner:EmitSound(sprintSound, 75, 100)
                self.LastSprintSound = CurTime()
            end
            
            local baseSpeed = 300
            local maxSpeed = 750
            local currentSpeed = baseSpeed + (maxSpeed - baseSpeed) * self.CrawlSpeedBuildup
            owner:SetWalkSpeed(currentSpeed)
            owner:SetRunSpeed(currentSpeed)
        else
            owner:SetWalkSpeed(120)
            owner:SetRunSpeed(120)
        end
    else
        -- Standing mode
        local forward = owner:KeyDown(IN_FORWARD)
        local back = owner:KeyDown(IN_BACK)
        local left = owner:KeyDown(IN_MOVELEFT)
        local right = owner:KeyDown(IN_MOVERIGHT)
        
        local dirCount = 0
        if forward then dirCount = dirCount + 1 end
        if back then dirCount = dirCount + 1 end
        if left then dirCount = dirCount + 1 end
        if right then dirCount = dirCount + 1 end
        
        if owner:KeyDown(IN_SPEED) and dirCount == 1 then
            -- Play sprint burst sound if haven't recently
            if CurTime() > self.LastSprintSound + self.SprintSoundCooldown then
                local sprintSound = "cpthazama/avp/xeno/alien/footsteps/sprint/alien_sprint_burst_0" .. math.random(1,3) .. ".ogg"
                owner:EmitSound(sprintSound, 75, 100)
                self.LastSprintSound = CurTime()
            end
            
            owner:SetWalkSpeed(400)
            owner:SetRunSpeed(400)
        else
            owner:SetWalkSpeed(200)
            owner:SetRunSpeed(300)
        end
    end
end


function SWEP:SetupMove(ply, mv, cmd)
    if ply ~= self:GetOwner() then return end
    
    if mv:KeyPressed(IN_JUMP) then
        -- Check jump cooldown
        if CurTime() < self.NextJumpTime then
            mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
            return
        end
        
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
                self.NextJumpTime = CurTime() + 2  -- Set cooldown
                ply:SetNWFloat("NextJumpTime", self.NextJumpTime)
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            elseif math.abs(forward) < 10 and math.abs(side) < 10 then
                -- No movement jump while crawling - sequence 203
                self:DoCrawlingJump(203)
                self.NextJumpTime = CurTime() + 2  -- Set cooldown
                ply:SetNWFloat("NextJumpTime", self.NextJumpTime)
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            else
                -- Block all other movement combinations (including backward)
                mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
                return
            end
        else
            -- Standing jump behaviors
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
                    self:PlayXenoSound(self.SoundTbl_Jump, 70, math.random(95, 105))
                    self.NextJumpTime = CurTime() + 3  -- Set cooldown
                    ply:SetNWFloat("NextJumpTime", self.NextJumpTime)
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
                    self.NextJumpTime = CurTime() + 3  -- Set cooldown
                    ply:SetNWFloat("NextJumpTime", self.NextJumpTime)
                    self:PlayXenoSound(self.SoundTbl_Jump, 70, math.random(95, 105))
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
    
    -- Play taunt sound with cooldown
    if CurTime() > self.LastTauntSound + self.TauntCooldown then
        self:PlayXenoSound(self.SoundTbl_Attack, 75)
        self.LastTauntSound = CurTime()
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
    
    -- Check tail attack cooldown using simple variable
    if CurTime() < self.NextTailAttack then 
        owner:ChatPrint("Tail attack on cooldown: " .. string.format("%.1f", self.NextTailAttack - CurTime()) .. "s")
        return 
    end
    
    self.IsCharging = true
    self.ChargeStartTime = CurTime()
    self.ChargeLevel = 1
    self.NextTailAttack = CurTime() + 10  -- Set cooldown
    
    -- Network the cooldown time to client
    owner:SetNWFloat("NextTailAttackTime", self.NextTailAttack)
    
    self.ChargeStartPos = owner:GetPos()
    
    owner:SetWalkSpeed(1)
    owner:SetRunSpeed(1)
    
    owner:SetNWInt("ForceSequence", 252)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 10)
    
    owner:SetSequence(252)
    owner:SetCycle(0)
    owner:SetPlaybackRate(0.8)
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
        -- Add tail movement sound here
    self:PlayXenoSound(self.SoundTbl_TailMove, 65, math.random(95, 105))
    
        -- Play tail attack sound with cooldown
    if CurTime() > self.LastTailSound + self.TailSoundCooldown then
        self:PlayXenoSound(self.SoundTbl_Attack, 80)
        self.LastTailSound = CurTime()
    end
    
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
    
    owner:SetNWInt("ForceSequence", 352)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 1)
    
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

function SWEP:OnPlayerHurt()
    if math.random(1, 3) == 1 then -- 33% chance
        self:PlayXenoSound(self.SoundTbl_Pain, 75, math.random(90, 110))
    end
end

function SWEP:DoCrawlingDodge(sequence, direction)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Check cooldown
    if CurTime() < self.NextDodge then return end
    if self.IsAttacking or CurTime() < self.NextAttack then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.6
    self.NextAttack = CurTime() + 0.8
    self.NextDodge = CurTime() + 3  -- 3 second cooldown
    owner:SetNWFloat("NextDodgeTime", self.NextDodge) 
    self.FootstepsDisabledUntil = CurTime() + 0.7
    
    owner:SetNWInt("ForceSequence", sequence)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + .5)
    
    owner:SetSequence(sequence)
    owner:SetCycle(0)
    owner:SetPlaybackRate(1.5)
    
    if SERVER then
        local weapon = self  -- Store reference for timer
        
        timer.Simple(0.25, function()
            if IsValid(owner) and IsValid(weapon) then
                local dodgeVel = owner:GetRight() * (direction == "right" and 800 or -800)
                owner:SetVelocity(dodgeVel)
            end
        end)
        
        timer.Simple(0.45, function()
            if IsValid(weapon) and IsValid(owner) and owner:OnGround() then
                weapon:PlayXenoSound(weapon.SoundTbl_Land, 75, math.random(90, 110))
            end
        end)
    end
end

function SWEP:DoStandingDodge(direction)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Check cooldown
    if CurTime() < self.NextDodge then return end
    if self.IsAttacking or CurTime() < self.NextAttack then return end
    
    self.IsAttacking = true
    self.AttackEndTime = CurTime() + 0.5
    self.NextAttack = CurTime() + 0.7
    self.NextDodge = CurTime() + 3  -- 3 second cooldown
    owner:SetNWFloat("NextDodgeTime", self.NextDodge) 
    self.FootstepsDisabledUntil = CurTime() + 0.6
    
    local sequence = (direction == "left") and 194 or 195
    
    owner:SetNWInt("ForceSequence", sequence)
    owner:SetNWFloat("ForceSequenceEnd", CurTime() + 0.5)
    
    owner:SetSequence(sequence)
    owner:SetCycle(0)
    owner:SetPlaybackRate(1.2)
    
    if SERVER then
        -- Store reference to self for timer
        local weapon = self
        
        timer.Simple(0.25, function()
            if IsValid(owner) and IsValid(weapon) then
                local dodgeVel = owner:GetRight() * (direction == "right" and 1800 or -1800)
                dodgeVel.z = 200
                owner:SetVelocity(dodgeVel)
                weapon.WasInAir = true
                weapon.LastAirTime = CurTime()
                weapon.JumpLandingHandled = true  -- Flag to prevent double sound
            end
        end)
        
        -- Play landing sound at correct time with fixed self reference
        timer.Simple(0.45, function()
            if IsValid(weapon) and IsValid(owner) and owner:OnGround() then
                weapon:PlayXenoSound(weapon.SoundTbl_Land, 75, math.random(90, 110))
                weapon.JumpLandingHandled = false  -- Clear flag
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
        self.JumpLandingHandled = true  -- Flag to prevent Think() from playing sound
        
        if sequence == 203 then
            -- No movement hop
            timer.Simple(0.25, function()
                if IsValid(owner) then
                    local jumpVel = Vector(0, 0, 500) + owner:GetForward() * 200
                    owner:SetVelocity(jumpVel)
                    self.WasInAir = true
                end
            end)
            -- Landing sound for vertical jump
            timer.Simple(0.8, function()
                if IsValid(self) and IsValid(owner) and owner:OnGround() then
                    self:PlayXenoSound(self.SoundTbl_Land, 75, math.random(90, 110))
                end
                self.JumpLandingHandled = false  -- Clear flag
            end)
        elseif sequence == 206 then
            -- Forward jump
            timer.Simple(0.25, function()
                if IsValid(owner) then
                    local jumpVel = Vector(0, 0, 200) + owner:GetForward() * 3125
                    owner:SetVelocity(jumpVel)
                    self.WasInAir = true
                end
            end)
            -- Landing sound for forward jump
            timer.Simple(0.7, function()
                if IsValid(self) and IsValid(owner) and owner:OnGround() then
                    self:PlayXenoSound(self.SoundTbl_Land, 75, math.random(90, 110))
                end
                self.JumpLandingHandled = false  -- Clear flag
            end)
        end
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
    
        -- Play tail attack sound with cooldown
    if CurTime() > self.LastTailSound + self.TailSoundCooldown then
        self:PlayXenoSound(self.SoundTbl_Attack, 80)
        self.LastTailSound = CurTime()
    end
    
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
        -- Hide default GMod HUD elements for xenomorphs
    hook.Add("HUDShouldDraw", "CM15_HideDefaultHUD", function(name)
        local ply = LocalPlayer()
        if IsValid(ply) and ply:GetNWBool("IsDirectXeno", false) then  -- Added IsValid check
            if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" then
                return false
            end
        end
    end)

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
            
            -- Initialize vision materials if not done
            if not self.VisionMaterials then
                self.VisionMaterials = {
                    [0] = self.matHud,  -- Normal HUD (no vision)
                    [1] = Material("hud/cpthazama/avp/alien_hud.png", "smooth additive"),
                }
            end
            
            -- Draw appropriate HUD overlay based on vision mode
            local hudMat = self.VisionMaterials[self.VisionMode] or self.matHud
            if hudMat and not hudMat:IsError() then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(hudMat)
                surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
            end
            
            -- Helper functions (keep existing)
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
            
            -- Health bar with vision color modification
            self.HPLerp = Lerp(FrameTime() * 5, self.HPLerp or 0, owner:Health())
            local maxHP = owner:GetMaxHealth()
            local hpPer = self.HPLerp / maxHP
            local hpColor = Color(191, 255, 127)
            
            if hpPer <= 0.5 and hpPer > 0.25 then
                hpColor = Color(255, 145, 0)
            elseif hpPer <= 0.24 then
                hpColor = Color(255, 0, 0)
            end
            
            -- Invert colors when vision active
            if self.VisionMode > 0 then
                hpColor = Color(255 - hpColor.r, 255 - hpColor.g, 255 - hpColor.b)
            end
            
            -- Continue with rest of existing HUD code...
            DrawIcon(self.matHP_Base, 0, -22.3, 70, 5, hpColor.r, hpColor.g, hpColor.b, 255)
            DrawIcon_UV(self.matHP_Full, -22.85, -23.9, 45 * hpPer, 2.2, {0, 0, hpPer, 1}, hpColor.r, hpColor.g, hpColor.b, 255)

            -- Orientation reticle
            DrawIcon(self.matOrient, 0, 0, 8, 8, hpColor.r, hpColor.g, hpColor.b, 255, 0)
            
            -- Stance indicator
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



            
            -- TAIL ATTACK INDICATOR - FIXED
            if not isCrawling then
                local tailIcon = Material("materials/hud/xeno_tail.png", "smooth")
                if tailIcon and not tailIcon:IsError() then
                    local tailIconX = iconX + iconSize + 20
                    local tailIconY = iconY
                    
                    -- Get the networked tail attack time directly
                    local nextTailTime = owner:GetNWFloat("NextTailAttackTime", 0)
                    local cooldownRemaining = math.max(0, nextTailTime - CurTime())
                    local cooldownPercent = 1 - (cooldownRemaining / 10)
                    
                    -- Dim based on cooldown
                    local alpha = 50 + (150 * cooldownPercent)
                    local brightness = 100 + (155 * cooldownPercent)
                    
                    surface.SetDrawColor(brightness, brightness, brightness, alpha)
                    surface.SetMaterial(tailIcon)
                    surface.DrawTexturedRect(tailIconX, tailIconY, iconSize, iconSize)
                    
                    -- Show cooldown text if on cooldown
                    if cooldownRemaining > 0 then
                        draw.SimpleText(string.format("%.1f", cooldownRemaining), "DermaDefaultBold", 
                            tailIconX + iconSize/2, tailIconY + iconSize/2, 
                            Color(255, 100, 100, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    else
                        -- Ready indicator
                        draw.SimpleText("READY", "DermaDefault", 
                            tailIconX + iconSize/2, tailIconY + iconSize + 5, 
                            Color(100, 255, 100, 200), TEXT_ALIGN_CENTER)
                    end
                end
            end
            
            
            -- DODGE COOLDOWN INDICATOR
            local dodgeIcon = Material("materials/hud/xeno_dodge.png", "smooth")
            if dodgeIcon and not dodgeIcon:IsError() then
                local dodgeIconX = iconX  -- Same X as stance icon
                local dodgeIconY = iconY - iconSize - 20  -- Above stance icon
                
                -- Get the networked dodge time
                local nextDodgeTime = owner:GetNWFloat("NextDodgeTime", 0)
                local dodgeCooldownRemaining = math.max(0, nextDodgeTime - CurTime())
                local dodgeCooldownPercent = 1 - (dodgeCooldownRemaining / 3)  -- 3 second cooldown
                
                -- Dim based on cooldown
                local alpha = 50 + (150 * dodgeCooldownPercent)  -- Range from 50 (dimmed) to 200 (ready)
                local brightness = 100 + (155 * dodgeCooldownPercent)  -- Range from 100 to 255
                
                surface.SetDrawColor(brightness, brightness, brightness, alpha)
                surface.SetMaterial(dodgeIcon)
                surface.DrawTexturedRect(dodgeIconX, dodgeIconY, iconSize, iconSize)
                
                -- Show cooldown text if on cooldown
                if dodgeCooldownRemaining > 0 then
                    draw.SimpleText(string.format("%.1f", dodgeCooldownRemaining), "DermaDefaultBold", 
                        dodgeIconX + iconSize/2, dodgeIconY + iconSize/2, 
                        Color(255, 100, 100, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    -- Ready indicator
                    draw.SimpleText("READY", "DermaDefault", 
                        dodgeIconX + iconSize/2, dodgeIconY + iconSize + 5, 
                        Color(100, 255, 100, 200), TEXT_ALIGN_CENTER)
                end
            end  

            -- JUMP COOLDOWN INDICATOR
            local jumpIcon = Material("materials/hud/xeno_jump.png", "smooth")
            if jumpIcon and not jumpIcon:IsError() then
                local jumpIconX = iconX + iconSize + 20  -- To the right of stance icon
                local jumpIconY = iconY - iconSize - 20  -- Above stance icon, next to dodge
                
                -- Get the networked jump time
                local nextJumpTime = owner:GetNWFloat("NextJumpTime", 0)
                local jumpCooldownRemaining = math.max(0, nextJumpTime - CurTime())
                local jumpCooldownPercent = 1 - (jumpCooldownRemaining / 3)  -- 3 second cooldown (2 for crawl jumps)
                
                -- Dim based on cooldown
                local alpha = 50 + (150 * jumpCooldownPercent)  -- Range from 50 (dimmed) to 200 (ready)
                local brightness = 100 + (155 * jumpCooldownPercent)  -- Range from 100 to 255
                
                surface.SetDrawColor(brightness, brightness, brightness, alpha)
                surface.SetMaterial(jumpIcon)
                surface.DrawTexturedRect(jumpIconX, jumpIconY, iconSize, iconSize)
                
                -- Show cooldown text if on cooldown
                if jumpCooldownRemaining > 0 then
                    draw.SimpleText(string.format("%.1f", jumpCooldownRemaining), "DermaDefaultBold", 
                        jumpIconX + iconSize/2, jumpIconY + iconSize/2, 
                        Color(255, 100, 100, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    -- Ready indicator
                    draw.SimpleText("READY", "DermaDefault", 
                        jumpIconX + iconSize/2, jumpIconY + iconSize + 5, 
                        Color(100, 255, 100, 200), TEXT_ALIGN_CENTER)
                end
            end

            -- Sprint indicator for standing mode
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
                
                if chargeTime >= 0.5 then
                    chargeText = chargeText .. "HEAVY"
                    chargeColor = Color(255, 50, 50)
                elseif chargeTime >= 0.25 then
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
                local progress = math.min(chargeTime / 0.5, 1.0)  
                
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

function SWEP:PlayFootstepSound()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Trace down to get surface material
    local tr = util.TraceLine({
        start = owner:GetPos(),
        endpos = owner:GetPos() + Vector(0, 0, -50),
        filter = owner
    })
    
    if tr.Hit then
        local matType = tr.MatType
        local volume = self.IsCrawling and 35 or 45  -- Quieter when crawling
        
        if matType == MAT_METAL or matType == MAT_VENT or matType == MAT_COMPUTER then
            self:PlayXenoSound(self.SoundTbl_FootstepsMetal, volume, math.random(90, 110))
        elseif matType == MAT_CONCRETE or matType == MAT_TILE then
            self:PlayXenoSound(self.SoundTbl_FootstepsStone, volume, math.random(90, 110))
        else
            self:PlayXenoSound(self.SoundTbl_FootstepsDirt, volume, math.random(90, 110))
        end
    end
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
            
            -- Clean up hooks
            hook.Remove("EntityTakeDamage", "XenoWarriorPain_" .. self:EntIndex())
            hook.Remove("PlayerDeath", "XenoWarriorDeath_" .. self:EntIndex())
        end
        
        if CLIENT then
            -- Stop vision sound
            if self.VisionSound then
                self.VisionSound:Stop()
                self.VisionSound = nil
            end
            
            -- Remove vision hooks
            hook.Remove("RenderScreenspaceEffects", "XenoWarriorVision")
            hook.Remove("PreDrawHalos", "XenoWarriorHalos")
            hook.Remove("PlayerBindPress", "XenoWarriorVisionBind")
            
            -- Existing hook removals...
            hook.Remove("HUDShouldDraw", "CM15_HideDefaultHUD")
            hook.Remove("PlayerFootstep", "CM15_DisableDefaultFootsteps")
        end
    end
    
    -- Clean up the flashlight hook when weapon is removed
    if SERVER then
        hook.Remove("PlayerSwitchFlashlight", "XenoWarriorNoFlashlight")
    end
end

-- Footstep timing variables
SWEP.LastFootstep = 0
SWEP.FootstepDelay = 0.4  -- Time between footsteps

function SWEP:HandleFootsteps()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if CurTime() < self.FootstepsDisabledUntil then
        return
    end
    
    local velocity = owner:GetVelocity():Length2D()
    local onGround = owner:OnGround()
    
    if velocity > 50 and onGround and CurTime() > self.LastFootstep + self.FootstepDelay then
        local speedMultiplier = 1.0
        local volume = 45
        
        if self.IsCrawling then
            speedMultiplier = 0.5
            volume = 30
            
            if owner:KeyDown(IN_SPEED) and owner:KeyDown(IN_FORWARD) 
            and not owner:KeyDown(IN_BACK) and not owner:KeyDown(IN_MOVELEFT) 
            and not owner:KeyDown(IN_MOVERIGHT) and self.CrawlSpeedBuildup > 0.5 then
                volume = 85  -- Increased from 70
                speedMultiplier = 0.2  -- Even faster footsteps
            end
        elseif owner:KeyDown(IN_SPEED) then
            speedMultiplier = 0.7
            volume = 50
        else
            speedMultiplier = 0.7
            volume = 35
        end
        
        self.FootstepDelay = 0.4 * speedMultiplier
        self.LastFootstep = CurTime()
        
        self:PlayFootstepSoundWithVolume(volume)
    end
end

-- New function to play footstep with custom volume
function SWEP:PlayFootstepSoundWithVolume(volume)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Trace down to get surface material
    local tr = util.TraceLine({
        start = owner:GetPos(),
        endpos = owner:GetPos() + Vector(0, 0, -50),
        filter = owner
    })
    
    if tr.Hit then
        local matType = tr.MatType
        
        if matType == MAT_METAL or matType == MAT_VENT or matType == MAT_COMPUTER then
            self:PlayXenoSound(self.SoundTbl_FootstepsMetal, volume, math.random(90, 110))
        elseif matType == MAT_CONCRETE or matType == MAT_TILE then
            self:PlayXenoSound(self.SoundTbl_FootstepsStone, volume, math.random(90, 110))
        else
            self:PlayXenoSound(self.SoundTbl_FootstepsDirt, volume, math.random(90, 110))
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

-- Block flashlight and use F for vision instead
hook.Add("PlayerBindPress", "XenoWarriorVisionBind", function(ply, bind, pressed)
    if not pressed then return end
    
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == "weapon_cm15_xeno_warrior" then
        if bind == "impulse 100" then -- This is the flashlight bind (F key)
            if CLIENT then
                wep.VisionMode = (wep.VisionMode + 1) % 2  -- Changed from % 4 to % 2 (just 0 or 1)
                
                if wep.VisionMode > 0 then
                    if not wep.VisionSound then
                        wep.VisionSound = CreateSound(ply, "cpthazama/avp/weapons/alien/alien_vision_loop.wav")
                        wep.VisionSound:SetSoundLevel(0)
                        wep.VisionSound:Play()
                    end
                    ply:EmitSound("cpthazama/avp/weapons/alien/alien_vision_on.ogg", 65, 100)
                else
                    if wep.VisionSound then
                        wep.VisionSound:Stop()
                        wep.VisionSound = nil
                    end
                    ply:EmitSound("cpthazama/avp/weapons/alien/alien_vision_off.ogg", 65, 100)
                end
            end
            return true -- Block the flashlight
        end
    end
end)

-- Prevent flashlight from turning on server-side (STEP 3)
hook.Add("PlayerSwitchFlashlight", "XenoWarriorNoFlashlight", function(ply, enabled)
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == "weapon_cm15_xeno_warrior" then
        return false -- Prevent flashlight
    end
end)
