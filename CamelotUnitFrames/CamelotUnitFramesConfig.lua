local LAM = LibStub("LibAddonMenu-2.0")

if ( not LAM ) then return end

CUF.Config = {}

function CUF.Config.Initialize()
	
	local panelData = {
		type = "panel",
		name = CUF.name,
		author = "Rando",
		version = CUF.version,
		slashCommand = "",
		registerForRefresh = true
	}
	
	local optionsData = {
		--PLAYER UNIT FRAMES.
		[1] = {
			type = "header",
			name = "Player Unit Frame Options"
		},
		[2] = {
			type = "checkbox",
			name = "Player Frame Enabled?",
			tooltip = "Disable/Enable the player frame component.",
			getFunc = function() return CUF.savedVars.unitPlayer.enabled end,
			setFunc = function(value)
				CUF.savedVars.unitPlayer.enabled = not CUF.savedVars.unitPlayer.enabled
				--Force an update.
				CUF.Update(true)
			end,
		},
		[3] = {
			type = "dropdown",
			name = "Show Experience or Rank?",
			tooltip = "Toggle showing experience or pvp rank.",
			choices = {"Exp", "Rank"},
			getFunc = function() 
				if CUF.savedVars.unitPlayer.expOrRank == 0 then
					return "Exp"
				elseif CUF.savedVars.unitPlayer.expOrRank == 1 then
					return "Rank"
				end
			end,
			setFunc = function(newValue)
				local value = nil
				local mounted = IsMounted()
				if newValue == "Exp" then
					--Exp
					CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(mounted)
					CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(true)
					value = 0
				elseif newValue == "Rank" then
					--Rank
					CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(mounted)
					CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(true)
					value = 1
				end
					
				CUF.savedVars.unitPlayer.expOrRank = value
			end,
		},
		[4] = {
			type = "slider",
			name = "Offset X",
			tooltip = "",
			min = -1200,
			max =  1200,
			getFunc = function() return CUF.savedVars.unitPlayer.offset[1] end,
			setFunc = function(newValue) 
				CUF.savedVars.unitPlayer.offset[1] = newValue
				CUF.PlayerUI.MainFrame.top:SetAnchor(BOTTOM, ZO_ActionBar1, TOP, CUF.savedVars.unitPlayer.offset[1], CUF.savedVars.unitPlayer.offset[2]) 
			end,
		},
		[5] = {
			type = "slider",
			name = "Offset Y",
			tooltip = "",
			min = -1200,
			max =  1200,
			getFunc = function() return CUF.savedVars.unitPlayer.offset[2] end,
			setFunc = function(newValue) 
				CUF.savedVars.unitPlayer.offset[2] = newValue
				CUF.PlayerUI.MainFrame.top:SetAnchor(BOTTOM, ZO_ActionBar1, TOP, CUF.savedVars.unitPlayer.offset[1], CUF.savedVars.unitPlayer.offset[2]) 
			end,
		},		
		
		[6] = {
			type = "dropdown",
			name = "Which gradient style? (ReloadUI)",
			tooltip = "",
			choices = {"gradient_radial.dds", "gradient_dimpled.dds", "gradient_blinds.dds", "gradient_deep.dds", "gradient_tube.dds", 
			           "gradient_cubed.dds", "gradient_cloth.dds" , "gradient_ripple.dds", "gradient_oil.dds" },
			getFunc = function() return CUF.savedVars.unitPlayer.gradient end,
			setFunc = function(newValue)
				CUF.savedVars.unitPlayer.gradient = newValue
				ReloadUI()
				return
			end,
		},
		--GROUP UNIT FRAMES.
		[7] = {
			type = "header",
			name = "Group Unit Frame Options"
		},

		[8] = {
			type = "checkbox",
			name = "Group Frame Enabled? (ReloadUI)",
			tooltip = "Disable/Enable the Group frame component.",
			getFunc = function() return CUF.savedVars.unitGroup.enabled end,
			setFunc = function(value)
				CUF.savedVars.unitGroup.enabled = not CUF.savedVars.unitGroup.enabled
				--Force an update.
				CUF.Update(true)
				ReloadUI()
				return
			end,
		},
		
		[9] = {
			type = "dropdown",
			name = "Which gradient style? (ReloadUI)",
			tooltip = "",
			choices = {"gradient_radial.dds", "gradient_dimpled.dds", "gradient_blinds.dds", "gradient_deep.dds", "gradient_tube.dds", 
			           "gradient_cubed.dds", "gradient_cloth.dds" , "gradient_ripple.dds", "gradient_oil.dds" },
			getFunc = function() return CUF.savedVars.unitGroup.gradient end,
			setFunc = function(newValue)
				CUF.savedVars.unitGroup.gradient = newValue
				ReloadUI()
				return
			end,
		},
	}
	LAM:RegisterAddonPanel(CUF.name .. "AddonOptions", panelData)
	LAM:RegisterOptionControls(CUF.name .. "AddonOptions", optionsData)
end


