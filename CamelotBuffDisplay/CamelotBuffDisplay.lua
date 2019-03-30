--Initialize.
CBD 	   		        = {}
CBD.name				= "CamelotBuffDisplay"
CBD.version			    = 0.12
local print             = d

local TimerTable            = {}
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
CBD.defaults         = {
	["iconSize"]     = 38,
    ["offset"]       = {0, 0},
}

function CBD.Initialize(eventCode, addonName)
	--Only set up for this addon.
	if(addonName ~= CBD.name) then return end
	
	--Load all saved variables.
	CBD.savedVars = ZO_SavedVars:New('CBD_SAVEDVARIABLES_DB' , 116, nil , CBD.defaults)
	
	--Initializers.
	CBD.Config.Initialize()
	CBD.Player.Initialize()
	CBD.UI.Initialize()
	CBD.UI.MainFrame.Initialize()
end

function CBD.Update(force)
	force = force or false
	if not DelayedBuffer("delayUpdate-CBD", 0.1) then 
		if force == false then return end 
	end
	CBD.Player.Update()
	CBD.UI.MainFrame.Update()
end

--Hook initialization.
EVENT_MANAGER:RegisterForEvent(CBD.name, EVENT_ADD_ON_LOADED, CBD.Initialize)