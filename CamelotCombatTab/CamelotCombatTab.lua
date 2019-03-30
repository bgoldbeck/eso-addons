--Initialize.
CamelotCombatTab 	   		        = {}
CamelotCombatTab.name				= "CamelotCombatTab"
CamelotCombatTab.version			= 0.2
CamelotCombatTab.lastTime           = nil


local TimerTable    = {}
function DelayedBuffer(key, buffer)
	if key == nil then return end
	if TimerTable[key] == nil then TimerTable[key] = {} end
	TimerTable[key].buffer = buffer or 3
	TimerTable[key].now = GetFrameTimeSeconds()
	if TimerTable[key].last == nil then TimerTable[key].last = TimerTable[key].now end
	TimerTable[key].diff = TimerTable[key].now - TimerTable[key].last
	TimerTable[key].eval = TimerTable[key].diff >= TimerTable[key].buffer
	if TimerTable[key].eval then TimerTable[key].last = TimerTable[key].now end
	return TimerTable[key].eval
end

--Default Saved Variables.
CamelotCombatTab.defaults         = {
	["numLines"]           = 500,
	["visibleLines"]       = 10,
	["lineHeight"]         = 18,
	["frameWidth"]         = 500,
	["position"]           = {0, 0},
	--COLORS
	["genericSpellColor"]  = "|c9955FF",
	["physicalColor"]      = "|cff9966",
	["healingSpellColor"]  = "|c00bb33",
	["normalAttackColor"]  = "|cff8c00",
	["drainColor"]         = "|c666666",
	["energizeColor"]      = "|c00cccc",
	["playerHitColor"]     = "|cff0000",
	["xpGainColor"]        = "|cffff00",
	["apGainColor"]        = "|c00ff33",
	["moneyGainColor"]     = "|cffff00",
	["lootColor"]          = "|cffff00",
	["dmgTakenColor"]      = "|cff0000",
	["buffLostColor"]      = "|caa0000",
	["buffGainColor"]      = "|c800080",
	["eventColor"]         = "|cccff33",
}

function CamelotCombatTab.Initialize(eventCode, addonName)
	--Only set up for this addon.
	if(addonName ~= CamelotCombatTab.name) then return end
	
	--Load all saved variables.
	CamelotCombatTab.savedVars = ZO_SavedVars:New('CamelotCombatTab_SAVEDVARIABLES_DB' , 11, nil , CamelotCombatTab.defaults)
	
	--UI.
	CamelotCombatTab.UI.MainFrame.Initialize()
	
	--Combat.
	CamelotCombatTab.Combat.Initialize()
	CamelotCombatTab.Combat.List.Initialize()
	
	--Xp.
	CamelotCombatTab.Xp.Initialize()
	
	--Money.
	CamelotCombatTab.Money.Initialize()
	
	--Player
	CamelotCombatTab.Player.Initialize()
	
	--Events
	CamelotCombatTab.Events.Initialize()
	
	--Loot.
	CamelotCombatTab.Loot.Initialize()
	
	--Kills.
	CamelotCombatTab.CombatKills.Initialize()
	
	--LFG Filter
	CamelotCombatTab.LFGFilter.Initialize()
	
	CamelotCombatTab.UI.MainFrame.Update()
	
	CamelotCombatTab.Combat.List.Push(CamelotCombatTab.savedVars.eventColor  .. "[Type /xps for Experience / Hour and Alliance Points / Hour]")
	--Force an update.
	CamelotCombatTab.Update(true)
end

function CamelotCombatTab.Update(force)
	force = force or false
	if not DelayedBuffer("delayUpdate-CamelotCombatTab", 2.0) then 
		if force == false then return end 
	end
	
	local now = GetFrameTimeSeconds()
	if CamelotCombatTab.lastTime == nil then CamelotCombatTab.lastTime = now end
	local difference = now - CamelotCombatTab.lastTime
	
	if difference > 12 then
		for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
			CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(true)
		end
		CamelotCombatTab.UI.MainFrame.Top:SetAlpha(0.4)
		CamelotCombatTab.lastTime = now --Reset Timer.
	end
	
	CamelotCombatTab.UI.MainFrame.Update()
end
	

SLASH_COMMANDS["/stats ap"] = function()
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	local elapsedMinutes = CamelotCombatTab.Xp.APTimerDif / 60
	local apPerHour = CamelotCombatTab.Xp.APTotal / (elapsedMinutes / 60)
	local ap = CamelotCombatTab.savedVars.apGainColor .. math.floor(apPerHour) .. " AP / Hour Total: " .. CamelotCombatTab.Xp.APTotal
	
	CamelotCombatTab.Combat.List.Push("Total Time " .. math.floor(elapsedMinutes) .. " Minutes")
	CamelotCombatTab.Combat.List.Push(ap)
	
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
	
end

SLASH_COMMANDS["/stats xp"] = function()
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	local elapsedMinutes = CamelotCombatTab.Xp.XPTimerDif / 60
	local xpPerHour = CamelotCombatTab.Xp.XPTotal / (elapsedMinutes / 60)
	local xp = CamelotCombatTab.savedVars.xpGainColor  .. math.floor(xpPerHour) .. " XP / Hour Total: " .. CamelotCombatTab.Xp.XPTotal
	
	CamelotCombatTab.Combat.List.Push("Total Time " .. math.floor(elapsedMinutes) .. " Minutes")
	CamelotCombatTab.Combat.List.Push(xp)
	
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
	
end

SLASH_COMMANDS["/stats irs"] = function()
	--I Remain Standing (Total alliance points divided by deaths)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local newMessage = ""
	if CamelotCombatTab.CombatKills.deathCount == 0 then 
		newMessage = "I Remain Standing: " .. CamelotCombatTab.Xp.APTotal
	else
		newMessage = "I Remain Standing: " .. math.floor(CamelotCombatTab.Xp.APTotal / CamelotCombatTab.CombatKills.deathCount)
	end
	
	CamelotCombatTab.Combat.List.Push(newMessage)
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
end

--Hook initialization.
EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_ADD_ON_LOADED, CamelotCombatTab.Initialize)