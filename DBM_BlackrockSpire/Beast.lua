DBM_BRS_TAB         = "BlackrockTab"
DBM_BLACKROCK_SPIRE	= "Blackrock Spire"

local Beast = DBM:NewBossMod("Beast", "The Beast", "Announces Flamebreak and Terrifying Roar.", "Blackrock Spire", "BlackrockTab", 1)

Beast.Version   = "1.0"
Beast.Author    = "Siarkowy"

Beast:RegisterCombat("COMBAT")
Beast:RegisterEvents("SPELL_CAST_SUCCESS")

Beast:AddOption("WarnFlamebreak", false, "Announce Flamebreak")
Beast:AddOption("WarnRoar", false, "Announce Terrifying Roar")

Beast:AddBarOption("Flamebreak")
Beast:AddBarOption("Terrifying Roar")

function Beast:OnCombatStart(delay)
    self:StartStatusBarTimer(12 - delay, "Flamebreak", "Interface\\Icons\\Spell_Holy_Excorcism_02")
    self:StartStatusBarTimer(23 - delay, "Terrifying Roar", "Interface\\Icons\\Ability_Devour")

    self:ScheduleSelf( 9 - delay, "WarnF")
    self:ScheduleSelf(20 - delay, "WarnR")
end

function Beast:OnEvent(event, args)
    if event == "SPELL_CAST_SUCCESS" then
        if args.spellId == 16785 then -- Flamebreak
            self:SendSync("F")
        elseif args.spellId == 14100 then -- Terrifying Roar
            self:SendSync("R")
        end	
    elseif event == "WarnF" then
        self:Announce("*** Flamebreak soon! ***", 2)
    elseif event == "WarnR" then
        self:Announce("*** Terrifying Roar soon! ***", 3)
    end
end

function Beast:OnSync(msg)
    if msg == "F" then
        self:StartStatusBarTimer(10, "Flamebreak", "Interface\\Icons\\Spell_Holy_Excorcism_02")
        self:ScheduleSelf(7, "WarnF")
        if self.Options.WarnFlamebreak then
            self:Announce("*** Flamebreak ***", 1)
        end
    elseif msg == "R" then
        self:StartStatusBarTimer(20, "Terrifying Roar", "Interface\\Icons\\Ability_Devour")
        self:ScheduleSelf(17, "WarnR")
        if self.Options.WarnRoar then
            self:Announce("*** Terrifying Roar ***", 1)
        end
    end
end
