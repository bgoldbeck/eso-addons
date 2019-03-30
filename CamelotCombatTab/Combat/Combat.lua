
CamelotCombatTab.Combat = {}
CamelotCombatTab.Combat.Messages = {}

function CamelotCombatTab.Combat.Initialize()
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_COMBAT_EVENT, CamelotCombatTab.Combat.OnCombatEvent)
	--EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name .. "_COMBAT", EVENT_EFFECT_CHANGED, CamelotCombatTab.Combat.OnEffectChanged)
end

function CamelotCombatTab.Combat.OnCombatEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log)
	--d(abilityName .. " " .. result)
	--if hitValue == 0 then return end
	if sourceType ~= 1 and targetType ~= 1 then return end
	--if sourceType == COMBAT_UNIT_TYPE_OTHER then return end --We dont care if someone else did something to someone.
	--if (sourceType == 1 and targetType == 1) and (result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK and result ~= ACTION_RESULT_HOT_TICK_CRITICAL) then return end

	--Make sure we have a good event to process.
	if CamelotCombatTab.Combat.FilterResult(result) == false then return end
	
	if string.find(sourceName, "^") ~= nil then
		sourceName = string.gsub(sourceName, "%^.*", "")
	end
	
	if string.find(targetName, "^") ~= nil then
		targetName = string.gsub(targetName, "%^.*", "")
	end
	

	if sourceType == 1 then
		sourceName = "You"
	end
	
	if targetType == 1 then
		--targetName = "Yourself"
	end
	
	if abilityName ~= "" then
		abilityName = "[" .. abilityName .. "]"
	end
	
	local LineEventInfo  = {	
	["result"]      = result,
	["sourceName"]  = sourceName,
	["sourceType"]  = sourceType,
	["targetName"]  = targetName,
	["targetType"]  = targetType,
	["abilityName"] = abilityName,
	["hitValue"]    = hitValue,
	["powerType"]   = powerType,
	["damageType"]  = damageType,
	["abilityGraphic"]  = abilityGraphic,
	}
	--if result == ACTION_RESULT_DOT_TICK then
		--d("----~EVENT~-----")
	    --d(LineEventInfo)
	    --d("----------------")
	--end
	CamelotCombatTab.Combat.ParseNewLine(LineEventInfo)
	
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
	CamelotCombatTab.lastTime = GetFrameTimeSeconds()
end

function CamelotCombatTab.Combat.FilterResult(result)
	
	-- Direct Damage
	if ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_FALL_DAMAGE ) then
		--d("DD")
		return true
	-- Damage Over Time
	elseif ( result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then
		--d("DOT")
		return true 
	-- Heals
	elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) then
		--d("HEALZ")
		 return true
	-- Damage Immunity
	elseif ( result == ACTION_RESULT_IMMUNE 
		or result == ACTION_RESULT_DODGED 
		or result == ACTION_RESULT_REFLECTED 
		or result == ACTION_RESULT_RESIST
		or result == ACTION_RESULT_INTERRUPT 
		or result == ACTION_RESULT_PARRIED
		or result == ACTION_RESULT_MISS 
		or result == ACTION_RESULT_DAMAGE_SHIELDED
		or result == ACTION_RESULT_ABSORBED ) then
		--d("IMMUNITY")
		return true
	elseif (result == ACTION_RESULT_POWER_ENERGIZE) then
		--d("ENERGIZE")
		return true
		
	elseif (result == ACTION_RESULT_POWER_DRAIN) then
		return true
	elseif (result == ACTION_RESULT_KILLING_BLOW) then
		return true
	elseif (result == ACTION_RESULT_REFLECTED) then
		--d("BUFF")
		return true
	else
		--d("BAD EVENT!")
		return false
	end	
end

