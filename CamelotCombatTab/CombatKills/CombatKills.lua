
CamelotCombatTab.CombatKills = {}
CamelotCombatTab.CombatKills.deathCount = 0
CamelotCombatTab.CombatKills.killCount = 0

function CamelotCombatTab.CombatKills.Initialize()
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name .. "_COMBAT_KILLS", EVENT_COMBAT_EVENT, CamelotCombatTab.CombatKills.OnCombatEvent)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name .. "_COMBAT_KILLS", EVENT_PLAYER_DEAD, CamelotCombatTab.CombatKills.OnKilledInAction)
end

function CamelotCombatTab.CombatKills.OnCombatEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log)
	if sourceName == "" then return end
	--if sourceType ~= COMBAT_UNIT_TYPE_PLAYER and GetUnitName("player") ~= zo_strformat("<<1>>", sourceName) then return end
	--if GetUnitName('player') == zo_strformat("<<1>>", targetName) then return end
	
	if result == ACTION_RESULT_DIED or result == ACTION_RESULT_DIED_XP then
		--You got the deathblow!
		--d("TEST - Deathblow on " .. zo_strformat(SI_UNIT_NAME, targetName))
	end
	
	if (result == ACTION_RESULT_KILLING_BLOW) then
		for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
			CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
		end
		local str = ""
		--local i = GetNumKillingAttacks()
		--local attackName, attackDamage, attackIcon, wasKillingBlow, castTimeAgoMS, durationMS = GetKillingAttackInfo(i)
		--if attackDamage ~= 0 then
			--Killing blow! Against player. From Player.
		if hitValue == 0 then
			str = "|C772222You killed " .. zo_strformat("<<1>>", targetName)
			CamelotCombatTab.CombatKills.killCount = CamelotCombatTab.CombatKills.killCount + 1
		elseif hitValue ~= 0 then
			str = "|C772222" .. zo_strformat("<<1>>", targetName) .. " Released Their Corpse"
		end
		
		--elseif attackDamage == 0 then
			--str = "|C772222" .. zo_strformat("<<1>>", targetName .. " Released")
			
			--PlaySound(SOUNDS.ELDER_SCROLL_CAPTURED_BY_EBONHEART)
		--end
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(str)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
	
end

function CamelotCombatTab.CombatKills.OnKilledInAction(eventCode)
	if not IsPlayerInAvAWorld() then return end
	
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
    
	local killer, vlevel, level, pvplevel, par5bool, par6bool, alliance, par8str = GetKillingAttackerInfo()
	
	local allianceColor = ""
	if alliance == ALLIANCE_EBONHEART_PACT or alliance == "Ebonheart Pact" then allianceColor = "|C990000"
    elseif alliance == ALLIANCE_ALDMERI_DOMINION or alliance == "Aldmeri Dominion" then allianceColor = "|CFFCC00"
    elseif alliance == ALLIANCE_DAGGERFALL_COVENANT or alliance == "Daggerfall Covenant" then allianceColor = "|C0066ff"
    else allianceColor = "|Cffffff"
    end
	
    killer = zo_strformat("<<1>>", killer)
	if killer == "" then return end
	CamelotCombatTab.CombatKills.deathCount = CamelotCombatTab.CombatKills.deathCount + 1
	
    local str = "|C870505You were killed by " .. allianceColor .. killer
	
	--Add new event to list.
	CamelotCombatTab.Combat.List.Push(str)
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
	
end