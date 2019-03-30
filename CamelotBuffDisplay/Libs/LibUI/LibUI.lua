local MAJOR, MINOR = "LibUI-0.13", 4
local LibUI, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibUI then return end	--the same or newer version of this lib is already loaded into memory 

LibUI.defaultFont = "ZoFontGame"

function LibUI:CreateTopLevelWindow(name, parent, dimensions, anchors, offsets, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	isHidden = isHidden or false

	local topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow(name)
	topLevelWindow:SetDimensions(dimensions[1], dimensions[2])
	topLevelWindow:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	topLevelWindow:SetHidden(isHidden)
	return topLevelWindow
end

function LibUI:CreateControl(name, parent, dimensions, anchors, offsets, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	isHidden = isHidden or false
	
	local control = WINDOW_MANAGER:CreateControl(name, parent, CT_CONTROL)
	control:SetDimensions(dimensions[1], dimensions[2])
	control:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	control:SetHidden(isHidden)
	return control
end

function LibUI:CreateControlFromVirtual(name, parent, skin, isHidden)
	if parent == nil or parent == "" then return end
	if skin == nil or skin == "" then skin = "ZO_DefaultBackdrop" end
	isHidden = isHidden or false
	
	local backdrop = WINDOW_MANAGER:CreateControlFromVirtual(name, parent, skin)
	backdrop:SetAnchorFill(parent)
	return backdrop
end

function LibUI:CreateStatusBar(name, parent, dimensions, anchors, offsets, color, barAlign, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if color == nil or #color ~= 4 then color = {1, 1, 1, 1} end
	if align == nil or #align ~= 2 then align = {1, 1} end
	isHidden = isHidden or false
	
	local statusBar = WINDOW_MANAGER:CreateControl(name, parent, CT_STATUSBAR)
	statusBar:SetDimensions(dimensions[1], dimensions[2] )
	statusBar:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	statusBar:SetMinMax(0, 1)
	statusBar:SetValue(1)
	statusBar:SetColor(color[1], color[2], color[3], color[4])
	statusBar:SetBarAlignment(barAlign)
	statusBar:SetHidden(isHidden)
	statusBar:EnableScrollingOverlay(true)
	statusBar:EnableLeadingEdge(true)
	return statusBar
end

function LibUI:CreateDropdown(name, parent, dimensions, anchors, offsets, text, choices, getFunc, setFunc, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if #choices == nil then return end
	if text == nil then text = "" end
	if getFunc == nil then return end
	if setFunc == nil then return end
	isHidden = isHidden or false
	
	--function LibUI:CreateEdit(name, parent, dimensions, anchors, offsets, font, isHidden)
	--Create an edit to immatate a dropdown control.
	local dropdown = LibUI:CreateEdit(name, parent, dimensions, anchors, offsets, nil, true)
	dropdown:SetHidden(isHidden)
	
	dropdown.backdrop = LibUI:CreateBackdrop(name .. "_Backdrop", dropdown, dimensions, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.01, 0.8}, {0.4, 0.4, 0.4, 0.8}, false) 
	
	--Arrow Down Texture.
	local arrowUp = LibUI:CreateTexture(name .. "_Texture", dropdown, {32, 32}, {RIGHT, RIGHT}, {0, 0}, "esoui/art/mappins/questpin_below.dds", false)
	
	--Create a menu system for our dropdown.
	local menu = LibUI:CreateTopLevelWindow(name .. "_Menu", dropdown, {dimensions[1], dimensions[2]}, {TOP, BOTTOM}, {0, 0}, true)
	
	menu.backdrop = LibUI:CreateBackdrop(name .. "_Menu_Backdrop", menu, {menu:GetWidth(), menu:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.01, 0.0}, {0.7, 0.7, 0.9, 0.0}, false) 
	menu.backdrop:SetDrawLayer(2)
	menu:SetDrawLayer(2)
	menu.choices = choices
	menu.selections = {}
	menu.selections.total = 0
	
	--Handlers.
	dropdown:SetHandler("OnMouseUp",function(self)
		if menu:IsHidden() == false then
			menu:SetHidden(true)
		else
			menu:SetHidden(false)
		end
	end)
	dropdown:SetHandler("OnTextChanged",function(self)
		--Build/Rebuild the selection menu.
		for i = 1, menu.selections.total, 1 do
			menu.selections[i]:SetText("")
			menu.selections[i]:SetHidden(true)
		end
		
		--Create buttons for the menu choices.
		local anchor = menu
		for i = 1, #menu.choices, 1 do
			if menu.selections[i] == nil then
				--Create this selection.
				--(name, parent, dimensions, anchors, offsets, font, color, align, text, isHidden)
				local selection = LibUI:CreateButton(name .. "_Menu_Selection_" .. i, anchor, dimensions, {TOPLEFT, TOPLEFT}, {0, 0}, nil, nil, nil, nil, nil, nil, true)
				selection:SetHorizontalAlignment(0) --Left
				selection:SetDrawLayer(3)
				selection:SetNormalFontColor(1, 1, 1, 1)
				selection:SetPressedFontColor(1, 1, 0, 1)
				selection:SetMouseOverFontColor(1, 1, 1, 1)
				selection:GetLabelControl():SetAnchor(CENTER, selection, CENTER, 50, 0)
				selection.backdrop = LibUI:CreateBackdrop(name .. "_Menu_Selection_Backdrop_" .. i, selection, dimensions, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.01, 0.95}, {0.4, 0.4, 0.4, 0.0}, false) 
				
				if i == 1 then
					selection:SetAnchor(TOPLEFT, anchor, TOPLEFT, 0, 0)
				else
					selection:SetAnchor(TOPLEFT, anchor, BOTTOMLEFT, 0, 0)
				end
				--SELECTION HIGHTLIGHTS.
				--Handlers for each selection.
				selection:SetHandler("OnMouseEnter",function(self)
					selection.backdrop:SetCenterColor(0.10, 0.10, 0.15, 0.95)
					selection.backdrop:SetEdgeColor(0.1, 0.2, 0.9, 1.0)
				end)
				
				selection:SetHandler("OnMouseExit",function(self)
					selection.backdrop:SetCenterColor(0.01, 0.01, 0.01, 0.95)
					selection.backdrop:SetEdgeColor(0.0, 0.0, 0.0, 0.0)
				end)
				
				--SELECTION HANDLER.
				selection:SetHandler("OnMouseUp",function(self)
					setFunc(selection:GetLabelControl():GetText())
					dropdown:SetText(getFunc())
					menu:SetHidden(true)
					
				end)
				
				menu.selections[i] = selection
			end
			
			anchor = menu.selections[i]
			--Unhide the newly active controls.
			menu.selections[i]:SetHidden(false)
			menu.selections[i]:SetText(menu.choices[i])
		end
		--Resize the menu.
		menu.selections.total = math.max(#menu.choices, menu.selections.total)
		
	end)
	
	dropdown:SetText(text)
	dropdown.menu = menu
	return dropdown
end

function LibUI:CreateBackdrop(name, parent, dimensions, anchors, offsets, centerColor, edgeColor, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if centerColor == nil or #centerColor ~= 4 then centerColor = {1, 1, 1, 1} end
	if edgeColor == nil or #edgeColor ~= 4 then edgeColor = {1, 1, 1, 1} end
	isHidden = isHidden or false

	local backdrop = WINDOW_MANAGER:CreateControl(name, parent, CT_BACKDROP)
	backdrop:SetDimensions(dimensions[1], dimensions[2])
	backdrop:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2] )
	backdrop:SetCenterColor(centerColor[1], centerColor[2], centerColor[3], centerColor[4] )
	backdrop:SetEdgeColor(edgeColor[1], edgeColor[2], edgeColor[3], edgeColor[4])
	backdrop:SetEdgeTexture("", 8 ,1 ,2)
	backdrop:SetHidden(isHidden)
	return backdrop
end

function LibUI:CreateTexture(name, parent, dimensions, anchors, offsets, icon, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if icon == nil or icon == "" then return end
	isHidden = isHidden or false
	
	local texture = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
	texture:SetDimensions(dimensions[1], dimensions[2])
	texture:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2] )
	texture:SetTexture(icon)
	texture:SetHidden(isHidden)
	return texture
	

end

function LibUI:CreateSlider(name, parent, dimensions, anchors, offsets, min, max, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if font == nil or font == "" then font = LibUI.defaultFont end
	if orientation == nil or "" then orientation = 0 end
	if min == nil or min == "" then min = 1 end
	if max == nil or max == "" then max = 10 end
	isHidden = isHidden or false
	
	local slider = WINDOW_MANAGER:CreateControl(name, parent, CT_SLIDER)
	local tex = "/esoui/art/miscellaneous/scrollbox_elevator.dds"
	slider:SetDimensions(dimensions[1], dimensions[2] )
	slider:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
    slider:SetThumbTexture(tex, tex, tex, 10, 10, 0, 0, 1, 1)
	slider:SetMinMax(min, max)
	slider:SetValue(min)
    slider:SetValueStep(1)
	slider:SetHidden(isHidden)
	slider:SetMouseEnabled(true)
	return slider
end

function LibUI:CreateLabel(name, parent, dimensions, anchors, offsets, font, color, align, text, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if font == nil or font == "" then font = LibUI.defaultFont end
	if color == nil or #color ~= 4 then color = {1, 1, 1, 1} end
	if align == nil or #align ~= 2 then align = {1, 1} end
	isHidden = isHidden or false
	
	local label = WINDOW_MANAGER:CreateControl(name, parent, CT_LABEL)
	label:SetDimensions(dimensions[1], dimensions[2] )
	label:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	label:SetFont(font)
	label:SetColor(color[1], color[2], color[3], color[4])
	label:SetHorizontalAlignment(align[1])
	label:SetVerticalAlignment(align[2])
	label:SetText(text)
	label:SetHidden(isHidden)
	
	return label
end

function LibUI:CreateEdit(name, parent, dimensions, anchors, offsets, font, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	state = state or BSTATE_NORMAL
	if font == nil or font == "" then font = LibUI.defaultFont end
	if align == nil or #align ~= 2 then align = {1, 1} end
	isHidden = isHidden or false
	
	--Create the edit.
	local edit = WINDOW_MANAGER:CreateControl(name, parent, CT_EDITBOX) 
	edit:SetDimensions(dimensions[1], dimensions[2])
	edit:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	edit:SetFont(font)
	edit:SetHidden(isHidden)
	edit:SetEditEnabled(true)
	edit:SetMouseEnabled(true)
	edit:SetKeyboardEnabled(true)
	edit:SetHandler("OnMouseDown", function() d("TEST") end)
	--edit:SetHandler("OnMouseEnter", function() edit:LoseFocus() end)
	--edit:SetHandler("OnMouseExit", function() d("TEST") end)
	return edit
end

function LibUI:CreateButton(name, parent, dimensions, anchors, offsets, state, font, align, normal, pressed, mouseover, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	state = state or BSTATE_NORMAL
	if font == nil or font == "" then font = LibUI.defaultFont end
	if align == nil or #align ~= 2 then align = {1, 1} end
	if normal == nil or #normal ~= 4 then normal = {1, 1, 1, 1} end
	if pressed == nil or #pressed ~= 4 then pressed = {1, 1, 0, 1} end
	if mouseover == nil or #mouseover ~= 4 then mouseover = {1, 1, 0, 1} end
	isHidden = isHidden or false
	
	-- Create the button.
	local button = WINDOW_MANAGER:CreateControl(name, parent, CT_BUTTON) 
	button:SetDimensions(dimensions[1], dimensions[2])
	button:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	button:SetFont(font)
	button:SetNormalFontColor(normal[1], normal[2], normal[3], normal[4])
	button:SetPressedFontColor(pressed[1], pressed[2], pressed[3], pressed[4])
	button:SetMouseOverFontColor(mouseover[1], mouseover[2], mouseover[3], mouseover[4])
	button:SetHorizontalAlignment(align[1])
	button:SetVerticalAlignment(align[2])
	button:SetHidden(isHidden)
	return button
end

function LibUI:CreateTextBuffer(name, parent, dimensions, anchors, offsets, font, hAlign, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if font == nil or font == "" then font = LibUI.defaultFont end
	if hAlign == nil then hAlign = 1 end
	if normal == nil or #normal ~= 4 then normal = {1, 1, 1, 1} end
	isHidden = isHidden or false
	
	-- Create the backdrop
	local textBuffer = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTBUFFER) 
	textBuffer:SetDimensions(dimensions[1], dimensions[2])
	textBuffer:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
	textBuffer:SetFont(font)
	textBuffer:SetHorizontalAlignment(hAlign)
	textBuffer:SetDrawLastEntryIfOutOfRoom(false)  --Looks shitty otherwise.
	textBuffer:SetHidden(isHidden)
	return textBuffer
end

function LibUI:CreateScroll(name, parent, dimensions, anchors, offsets, font, align, minMax, isHidden)
	if name == nil or name == "" then return end
	if parent == nil or parent == "" then parent = GuiRoot end
	if #dimensions ~= 2 then return end
	if #anchors ~= 2 then return end
	if #offsets ~= 2 then return end
	if font == nil or font == "" then font = LibUI.defaultFont end
	if align == nil or #align ~= 2 then align = {1, 1} end
	if #minMax ~= 2 then minMax = {1, 10} end
	if normal == nil or #normal ~= 4 then normal = {1, 1, 1, 1} end
	isHidden = isHidden or false
	
	-- Create the backdrop
	local scroll = WINDOW_MANAGER:CreateControl(name, parent, CT_SCROLL) 
	scroll:SetDimensions(dimensions[1], dimensions[2])
	scroll:SetAnchor(anchors[1], parent, anchors[2], offsets[1], offsets[2])
		--scroll:SetFont(font)
	--scroll:SetHorizontalAlignment(align[1])
	--scroll:SetVerticalAlignment(align[2])
	scroll:SetHorizontalScroll(1)
	scroll:SetScrollBounding(1)
	scroll:SetVerticalScroll(1)
	
	return textBuffer

end