function CamelotCombatTab.Combat.ParseNewLine(line)
	local newMessage = ""
	
	local subjunctive = "was"
	if line.sourceName ~= "You" and line.targetName == "Yourself" then
		line.targetName = "You"
	end
	if line.sourceName == "" then line.sourceName = "Someone" end
	
	--Healed by someone.
	if (line.result == ACTION_RESULT_HEAL or line.result == ACTION_RESULT_CRITICAL_HEAL or line.result == ACTION_RESULT_HOT_TICK or line.result == ACTION_RESULT_HOT_TICK_CRITICAL) then
		local healTypeOf = CamelotCombatTab.Combat.GetHealTypeOf(line.result)
		newMessage = string.format(CamelotCombatTab.savedVars.healingSpellColor .. "%s %s %s for %s %s", line.sourceName, healTypeOf, line.targetName, line.hitValue, line.abilityName)
	--Power Drained.
	elseif (line.result == ACTION_RESULT_POWER_DRAIN) then
		--if line.sourceType == 0 then return end
		local powerOf = "Power"
		if line.powerType == POWERTYPE_HEALTH        then powerOf = "Health"        end
		if line.powerType == POWERTYPE_STAMINA       then powerOf = "Stamina"       end
		if line.powerType == POWERTYPE_MAGICKA       then powerOf = "Magika"        end
		if line.powerType == POWERTYPE_MOUNT_STAMINA then powerOf = "Mount Stamina" end
		if line.powerType == POWERTYPE_FINESSE       then powerOf = "Finesse"       end
		if line.powerType == POWERTYPE_ULTIMATE      then powerOf = "Ultimate"      end
		
		newMessage = string.format(CamelotCombatTab.savedVars.drainColor .. "%s drained %s %s %s %s", line.sourceName, line.targetName,line.hitValue, powerOf, line.abilityName)
	--POWER ENERGIZE.
	elseif (line.result == ACTION_RESULT_POWER_ENERGIZE) then
		local powerOf = "Power"
		if line.powerType == POWERTYPE_HEALTH        then powerOf = "Health"        end
		if line.powerType == POWERTYPE_STAMINA       then powerOf = "Stamina"       end
		if line.powerType == POWERTYPE_MAGICKA       then powerOf = "Magika"        end
		if line.powerType == POWERTYPE_MOUNT_STAMINA then powerOf = "Mount Stamina" end
		if line.powerType == POWERTYPE_FINESSE       then powerOf = "Finesse"       end
		if line.powerType == POWERTYPE_ULTIMATE      then powerOf = "Ultimate"      end
		
		newMessage = string.format(CamelotCombatTab.savedVars.energizeColor .. "%s Infused %s with %s %s %s", line.sourceName, line.targetName, line.hitValue, powerOf, line.abilityName)
	--SPELL ATTACK.
	elseif  (line.result == ACTION_RESULT_DAMAGE or line.result == ACTION_RESULT_CRITICAL_DAMAGE or line.result == ACTION_RESULT_BLOCKED_DAMAGE
	          or line.result == ACTION_RESULT_DOT_TICK or line.result == ACTION_RESULT_DOT_TICK_CRITICAL) then
		local damageOf = CamelotCombatTab.Combat.GetDamageOf(line.result)
		if  line.damageType == DAMAGE_TYPE_COLD or 
		    line.damageType == DAMAGE_TYPE_DISEASE or 
		    line.damageType == DAMAGE_TYPE_DROWN or 
		    line.damageType == DAMAGE_TYPE_EARTH or 
		    line.damageType == DAMAGE_TYPE_FIRE or 
		    line.damageType == DAMAGE_TYPE_GENERIC or 
		    line.damageType == DAMAGE_TYPE_MAGIC or 
		    line.damageType == DAMAGE_TYPE_OBLIVIONc or 
		    line.damageType == DAMAGE_TYPE_POISON or 
		    line.damageType == DAMAGE_TYPE_SHOCK then
		    local color = CamelotCombatTab.savedVars.genericSpellColor
			if line.targetName == GetUnitName('player') then
			    color = CamelotCombatTab.savedVars.dmgTakenColor
			end
		    newMessage = string.format(color .. "%s %s %s for %s %s", line.sourceName, damageOf, line.targetName, line.hitValue, line.abilityName)
		else
		    local color = CamelotCombatTab.savedVars.physicalColor
			if line.targetName == GetUnitName('player') then
			    color = CamelotCombatTab.savedVars.dmgTakenColor
			end
			newMessage = string.format(color .. "%s %s to %s for %s %s", line.sourceName, damageOf, line.targetName, line.hitValue, line.abilityName)
		end
	elseif (line.result == ACTION_RESULT_FALL_DAMAGE or line.result == ACTION_RESULT_FALLING) then
		newMessage = string.format(CamelotCombatTab.savedVars.dmgTakenColor .. "You Fell for %s", line.hitValue)
	elseif (line.result == ACTION_RESULT_REFLECTED) then
		local color = CamelotCombatTab.savedVars.buffGainColor
		newMessage = string.format(color .. "You Gained %s", line.abilityName)
	end
	
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
	
end

function CamelotCombatTab.Combat.GetDamageOf(result)
	if result == ACTION_RESULT_CRITICAL_DAMAGE then
		return "critically hit!"
	elseif result == ACTION_RESULT_KILLING_BLOW then
		return "dealt killing blow!"
	elseif result == ACTION_RESULT_INTERRUPT then
		return "interrupted!"
	elseif result == ACTION_RESULT_OFFBALANCE then
		return "off balanced!"
	elseif result == ACTION_RESULT_SILENCED then
		return "silenced!"
	elseif result == ACTION_RESULT_STUNNED then
		return "stunned!"
	elseif result == ACTION_RESULT_REFLECTED then
		return "reflected!"
	elseif result == ACTION_RESULT_DAMAGE then
		return "hit"
	else
		return "hit"
	end
end

function CamelotCombatTab.Combat.GetHealTypeOf(result)
	if result == ACTION_RESULT_HEAL then
		return "healed"
	elseif result == ACTION_RESULT_CRITICAL_HEAL then
		return "critically healed!"
	elseif	result == ACTION_RESULT_HOT_TICK then
		return "healed"
	elseif	result == ACTION_RESULT_HOT_TICK_CRITICAL then
		return "critically healed!"
	else
		return ""
	end
end

function CamelotCombatTab.Combat.GetResultTypeOf(result)
	if result == ACTION_RESULT_FALLING or result == ACTION_RESULT_FALL_DAMAGE then
		return "Fell and"
	elseif result == ACTION_RESULT_BLOCKED_DAMAGE then
		return "Blocked and"
	else
		return ""
	end
end

function CamelotCombatTab.Combat.OnEffectChanged(eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType,  abilityType, statusEffectType)
	--if (endTime - beginTime) == 0 then return end
	if changeType == 1 then return end --We only wanna know when effects end. Like drinks and rally.
	
	newMessage = CamelotCombatTab.savedVars.buffLostColor  .. "You lost [" .. effectName .. "]"
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

