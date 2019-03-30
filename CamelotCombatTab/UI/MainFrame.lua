local LibUI = LibStub('LibUI-0.12')
if ( not LibUI ) then return end


CamelotCombatTab.UI.MainFrame = {}
CamelotCombatTab.UI.MainFrame.offsetIndex = 0


function CamelotCombatTab.UI.MainFrame.Initialize()
	local Top      = LibUI:CreateTopLevelWindow(CamelotCombatTab.name .. "_MainFrame_Top", GuiRoot, {CamelotCombatTab.savedVars.frameWidth, CamelotCombatTab.savedVars.lineHeight * CamelotCombatTab.savedVars.visibleLines}, {TOPLEFT, TOPLEFT}, {CamelotCombatTab.savedVars.position[1], CamelotCombatTab.savedVars.position[2]})
    Top:SetMouseEnabled(true)
    Top:SetClampedToScreen(true)
	Top:SetDrawLayer(0)
	Top:SetMovable(true)
	Top:SetHandler("OnMouseExit",function(self) 
		 CamelotCombatTab.savedVars.position[1] = CamelotCombatTab.UI.MainFrame.Top:GetLeft()
		 CamelotCombatTab.savedVars.position[2] = CamelotCombatTab.UI.MainFrame.Top:GetTop()
	end)
	Top:SetHandler("OnMouseWheel",function(self, delta)
		CamelotCombatTab.lastTime = now --Reset Timer.
		for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
			CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
		end
	
		CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
		CamelotCombatTab.lastTime = GetFrameTimeSeconds()
		--New index.
		CamelotCombatTab.UI.MainFrame.offsetIndex = CamelotCombatTab.UI.MainFrame.offsetIndex + delta
		
		--Max index range.
		if( CamelotCombatTab.UI.MainFrame.offsetIndex > (#CamelotCombatTab.Combat.List - CamelotCombatTab.savedVars.visibleLines) ) then
			CamelotCombatTab.UI.MainFrame.offsetIndex = CamelotCombatTab.UI.MainFrame.offsetIndex - delta --Reverse the delta.	
		end
		--Min index range.
		if CamelotCombatTab.UI.MainFrame.offsetIndex < 0 then
			CamelotCombatTab.UI.MainFrame.offsetIndex = 0
		end
		--Force update.
		CamelotCombatTab.UI.MainFrame.Update()
	end)
		
	Top.backdrop   = LibUI:CreateBackdrop(CamelotCombatTab.name .. "_MainFrame_Top_Backdrop", Top, {Top:GetWidth(), Top:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.02, 0.02, 0.02, 0.6}, {0.4, 0.4, 0.4, 0.09}, false) 
		
	local Lines    = {}
	local Anchor   = Top
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		--Create a new line.
		local line    = LibUI:CreateButton(CamelotCombatTab.name .. "_MainFrame_Line_" .. i, Top, {Top:GetWidth(), CamelotCombatTab.savedVars.lineHeight}, {BOTTOMLEFT, BOTTOMLEFT}, {1, 0}, nil, "ZoFontWinH5", {0, 1}, {1, 1, 1, 1}, {1, 1, 0, 1} , {0, 0, 1, 1}, false)
		line:SetText(CamelotCombatTab.name .. " " .. i)
		line:GetLabelControl():SetScale(0.95)
		line:SetMouseEnabled(false)
		line.backdrop = LibUI:CreateBackdrop(CamelotCombatTab.name .. "_MainFrame_Line_Backdrop_" .. i, line, {line:GetWidth(), line:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.5, 0.05}, {0.4, 0.4, 0.4, 0.0}, false) 
		line.texture = LibUI:CreateTexture(CamelotCombatTab.name .. "_MainFrame_Line_Backdrop" .. i, line, {line:GetHeight() , line:GetHeight()}, {LEFT, LEFT}, {-20,0}, "/esoui/art/achievements/achievements_points_legendary.dds", false)
		
		if i ~= 1 then
			line:SetAnchor(BOTTOMLEFT, Anchor, TOPLEFT, 0,  0)
		end
		
		Lines[i] = line
		Anchor = Lines[i]
	end
	local slider = LibUI:CreateSlider(CamelotCombatTab.name .. "_MainFrame_Slider", Top, {9, Top:GetHeight() - 30}, {RIGHT, RIGHT}, {0,0}, 1, CamelotCombatTab.savedVars.numLines, false)
	local tex = "/esoui/art/miscellaneous/scrollbox_elevator.dds"
	slider:SetThumbTexture(tex, tex, tex, 15, 15, 0, 0, 1, 1)
	slider:SetThumbFlushWithExtents(true)
	slider.backdrop = LibUI:CreateBackdrop(CamelotCombatTab.name .. "_MainFrame_Slider_Backdrop", slider, {slider:GetWidth(), slider:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.02, 0.02, 0.02, 0.4}, {0.4, 0.4, 0.4, 0.0}, false) 
	--local buttonUp = LibUI:CreateButton(CamelotCombatTab.name .. "_MainFrame_ButtonUp", Top, {20, 20}, {TOPLEFT, TOPLEFT}, {0, 0}, nil, nil, nil, nil, nil, nil, false)
	--local handler = slider:GetHandler("OnValueChanged")
	
	slider:SetHandler("OnValueChanged", function(self, value, reason) 
		CamelotCombatTab.lastTime = now --Reset Timer.
		CamelotCombatTab.UI.MainFrame.offsetIndex = #CamelotCombatTab.Combat.List - value	
		--Force update.
		CamelotCombatTab.Update(true)
	end)
	
	local textureUp = LibUI:CreateTexture(CamelotCombatTab.name .. "_MainFrame_TextureUp", Top, {slider:GetWidth() , 15}, {TOPRIGHT, TOPRIGHT}, {0,0}, "/esoui/art/tooltips/tooltip_uparrow.dds", false)
	textureUp:SetMouseEnabled(true)
	textureUp:SetHandler("OnMouseDown", function() 
		CamelotCombatTab.lastTime = now --Reset Timer.
		CamelotCombatTab.UI.MainFrame.offsetIndex = CamelotCombatTab.UI.MainFrame.offsetIndex + 1
		--Max index range.
		if( CamelotCombatTab.UI.MainFrame.offsetIndex > (#CamelotCombatTab.Combat.List - CamelotCombatTab.savedVars.visibleLines) ) then
			CamelotCombatTab.UI.MainFrame.offsetIndex = CamelotCombatTab.UI.MainFrame.offsetIndex - 1 --Reverse the delta.	
		end
		--Min index range.
		if CamelotCombatTab.UI.MainFrame.offsetIndex < 0 then
			CamelotCombatTab.UI.MainFrame.offsetIndex = 0
		end
		--Force update.
		CamelotCombatTab.UI.MainFrame.Update()
	end)
	local textureDown = LibUI:CreateTexture(CamelotCombatTab.name .. "_MainFrame_TextureDown", Top, {slider:GetWidth() , 15}, {BOTTOMRIGHT, BOTTOMRIGHT}, {0,0}, "/esoui/art/tooltips/tooltip_downarrow.dds", false)
	textureDown:SetMouseEnabled(true)
	textureDown:SetHandler("OnMouseDown", function() 
		CamelotCombatTab.lastTime = now --Reset Timer.
		CamelotCombatTab.UI.MainFrame.offsetIndex = CamelotCombatTab.UI.MainFrame.offsetIndex - 1
		--Max index range.
		if( CamelotCombatTab.UI.MainFrame.offsetIndex > (#CamelotCombatTab.Combat.List - CamelotCombatTab.savedVars.visibleLines) ) then
			CamelotCombatTab.UI.MainFrame.offsetIndex = CamelotCombatTab.UI.MainFrame.offsetIndex + 1 --Reverse the delta.	
		end
		--Min index range.
		if CamelotCombatTab.UI.MainFrame.offsetIndex < 0 then
			CamelotCombatTab.UI.MainFrame.offsetIndex = 0
		end
		--Force update.
		CamelotCombatTab.UI.MainFrame.Update()
	end)
	
	Top.Lines = Lines
	Top.slider = slider
	CamelotCombatTab.UI.MainFrame.Top = Top

end

function CamelotCombatTab.UI.MainFrame.Update()
	if CamelotCombatTab.UI.MainFrame.Top == nil then return end
	
	CamelotCombatTab.UI.MainFrame.Top.slider:SetMinMax(0, #CamelotCombatTab.Combat.List)
	CamelotCombatTab.UI.MainFrame.Top.slider:SetValue(#CamelotCombatTab.Combat.List - CamelotCombatTab.UI.MainFrame.offsetIndex)
	--Loop through combat list stack.
	--[[
	for i = CamelotCombatTab.savedVars.visibleLines, 1 , -1 do
	for i = CamelotCombatTab.savedVars.visibleLines, 1 , -1 do
		if CamelotCombatTab.Combat.List[i + CamelotCombatTab.UI.MainFrame.offsetIndex] ~= nil then  
			--CamelotCombatTab.Combat.List:getn()
			CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetText(CamelotCombatTab.Combat.List[i + CamelotCombatTab.UI.MainFrame.offsetIndex] .. "   " .. i + CamelotCombatTab.UI.MainFrame.offsetIndex)
		end
	end
	--]]
	for i = CamelotCombatTab.savedVars.visibleLines, 1 , -1 do
		if CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List - CamelotCombatTab.UI.MainFrame.offsetIndex - i + 1] ~= nil then  
			--CamelotCombatTab.Combat.List:getn()
			CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetText(CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List - CamelotCombatTab.UI.MainFrame.offsetIndex - i + 1])
			CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
		end
	end
end