--Initialize.
CUF 	   		        = {}
CUF.name				= "CamelotUnitFrames"
CUF.version			    = 0.21
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
CUF.defaults         = {
	["unitPlayer"] = {
		["enabled"]           = true,
		["dimensions"]        = {390, 150},
		["offset"]            = {0, -45},
		["expOrRank"]         = 0,
		["scale"]             = 100,    --%
		["gradient"]          = "gradient_tube.dds", },
	["unitGroup"] = {	
		["enabled"]           = true,
		["dimensions"]        = {325, 130},
		["offset"]            = {5, 300},
		["gradient"]          = "gradient_radial.dds", },
	["LargeUnitGroup"] = {	
		["enabled"]           = true,
		["dimensions"]        = {245, 115},
		["offset"]            = {0, 0},
		["gradient"]          = "gradient_radial.dds", },
}

function CUF.Initialize(eventCode, addonName)
	--Only set up for this addon.
	if(addonName ~= CUF.name) then return end
	
	--Load all saved variables.
	CUF.savedVars = ZO_SavedVars:New('CUF_SAVEDVARIABLES_DB' , 4, nil , CUF.defaults)
	--Initializers.
	CUF.Config.Initialize()
	
	--Player Frame.
	CUF.Player.Initialize()
	CUF.Target.Initialize()
	CUF.PlayerUI.Initialize()
	CUF.PlayerUI.MainFrame.Initialize()
	
	--Group.
	CUF.Group.Initialize()
	CUF.GroupUI.Initialize()
	CUF.GroupUI.MainFrame.Initialize()
	
	--Move 'Ultimate' synergy.
	ZO_SynergyTopLevelContainer:ClearAnchors()
	ZO_SynergyTopLevelContainer:SetAnchor(TOP, ZO_CompassFrame, BOTTOM, 0, 0)
	ZO_SynergyTopLevelContainer:SetScale(1.0)
	
	--Move 'F' Player interaction.
	ZO_PlayerToPlayerAreaPromptContainer:ClearAnchors()
	ZO_PlayerToPlayerAreaPromptContainer:SetAnchor(TOP, ZO_SynergyTopLevelContainer, BOTTOM, 0, 0)
	ZO_PlayerToPlayerAreaPromptContainer:SetScale(1.0)
	ZO_ActionBar1:SetScale(0.8)  --Make action bar a little smaller
	ZO_AlertTextNotification:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 0,0)
	
end

function CUF.Update(force)
	force = force or false
	if not DelayedBuffer("delayUpdate-CUF", 0.02) then 
		if force == false then return end 
	end
	--Saved vars not loaded yet?
	if CUF.savedVars == nil then return end
	
	--Player
	if CUF.savedVars.unitPlayer.enabled == true then
		CUF.Target.Update()
		CUF.Player.Update()
		CUF.PlayerUI.MainFrame.Update()
	else
		CUF.PlayerUI.MainFrame.Disable()
	end
	
	--Group
	if CUF.savedVars.unitGroup.enabled == true then
		CUF.Group.Update()
		CUF.GroupUI.MainFrame.Update()
	else
		CUF.GroupUI.MainFrame.Disable()
	end	

end

--Hook initialization.
EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_ADD_ON_LOADED, CUF.Initialize)