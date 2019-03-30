local LAM = LibStub("LibAddonMenu-2.0")

if ( not LAM ) then return end

CBD.Config = {}

function CBD.Config.Initialize()
	
	local panelData = {
		type = "panel",
		name = CBD.name,
		author = "Rando",
		version = CBD.version,
		slashCommand = "",
		registerForRefresh = true
	}
	
	local optionsData = {
		--PLAYER UNIT FRAMES.
		[1] = {
			type = "header",
			name = "Position"
		},
		
		[2] = {
			type = "slider",
			name = "Offset X",
			tooltip = "",
			min = -1200,
			max =  1200,
			getFunc = function() return CBD.savedVars.offset[1] end,
			setFunc = function(newValue) 
				CBD.savedVars.offset[1] = newValue
				CBD.UI.MainFrame.top:SetAnchor(TOP, GuiRoot, TOP, CBD.savedVars.offset[1], CBD.savedVars.offset[2]) 
			end,
		},
		[3] = {
			type = "slider",
			name = "Offset Y",
			tooltip = "",
			min = -1200,
			max =  1200,
			getFunc = function() return CBD.savedVars.offset[2] end,
			setFunc = function(newValue) 
				CBD.savedVars.offset[2] = newValue
				CBD.UI.MainFrame.top:SetAnchor(TOP, GuiRoot, TOP, CBD.savedVars.offset[1], CBD.savedVars.offset[2]) 
			end,
		},	
		[4] = {
			type = "slider",
			name = "Icon Size",
			tooltip = "",
			min = 8,
			max =  128,
			getFunc = function() return CBD.savedVars.iconSize end,
			setFunc = function(newValue) 
				CBD.savedVars.iconSize = newValue
				ReloadUI() 
			end,
		},	
	}
	LAM:RegisterAddonPanel(CBD.name .. "AddonOptions", panelData)
	LAM:RegisterOptionControls(CBD.name .. "AddonOptions", optionsData)
end


