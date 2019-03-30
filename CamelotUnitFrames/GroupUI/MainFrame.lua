local LibGroupUI = LibStub('LibUI-0.13')
if ( not LibGroupUI ) then return end
LibGroupUI.defaultFont = "ZoFontEdit"

CUF.GroupUI.MainFrame = {}
CUF.GroupUI.MainFrame.name = CUF.name .. "_GroupUI"

function CUF.GroupUI.MainFrame.Initialize()
	local top      = LibGroupUI:CreateTopLevelWindow(CUF.GroupUI.MainFrame.name .. "_MainFrame_Top", GuiRoot, {CUF.savedVars.unitGroup.dimensions[1], CUF.savedVars.unitGroup.dimensions[2]}, {TOPLEFT, TOPLEFT}, {CUF.savedVars.unitGroup.offset[1], CUF.savedVars.unitGroup.offset[2]})
    top:SetMouseEnabled(true)
	top:SetMovable(true)
    top:SetClampedToScreen(true)
	top:SetDrawLayer(0)
	top:SetScale(1.0)
    top:SetHandler("OnMouseUp", function() CUF.GroupUI.StopMovingOrResizing() end)
	
	local verticalSpacing = 30
	
	top.backdrop   = LibGroupUI:CreateBackdrop(CUF.GroupUI.MainFrame.name .. "_MainFrame_Top_Backdrop", top, {top:GetWidth(), (top:GetHeight() / 4) + (verticalSpacing * 7)}, {TOPLEFT, TOPLEFT}, {0, -30}, {0.02, 0.02, 0.02, 0.45}, {0.02, 0.02, 0.02, 0.3}, false) 
	top.backdrop:SetAlpha(0.9)
	
	
	local leaderTexture = LibGroupUI:CreateTexture(CUF.GroupUI.MainFrame.name .. "_LeaderTexture", top, {12, 9}, {TOPRIGHT, TOPRIGHT}, {0, -1}, 'CamelotUnitFrames/Textures/group_leader.dds', false)
	leaderTexture:SetDrawLayer(3)
	leaderTexture:SetHidden(true)
	top.leaderTexture = leaderTexture
	
	--Group Class Icons
	local groupClassIcons = {}
	for i = 1, 4, 1 do
	
		local anchor = top
		local anchors = {TOPLEFT, TOPLEFT}
		local offsets = {0,  0}
		if i ~= 1 then
			anchor = groupClassIcons[i - 1]
			anchors = {TOPLEFT, BOTTOMLEFT}
			offsets = {0, verticalSpacing}
		end
		
	    local classTexture = LibGroupUI:CreateTexture(CUF.GroupUI.MainFrame.name .. "_ClassIcon" .. i, top, {25, 25}, {anchors[1], anchors[2]}, {offsets[1], offsets[2]},  "/esoui/art/contacts/social_classicon_" .. CUF.Group.MemberInfo[i]["class"] .. ".dds", false)		
		classTexture:ClearAnchors()
		classTexture:SetHidden(false)
		classTexture:SetDrawLayer(3)
		classTexture:SetAnchor(anchors[1], anchor, anchors[2], offsets[1], offsets[2])
		
		groupClassIcons[i] = classTexture
	end
	top.groupClassIcons = groupClassIcons
	
	--Group Health 1 - 4
	local healthStatusGroup = {}
	for i = 1, 4, 1 do
		--Health1
		local hpStatusGroup  = LibGroupUI:CreateStatusBar(CUF.GroupUI.MainFrame.name .. "_HealthStatus" .. i, groupClassIcons[i], {top:GetWidth(), (top:GetHeight() / 4)}, {LEFT, LEFT}, {0, 0}, {0.7, 0.1, 0.2, 0.95}, BAR_ALIGNMENT_NORMAL, false)
		hpStatusGroup:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitGroup.gradient)
		hpStatusGroup.backdrop   = LibGroupUI:CreateBackdrop(CUF.GroupUI.MainFrame.name .. "_HealthStatus" .. i .. "_Backdrop", hpStatusGroup, {hpStatusGroup:GetWidth(), hpStatusGroup:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.2, 0.01, 0.01, 0.3}, {0.4, 0.0, 0.0, 0.3}, false) 
		hpStatusGroup.backdrop:SetDrawLayer(3)
		hpStatusGroup.backdrop:SetCenterTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitGroup.gradient)
		hpStatusGroup.backdrop:SetEdgeColor(0.4, 0.2, 0.2, 0.3)
		healthStatusGroup[i] = hpStatusGroup
	end

	top.healthStatusGroup = healthStatusGroup
	
	--Group Shield 1 - 4
	local shieldStatusGroup = {}
	for i = 1, 4, 1 do
		--Shield1
		local shStatusGroup = LibGroupUI:CreateStatusBar(CUF.GroupUI.MainFrame.name .. "_ShieldStatus" .. i, healthStatusGroup[i], {healthStatusGroup[i]:GetWidth(), healthStatusGroup[i]:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.9, 0.9, 0.0, 0.95}, BAR_ALIGNMENT_NORMAL, false)
		shStatusGroup:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitGroup.gradient)
		
		shieldStatusGroup[i] = shStatusGroup
	end
	top.shieldStatusGroup = shieldStatusGroup
	
	--Group Label 1 - 4
	local groupLabel = {}
	for i = 1, 4, 1 do
		--GroupLabel1
		local gLabel = LibGroupUI:CreateLabel(CUF.GroupUI.MainFrame.name .. "_UnitLabel" .. i, groupClassIcons[i], {healthStatusGroup[i]:GetWidth(), healthStatusGroup[i]:GetHeight()}, {LEFT, RIGHT}, {1, -27}, nil, nil, nil, "0", false)
		gLabel:SetFont("ZoFontGameLarge")
		gLabel:SetDrawLayer(3)
		gLabel:SetColor(1,0,1,1)
		gLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
		gLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
		groupLabel[i] = gLabel
	end
	top.groupLabel = groupLabel

	--Group hits 1 - 4
	local groupHits= {}
	for i = 1, 4, 1 do
		--GroupLabel1
		local ghitLabel = LibGroupUI:CreateLabel(CUF.GroupUI.MainFrame.name .. "_UnitHitLabel" .. i, groupClassIcons[i], {healthStatusGroup[i]:GetWidth(), healthStatusGroup[i]:GetHeight()}, {LEFT, RIGHT}, {5, 0}, nil, nil, nil, "10023/10023", false)
		ghitLabel:SetFont("ZoFontGameSmall")
		ghitLabel:SetDrawLayer(3)
		ghitLabel:SetColor(1,1,1,1)
		ghitLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
		ghitLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
		groupHits[i] = ghitLabel
	end
	top.groupHits = groupHits
	
		--Group hits 1 - 4
	local groupHitsPct= {}
	for i = 1, 4, 1 do
		--GroupLabel1
		local ghitPctLabel = LibGroupUI:CreateLabel(CUF.GroupUI.MainFrame.name .. "_UnitHitPctLabel" .. i, healthStatusGroup[i], {healthStatusGroup[i]:GetWidth(), healthStatusGroup[i]:GetHeight()}, {CENTER, CENTER}, {-4, 0}, nil, nil, nil, "100%", false)
		ghitPctLabel:SetFont("ZoFontGameSmall")
		ghitPctLabel:SetDrawLayer(3)
		ghitPctLabel:SetColor(1,1,1,1)
		ghitPctLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
		ghitPctLabel:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
		groupHitsPct[i] = ghitPctLabel
	end
	top.groupHitsPct = groupHitsPct
	
	CUF.GroupUI.MainFrame.top = top
	CUF.GroupUI.MainFrame.top:SetHidden(false)
