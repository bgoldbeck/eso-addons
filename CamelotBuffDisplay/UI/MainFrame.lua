local LibUI = LibStub('LibUI-0.13')
if ( not LibUI ) then return end
LibUI.defaultFont = "ZoFontEdit"

CBD.UI.MainFrame = {}

function CBD.UI.MainFrame.Initialize()
	local iconSize = CBD.savedVars.iconSize
	local top      = LibUI:CreateTopLevelWindow(CBD.name .. "_MainFrame_Top", GuiRoot, {iconSize * CBD.Player.Info["MaxBuffs"], iconSize}, {TOP, TOP}, {CBD.savedVars.offset[1], CBD.savedVars.offset[2]})
	
    top:SetMouseEnabled(true)
	top:SetMovable(false)
    top:SetClampedToScreen(true)
	top:SetDrawLayer(0)
	top:SetScale(1.0)
	
	top.backdrop   = LibUI:CreateBackdrop(CBD.name .. "_MainFrame_Top_Backdrop", top, {top:GetWidth(), top:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.02, 0.02, 0.02, 0.7}, {0.7, 0.7, 0.4, 0.2}, false) 
	top.backdrop:SetHidden(true)
	top.label      = LibUI:CreateLabel(CBD.name .. "_MainFrame_Top_Label", ZO_CompassFrame, {400, 35}, {TOP, BOTTOM}, {0, 0}, nil, nil, nil, "", true)
	
	--Create Icon frames
	local Icons = {}
	for i = 1, CBD.Player.Info["MaxBuffs"], 1 do
		local anchor = top
		local anchors = {LEFT, LEFT}
		local offsets = {0, 0}
		if i ~= 1 then
			anchor = Icons[i - 1]
			anchors = {LEFT, RIGHT}
			offsets = {3, 0}
		end
		local icon = LibUI:CreateTexture(CBD.name .. "_IconTexture" .. i, anchor, {iconSize , iconSize}, {anchors[1], anchors[2]}, {offsets[1], offsets[2]}, "/esoui/art/icons/icon_potion_full.dds", true)
		icon:SetMouseEnabled(true)
		icon.index = i
		icon.backdrop = LibUI:CreateBackdrop(CBD.name .. "IconTexture_Backdrop" .. i, icon, {icon:GetWidth(), icon:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.02, 0.02, 0.02, 0.0}, {0.7, 0.7, 0.4, 0.2}, false) 
		icon.backdrop:SetDrawLayer(2)
		
		icon.status = LibUI:CreateStatusBar(CBD.name .. "_IconStatus" .. i, icon, {icon:GetWidth(), icon:GetHeight() / 7 }, {BOTTOM, BOTTOM}, {0, 0}, {0.2, 0.95, 1.0, 1.0}, BAR_ALIGNMENT_NORMAL, false)
		icon.status:SetDrawLayer(3)
		
		icon.label  = LibUI:CreateLabel(CBD.name .. "IconLabel" .. i, icon, {icon:GetWidth(), icon:GetHeight()}, {CENTER, CENTER}, {0, 0}, nil, nil, nil, "", false)
		icon.label:SetFont("ZoFontGameSmall")
		icon.label:SetColor(1, 1, 0, 1)
		
		icon:SetHandler("OnMouseEnter", function() 
			local name, start, finish, slot, stack, icon, buffType, effectType = GetUnitBuffInfo('player', icon.index)
			top.label:SetHidden(false)
			top.label:SetText(name)
		end)
		
		icon:SetHandler("OnMouseExit", function() 
			top.label:SetHidden(true)
			top.label:SetText("")
		end)
		--icon.status:SetTexture('CamelotUnitFrame/Textures/' .. CUF.savedVars.gradient)
		
		Icons[i] = icon
	end
	top.Icons = Icons
	
	CBD.UI.MainFrame.top = top
end


function CBD.UI.MainFrame.Update()
	if (CBD.UI.MainFrame.top) == nil then return end
	
	buff_name = {}
	buff_start = {}
	buff_end = {}
	buff_slot = {}
	buff_stack = {}
	buff_icon = {}
	buff_type = {}
	buff_effect = {}
	count = 1
	
	--Target buffs
	for i = 1, CBD.Player.Info["MaxBuffs"], 1 do
		CBD.UI.MainFrame.top.Icons[i]:SetHidden(true)
		local name, start, finish, slot, stack, icon, buffType, effectType = GetUnitBuffInfo('player', i)
		if start ~= finish then
			buff_name[count] = name
			buff_start[count] = start
			buff_end[count] = finish
			buff_slot[count] = slot
			buff_stack[count] = stack
			buff_icon[count] = icon
			buff_type[count] = buffType
			buff_effect[count] = effectType
			count = count + 1
		end
	end
	
	for i = 1, count - 1, 1 do
		local currentIcon = CBD.UI.MainFrame.top.Icons[i]
		
		local name, start, finish, slot, stack, icon, buffType, effectType = buff_name[i], buff_start[i], buff_end[i], buff_slot[i], buff_stack[i], buff_icon[i], buff_type[i], buff_effect[i]
		--d(name)
		CBD.UI.MainFrame.top.Icons[i]:SetHidden(false)
		CBD.UI.MainFrame.top.Icons[i]:SetTexture(icon)
		CBD.UI.MainFrame.top:SetWidth(CBD.savedVars.iconSize * i)
		CBD.UI.MainFrame.top.backdrop:SetWidth(CBD.savedVars.iconSize * i)
		
		
		if effectType == BUFF_EFFECT_TYPE_DEBUFF then     --Debuff.
			CBD.UI.MainFrame.top.Icons[i].backdrop:SetEdgeColor(0.7, 0.2, 0.2, 0.6)
		elseif effectType == BUFF_EFFECT_TYPE_BUFF then   --Buff.
			CBD.UI.MainFrame.top.Icons[i].backdrop:SetEdgeColor(0.1, 0.7, 0.1, 0.6)
		end
		

		local current = (GetGameTimeMilliseconds() / 1000)
		--local remaining = finish - current
		local elapsed = current - start
		local totalTime = finish - start

		local pct = elapsed / totalTime
		pct = math.abs(pct - 1.0)
		CBD.UI.MainFrame.top.Icons[i].status:SetValue(pct)
		--Remaining time.
		local remaining = (finish - current) / 60
		local secsRemaining = remaining * 60
		local timeStr = ""
		if secsRemaining > 59 then
			--Minutes.
			timeStr = math.floor(secsRemaining/60) .. "m"
		elseif secsRemaining > 3599 then
			--Hours.
			timeStr = math.floor(secsRemaining/60/60) .. "h"
		elseif secsRemaining > 3599 then
			--Days.
			timeStr = math.floor(secsRemaining/24/60/60) .. "d"
		else
			--Seconds
			timeStr = math.floor(secsRemaining) .. "s"
		end
		currentIcon.label:SetText(timeStr)
	end
	return
end