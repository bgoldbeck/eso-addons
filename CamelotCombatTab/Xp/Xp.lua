CamelotCombatTab.Xp = {}
CamelotCombatTab.Xp.XPTotal = 0
CamelotCombatTab.Xp.XPTimerBegin = GetFrameTimeSeconds()
CamelotCombatTab.Xp.XPTimerDif = 0

CamelotCombatTab.Xp.APTotal = 0
CamelotCombatTab.Xp.APTimerBegin = GetFrameTimeSeconds()
CamelotCombatTab.Xp.APTimerDif = 0

function CamelotCombatTab.Xp.Initialize()
	
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_ALLIANCE_POINT_UPDATE, CamelotCombatTab.Xp.OnApUpdate)
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_EXPERIENCE_GAIN, CamelotCombatTab.Xp.OnExperienceGain)
	
end

function CamelotCombatTab.Xp.OnExperienceGain(eventCode, reason, level, previousExperience, currentExperience, championPoints)
	
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
	
		
	-- Ignore finesse bonuses, they will get rolled into the next reward
	--if ( reason == XP_REASON_FINESSE ) then return end
		--Exp Progress
		
	if (IsUnitChampion('player')) then
		local cp = GetUnitChampionPoints("player")
		if cp < GetChampionPointsPlayerProgressionCap() then
			cp = GetChampionPointsPlayerProgressionCap()
		end
		xpMax = GetNumChampionXPInChampionPoint(cp)
	else
		xpMax = GetUnitXPMax('player')
	end
	
	local gained = (currentExperience - previousExperience)
	CamelotCombatTab.Xp.XPTotal = CamelotCombatTab.Xp.XPTotal + gained
	
	
	CamelotCombatTab.Xp.XPTimerDif = GetFrameTimeSeconds() - CamelotCombatTab.Xp.XPTimerBegin
	
	local elapsedMinutes = CamelotCombatTab.Xp.XPTimerDif / 60
	
	local xpPerHour = CamelotCombatTab.Xp.XPTotal / (elapsedMinutes / 60)
	
	--Calculate percentage to level
	local pct		= math.floor( 100 * ( currentExperience / xpMax ) )
	
	CamelotCombatTab.Player.exp    = currentExp
	
	local newMessage = string.format(CamelotCombatTab.savedVars.xpGainColor .. "Experience Points [+%s] %s / Hour", gained, math.floor(xpPerHour))
	
	--Add new event to list.
	CamelotCombatTab.Combat.List.Push(newMessage)
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
end

function CamelotCombatTab.Xp.OnApUpdate(eventCode, alliancePoints, playSound, difference)
	if difference < 1 then return end
	
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
	CamelotCombatTab.lastTime = GetFrameTimeSeconds()
	
	CamelotCombatTab.Xp.APTotal = CamelotCombatTab.Xp.APTotal + math.abs(difference)
	CamelotCombatTab.Xp.APTimerDif = GetFrameTimeSeconds() - CamelotCombatTab.Xp.APTimerBegin
	
	local elapsedMinutes = CamelotCombatTab.Xp.APTimerDif / 60
	
	local apPerHour = CamelotCombatTab.Xp.APTotal / (elapsedMinutes / 60)
	
	local newMessage = CamelotCombatTab.savedVars.apGainColor ..  "Alliance Points [+" .. difference .. "] "  .. math.floor(apPerHour) .. " / Hour"
	
	--Add new event to list.
	CamelotCombatTab.Combat.List.Push(newMessage)
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
end