end

function CUF.GroupUI.MainFrame.Update()
	if CUF.GroupUI.MainFrame.top == nil then return end
	
	--Clear everything out.
	for i = 1, 4 do
		CUF.GroupUI.MainFrame.top.groupClassIcons[i]:SetHidden(true)
		CUF.GroupUI.MainFrame.top.groupLabel[i]:SetText("")
		--Not Grouped.
		CUF.GroupUI.MainFrame.top.healthStatusGroup[i]:SetValue(0)
		CUF.GroupUI.MainFrame.top.shieldStatusGroup[i]:SetValue(0)
		CUF.GroupUI.MainFrame.top.groupLabel[i]:SetText("")
		CUF.GroupUI.MainFrame.top.groupClassIcons[i]:SetHidden(true)
		CUF.GroupUI.MainFrame.top.leaderTexture:SetHidden(true)
	end
	
	if CUF.Group.Info["size"] > 4 then
		return
	end
	
	--Move Group Unit Frame when cursor is hidden.
	if IsReticleHidden() then 
		--CUF.GroupUI.MainFrame.top:ClearAnchors()
		--CUF.GroupUI.MainFrame.top:SetAnchor(BOTTOMLEFT, ZO_ChatWindow, BOTTOMRIGHT, CUF.savedVars.unitGroup.offset[1], CUF.savedVars.unitGroup.offset[2])
	else
		--CUF.GroupUI.MainFrame.top:ClearAnchors()
		--CUF.GroupUI.MainFrame.top:SetAnchor(BOTTOMLEFT, ZO_ChatWindow, BOTTOMRIGHT, 0, 0)
	end
	
	--if CUF.Group.Info["size"] == 0 then return end
	--if CUF.Group.Info["size"] > 4 then return end
	
	local GroupMembers = {}
	--Fill up some group members
	for i = 1, 4, 1 do
		if CUF.Group.MemberInfo[i]["name"] ~= "" then
			--Push this group member to the list of group members
			GroupMembers[#GroupMembers + 1] = CUF.Group.MemberInfo[i]
		end
		
	end
	
	
	for i = 1, #GroupMembers do
		--Set texture to leader.
		if CUF.Group.Info["leader"] == GroupMembers[i]["name"] and GroupMembers[i]["name"] ~= "" then
	
			CUF.GroupUI.MainFrame.top.leaderTexture:ClearAnchors()
			CUF.GroupUI.MainFrame.top.leaderTexture:SetAnchor(RIGHT, CUF.GroupUI.MainFrame.top.groupLabel[i], LEFT, -8, 0)
			CUF.GroupUI.MainFrame.top.leaderTexture:SetHidden(false)
		end
		--Update class icon
		CUF.GroupUI.MainFrame.top.groupClassIcons[i]:SetHidden(false)
		CUF.GroupUI.MainFrame.top.groupClassIcons[i]:SetTexture("/esoui/art/contacts/social_classicon_" .. GroupMembers[i]["class"] .. ".dds")
		
		
		--Update Groups Health pct.
		CUF.GroupUI.MainFrame.top.healthStatusGroup[i]:SetValue(GroupMembers[i]["healthPct"])
		--Update Groups Shield pct.
		CUF.GroupUI.MainFrame.top.shieldStatusGroup[i]:SetValue(GroupMembers[i]["shieldPct"])
		
		
		
		CUF.GroupUI.MainFrame.top.groupHits[i]:SetText(GroupMembers[i]["health"] .. " / " .. GroupMembers[i]["health_max"])
		CUF.GroupUI.MainFrame.top.groupHitsPct[i]:SetText(math.floor(GroupMembers[i]["healthPct"] * 100) .. "%")
			
			
			
		--Update Groups Names.
		if GroupMembers[i]["name"] ~= "" then
			local name = GroupMembers[i]["name"]
			if GroupMembers[i]["isDead"] == true then
				name = name .. " [Dead]"
			end
			if GroupMembers[i]["online"] == false then
			
				CUF.GroupUI.MainFrame.top.groupLabel[i]:SetColor(1.0, 1.0, 1.0, 0.5)
				name = name .. " [Offline]"
			end
			CUF.GroupUI.MainFrame.top.groupLabel[i]:SetText(name)
		else
			CUF.GroupUI.MainFrame.top.groupLabel[i]:SetText("")
		end
		
		if GroupMembers[i]["inRange"] == false then
			CUF.GroupUI.MainFrame.top.healthStatusGroup[i]:SetAlpha(0.2)
			CUF.GroupUI.MainFrame.top.groupLabel[i]:SetColor(1.0, 1.0, 1.0, 0.15)
		else
			CUF.GroupUI.MainFrame.top.healthStatusGroup[i]:SetAlpha(1.0)
			CUF.GroupUI.MainFrame.top.groupLabel[i]:SetColor(1.0, 1.0, 1.0, 1.0)
		end
	end
end

function CUF.GroupUI.MainFrame.Disable()
	if (CUF.GroupUI.MainFrame.top) == nil then return end
	CUF.GroupUI.MainFrame.top:SetHidden(true)
	return
end

function CUF.GroupUI.StopMovingOrResizing()
	CUF.savedVars.unitGroup.offset = {CUF.GroupUI.MainFrame.top:GetLeft(), CUF.GroupUI.MainFrame.top:GetTop()}
end