local LibUI = LibStub('LibUI-0.13')
if ( not LibUI ) then return end
LibUI.defaultFont = "ZoFontEdit"

CUF.PlayerUI.MainFrame = {}
CUF.PlayerUI.MainFrame.name = CUF.name .. "_PlayerUI"
local iconSize = 30

function CUF.PlayerUI.MainFrame.Initialize()
	if GetUnitVeteranRank('player') == 14 then
		CUF.savedVars.unitPlayer.expOrRank = 1
	end
	
	local top      = LibUI:CreateTopLevelWindow(CUF.PlayerUI.MainFrame.name .. "_MainFrame_Top", ZO_ActionBar1, {370, 150}, {BOTTOM, TOP}, {CUF.savedVars.unitPlayer.offset[1], CUF.savedVars.unitPlayer.offset[2]})
    top:SetMouseEnabled(false)
	top:SetMovable(false)
    top:SetClampedToScreen(true)
	top:SetDrawLayer(0)
	top:SetScale(CUF.savedVars.unitPlayer.scale / 100)
	

	top.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_MainFrame_Top_Backdrop", top, {top:GetWidth(), top:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.02, 0.02, 0.02, 0.7}, {0.7, 0.7, 0.4, 0.2}, false) 
	local powerBarHeight = 20
	--Icon + Name + Rank + RankTexture + little Extra Buffer
	
	
	--Player class icon.
	local classTexture = LibUI:CreateTexture(CUF.PlayerUI.MainFrame.name .. "_ClassTexture", top, {25, 25}, {TOPLEFT, TOPLEFT}, {0, 0},  "/esoui/art/contacts/social_classicon_" ..CUF.Player.Attributes["class"] .. ".dds", false)
	top.classTexture = classTexture
		
	--Player Name.
	local playerNameLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_PlayerNameLabel", classTexture, {275, 25}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, GetUnitAvARank('player'), false)
	playerNameLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	playerNameLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	playerNameLabel:SetFont("ZoFontGameShadow")
	top.playerNameLabel = playerNameLabel
		
	--Rank Label
	local rankLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_AvARankLabel", playerNameLabel, {25, 25}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, GetUnitAvARank('player'), false)
	rankLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	rankLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	rankLabel:SetFont("ZoFontGameSmall")
	top.rankLabel = rankLabel

	--Rank Texture
	local avARankTexture = LibUI:CreateTexture(CUF.PlayerUI.MainFrame.name .. "_AvARankTexture", rankLabel, {25, 25}, {LEFT, RIGHT}, {0, 0},  GetAvARankIcon(GetUnitAvARank('player')), false)
	top.avARankTexture = avARankTexture
	
	local powerBarWidth = 320
	

	
	
	
	--Health
	local healthStatus  = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_HealthStatus", classTexture, {powerBarWidth, powerBarHeight + 5}, {TOPLEFT, BOTTOMLEFT}, {5, 0}, {0.7, 0.1, 0.2, 0.95}, BAR_ALIGNMENT_NORMAL, false)
	healthStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	healthStatus.backdrop = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_HealthStatus_Backdrop", 
												 healthStatus, 
												 {healthStatus:GetWidth(), 
												 healthStatus:GetHeight()}, 
												 {CENTER, CENTER}, {0, 0}, 
											   	 {0.2, 0.01, 0.01, 0.3}, 
												 {0.4, 0.0, 0.0, 0.3}, 
												 false) 
						
	healthStatus.backdrop:SetCenterTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.healthStatus = healthStatus
	
	--Health Pct
	local healthPctLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_HealthPctLabel", healthStatus, {35, powerBarHeight + 5}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, "100%", false)
	healthPctLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	healthPctLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	healthPctLabel:SetFont("ZoFontGameSmall")
	top.healthPctLabel = healthPctLabel
	
	--Shield
	local shieldStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_ShieldStatus", 
											   healthStatus, 
											   {healthStatus:GetWidth(), 
											   healthStatus:GetHeight()}, 
											   {CENTER, CENTER}, {0, 0}, 
											   {0.9, 0.9, 0.0, 0.6}, 
											   BAR_ALIGNMENT_NORMAL, 
											   false)
	shieldStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.shieldStatus = shieldStatus
	
	--Health Power
	local healthPowerLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_HealthPowerLabel", healthStatus, {healthStatus:GetWidth(), healthStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, nil, nil, nil, "0", false)
	healthPowerLabel:SetFont("ZoFontGameSmall")
	top.healthPowerLabel = healthPowerLabel


	--Stamina Status.
	local staminaStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_StaminaStatus", healthStatus,  {powerBarWidth, powerBarHeight}, {TOPLEFT, BOTTOMLEFT}, {0, 0}, {0.2, 0.7, 0.2, 0.95}, BAR_ALIGNMENT_NORMAL, false)
	staminaStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	staminaStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_StaminaStatus_Backdrop", staminaStatus, {staminaStatus:GetWidth(), staminaStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.2, 0.01, 0.3}, {0.0, 0.4, 0.0, 0.3}, false) 
	staminaStatus.backdrop:SetCenterTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.staminaStatus = staminaStatus
	
	--Stamina pct
	local staminaPctLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_StaminaPctLabel", staminaStatus, {healthPctLabel:GetWidth(), powerBarHeight}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, "100%", false)
	staminaPctLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	staminaPctLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	staminaPctLabel:SetFont("ZoFontGameSmall")
	top.staminaPctLabel = staminaPctLabel
	
	--Stamina Power
	local staminaPowerLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_StaminaPowerLabel", staminaStatus, {staminaStatus:GetWidth(), staminaStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, nil, nil, nil, "0", false)
	staminaPowerLabel:SetFont("ZoFontGameSmall")
	top.staminaPowerLabel = staminaPowerLabel
	
	--Magicka
	local magickaPctLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_MagickaPctLabel", staminaPctLabel, {staminaPctLabel:GetWidth(), powerBarHeight}, {TOP, BOTTOM}, {0, 0}, nil, nil, nil, "100%", false)
	magickaPctLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	magickaPctLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	magickaPctLabel:SetFont("ZoFontGameSmall")
	top.magickaPctLabel = magickaPctLabel
	
	--Magicka status
	local magickaStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_MagickaStatus", staminaStatus, {powerBarWidth, powerBarHeight}, {TOPLEFT, BOTTOMLEFT}, {0, 0}, {0.0, 0.6, 0.9, 0.95}, BAR_ALIGNMENT_NORMAL, false)
	magickaStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	magickaStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_MagickaStatus_Backdrop", magickaStatus, {magickaStatus:GetWidth(), magickaStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.2, 0.4}, {0.0, 0.0, 0.4, 0.3}, false) 
	magickaStatus.backdrop:SetCenterTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.magickaStatus = magickaStatus
	
	--Magicka power
	local magickaPowerLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_MagickaPowerLabel", magickaStatus, {magickaStatus:GetWidth(), magickaStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, nil, nil, nil, "0", false)
	magickaPowerLabel:SetFont("ZoFontGameSmall")
	magickaPowerLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	top.magickaPowerLabel = magickaPowerLabel
	
	--Mount
	local mountStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_MountStatus", magickaStatus, {powerBarWidth, powerBarHeight / 3}, {TOP, BOTTOM}, {0, 0}, {0.7, 0.7, 0.7, 0.8}, BAR_ALIGNMENT_NORMAL, not IsMounted())
	mountStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	mountStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_MountStatus_Backdrop", mountStatus, {mountStatus:GetWidth(), mountStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.01, 0.3}, {0.02, 0.02, 0.02, 0.3}, false) 
	mountStatus.backdrop:SetCenterTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.mountStatus = mountStatus
	
	--Rank
	local rankStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_RankStatus", magickaStatus, {powerBarWidth, powerBarHeight / 3}, {TOP, BOTTOM}, {0, 0}, {0.9, 0.3, 0.9, 0.7}, BAR_ALIGNMENT_NORMAL, IsMounted() or CUF.savedVars.expOrRank == 0)
	rankStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_RankStatus_Backdrop", rankStatus, {rankStatus:GetWidth(), rankStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.01, 0.3}, {0.02, 0.02, 0.02, 0.3}, false) 
	rankStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	rankStatus:SetHidden(true)
	top.rankStatus = rankStatus
	
	--Exp
	local expStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_expStatus", magickaStatus, {powerBarWidth, powerBarHeight / 3}, {TOP, BOTTOM}, {0, 0}, {0.9, 0.9, 0.1, 0.7}, BAR_ALIGNMENT_NORMAL, IsMounted() or CUF.savedVars.expOrRank == 1)
	expStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_ExpStatus_Backdrop", expStatus, {expStatus:GetWidth(), expStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.01, 0.01, 0.01, 0.3}, {0.02, 0.02, 0.02, 0.3}, false) 
	expStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	expStatus:SetHidden(true)
	top.expStatus = expStatus
	
	--Werewolf bar
	local werewolfStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_werewolfStatus", 
	                                             magickaStatus, 
												 {powerBarWidth, powerBarHeight / 3}, 
												 {TOP, BOTTOM}, {0, 0}, 
												 {0.1, 0.3, 0.8, 0.95}, 
												 BAR_ALIGNMENT_NORMAL, 
												 false)
	
	werewolfStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_werewolfStatus_Backdrop", 
													 werewolfStatus, 
													 {werewolfStatus:GetWidth(), 
													 werewolfStatus:GetHeight()}, 
													 {CENTER, CENTER}, {0, 0}, 
													 {0.01, 0.2, 0.2, 0.05}, 
													 {0.02, 0.02, 0.02, 0.3},
													 false) 
	werewolfStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	werewolfStatus:SetHidden(true)
	top.werewolfStatus = werewolfStatus
	
	--Target class icon
	local hitClassTexture = LibUI:CreateTexture(CUF.PlayerUI.MainFrame.name .. "_HitClassTexture", 
												magickaStatus, {25, 25}, {TOPLEFT, BOTTOMLEFT}, {0, 6},  
												"/esoui/art/contacts/social_classicon_" .. 	CUF.Player.Attributes["class"] .. ".dds", 
												false)
	top.hitClassTexture = hitClassTexture
		

	
	--Target Name
	local targetLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_TargetLabel", hitClassTexture, {180, 25}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, "Unknown", false)
	targetLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	targetLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
	targetLabel:SetFont("ZoFontGameShadow")
	top.targetLabel = targetLabel

	local championLevelTexture = LibUI:CreateTexture(CUF.PlayerUI.MainFrame.name .. "_ChampionTexture", 
													 targetLabel,
													 {23, 23}, 
													 {LEFT, RIGHT}, 
													 {0, 0},  
													 "/esoui/art/champion/champion_icon_32.dds", 
													 false)
	top.championLevelTexture = championLevelTexture
	
	--Target
	local targetLevel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_TargetLevel", championLevelTexture, {45, 25}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, "0", false)
	targetLevel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	targetLevel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
	targetLevel:SetFont("ZoFontGameShadow")
	top.targetLevel = targetLevel
	
	--Target alliance
	local allianceTexture = LibUI:CreateTexture(CUF.PlayerUI.MainFrame.name .. "_AllianceTexture", targetLevel, {20, 25}, {LEFT, RIGHT}, {0, 0},  "/esoui/art/ava/ava_allianceflag_" .. CUF.Target.Attributes["alliance"] .. ".dds", false)
	top.allianceTexture = allianceTexture
	
	--Target AvA Rank label
	local hitAvARankLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_HitAvARankLabel", allianceTexture, {25, 25}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, GetUnitAvARank('player'), false)
	hitAvARankLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	hitAvARankLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	hitAvARankLabel:SetFont("ZoFontGameSmall")
	top.hitAvARankLabel = hitAvARankLabel
	
	--Target rank texture
	local hitAvARankTexture = LibUI:CreateTexture(CUF.PlayerUI.MainFrame.name .. "_HitAvARankTexture", hitAvARankLabel, {25, 25}, {LEFT, RIGHT}, {0, 0},  GetAvARankIcon(1), false)
	top.hitAvARankTexture = hitAvARankTexture
	

	
	--Target/Hit
	local hitStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_HitStatus", hitClassTexture, {powerBarWidth, powerBarHeight}, {TOPLEFT, BOTTOMLEFT}, {0, 0}, {0.7, 0.1, 0.2, 0.9}, BAR_ALIGNMENT_NORMAL, false)
	hitStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	hitStatus.backdrop   = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_HitStatus_Backdrop", hitStatus, {hitStatus:GetWidth(), hitStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.2, 0.01, 0.01, 0.3}, {0.4, 0.0, 0.0, 0.3}, false) 
	hitStatus.backdrop:SetCenterTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.hitStatus = hitStatus
	
	--Target 'hit'
	local hitLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_HitLabel", hitStatus, {healthPctLabel:GetWidth(), 25}, {LEFT, RIGHT}, {0, 0}, nil, nil, nil, "Hit", false)
	hitLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	hitLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	hitLabel:SetFont("ZoFontGameSmall")
	top.hitLabel = hitLabel
	
	--Target 'hit' execute range
	local hitExecuteTexture = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_HitExecuteTexure", hitLabel, {25, 25}, {CENTER, CENTER}, {0, 0}, {1.0, 1.0, 1.0, 1.0}, {0.0, 0.0, 0.0, 1.0}, false) 
	hitExecuteTexture:SetCenterTexture('/esoui/art/icons/justice_stolen_skull_001.dds')
	hitExecuteTexture:SetHidden(true)
	top.hitExecuteTexture = hitExecuteTexture
	
	--Hit Shield
	local hitShieldStatus = LibUI:CreateStatusBar(CUF.PlayerUI.MainFrame.name .. "_HitShieldStatus", hitStatus, {hitStatus:GetWidth(), hitStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.9, 0.9, 0.0, 0.6}, BAR_ALIGNMENT_NORMAL, false)
	hitShieldStatus:SetTexture('CamelotUnitFrames/Textures/' .. CUF.savedVars.unitPlayer.gradient)
	top.hitShieldStatus = hitShieldStatus
	
	--Target caption.
	local hitUnitCaption = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_HitUnitCaption", GuiRoot, {top:GetWidth(), 25}, {TOP, TOP}, {0, -100}, nil, nil, nil, GetUnitCaption('player'), false)
	hitUnitCaption:SetFont("ZoFontGameShadow")
	hitUnitCaption:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	hitUnitCaption:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	hitUnitCaption.backdrop = LibUI:CreateBackdrop(CUF.PlayerUI.MainFrame.name .. "_HitUnitCaption_Backdrop", 
												   hitUnitCaption, 
												   {hitUnitCaption:GetWidth(), 
												   hitUnitCaption:GetHeight()}, 
												   {CENTER, CENTER}, {0, 0}, 
												   {0.02, 0.02, 0.02, 0.7}, 
												   {0.7, 0.7, 0.4, 0.09}, 
												   false) 
	top.hitUnitCaption = hitUnitCaption
	
	--Target health power
	local hitHealthPowerLabel = LibUI:CreateLabel(CUF.PlayerUI.MainFrame.name .. "_HitHealthPowerLabel", hitStatus, {hitStatus:GetWidth(), hitStatus:GetHeight()}, {CENTER, CENTER}, {0, 0}, nil, nil, nil, "0", false)
	hitHealthPowerLabel:SetFont("ZoFontGameSmall")
	hitHealthPowerLabel:SetVerticalAlignment(CENTER)
	top.hitHealthPowerLabel = hitHealthPowerLabel
	

	--Create Icon frames for buffs
	local Icons = {}
	for i = 1, CUF.Target.Attributes["maxBuffs"], 1 do
		local anchor = top
		local anchors = {TOPLEFT, BOTTOMLEFT}
		local offsets = {0, 1}
		if i ~= 1 then
			anchor = Icons[i - 1]
			anchors = {LEFT, RIGHT}
			offsets = {3, 0}
		end
		
		local icon = LibUI:CreateTexture(CUF.name .. "_IconTexture" .. i, anchor, {iconSize , iconSize}, {anchors[1], anchors[2]}, {offsets[1], offsets[2]}, "/esoui/art/icons/icon_potion_full.dds", true)
		icon:SetMouseEnabled(true)
		icon.index = i
		icon.backdrop = LibUI:CreateBackdrop(CUF.name .. "IconTexture_Backdrop" .. i, icon, {icon:GetWidth(), icon:GetHeight()}, {CENTER, CENTER}, {0, 0}, {0.02, 0.02, 0.02, 0.0}, {0.7, 0.7, 0.4, 0.2}, false) 
		icon.backdrop:SetDrawLayer(2)
		
		icon.status = LibUI:CreateStatusBar(CUF.name .. "_IconStatus" .. i, icon, {icon:GetWidth(), icon:GetHeight() / 7 }, {BOTTOM, BOTTOM}, {0, 0}, {0.9, 0.9, 0.0, 1.0}, BAR_ALIGNMENT_NORMAL, false)
		icon.status:SetDrawLayer(3)
		
		icon.label  = LibUI:CreateLabel(CUF.name .. "IconLabel" .. i, icon, {icon:GetWidth(), icon:GetHeight()}, {CENTER, CENTER}, {0, 0}, nil, nil, nil, "", false)
		icon.label:SetFont("ZoFontGameSmall")
		icon.label:SetColor(1, 1, 0, 1)
		
		icon:SetHandler("OnMouseEnter", function() 
			local name, start, finish, slot, stack, icon, buffType, effectType = GetUnitBuffInfo('reticleover', icon.index)
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
	
	
	EVENT_MANAGER:RegisterForEvent(CUF.PlayerUI.MainFrame.name .. "OnPlayerCombatState", EVENT_PLAYER_COMBAT_STATE, CUF.PlayerUI.MainFrame.OnPlayerCombatState)
	EVENT_MANAGER:RegisterForEvent(CUF.PlayerUI.MainFrame.name .. "OnPlayerMountState", EVENT_MOUNTED_STATE_CHANGED, CUF.PlayerUI.MainFrame.OnPlayerMountState)
	
	CUF.PlayerUI.MainFrame.top = top
	
	
end

function CUF.PlayerUI.MainFrame.OnPlayerCombatState(_, inCombat)
	if (inCombat) then
		CUF.PlayerUI.MainFrame.top.backdrop:SetEdgeColor(0.6, 0.0, 0.0, 0.9)
	else
		CUF.PlayerUI.MainFrame.top.backdrop:SetEdgeColor(0.7, 0.7, 0.4, 0.4)
	end
	
end

function CUF.PlayerUI.MainFrame.OnPlayerMountState(eventCode, mounted)
	CUF.PlayerUI.MainFrame.top.mountStatus:SetHidden(not mounted)
	
	if CUF.savedVars.unitPlayer.expOrRank == 0 then
		--Exp
		CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(mounted)
		CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(true)
	elseif CUF.savedVars.unitPlayer.expOrRank == 1 then
		--Rank
		CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(mounted)
		CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(true)
	end
end

function CUF.PlayerUI.MainFrame.Update()
	if (CUF.PlayerUI.MainFrame.top) == nil then return end
	--Hide Player Unit Frame when cursor is hidden.
	--if IsReticleHidden() then 
		--CUF.PlayerUI.MainFrame.top:SetHidden(true)
	--else
		--CUF.PlayerUI.MainFrame.top:SetHidden(false)
	--end
	
	if IsWerewolf() == true then
		CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(true)
		CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(true)
		CUF.PlayerUI.MainFrame.top.werewolfStatus:SetHidden(false)
	else
		CUF.PlayerUI.MainFrame.top.werewolfStatus:SetHidden(true)
		if CUF.savedVars.unitPlayer.expOrRank == 0 then
			--Exp
			CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(IsMounted())
			CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(true)
		elseif CUF.savedVars.unitPlayer.expOrRank == 1 then
			--Rank
			CUF.PlayerUI.MainFrame.top.rankStatus:SetHidden(IsMounted())
			CUF.PlayerUI.MainFrame.top.expStatus:SetHidden(true)
		end
	end
	
	if (CUF.Player.Attributes["isDead"] == true) then
		CUF.Player.Attributes["name"] = CUF.Player.Attributes["name"] .. " [DEAD]"
	else
		CUF.Player.Attributes["name"] = CUF.Player.Attributes["name"]
	end
	
	CUF.PlayerUI.MainFrame.top.hitClassTexture:SetTexture("CamelotUnitFrames/Textures/empty.dds")
		
	--Player Status.
	CUF.PlayerUI.MainFrame.top.healthStatus:SetValue(CUF.Player.Attributes["Percentage"]["health"])
	CUF.PlayerUI.MainFrame.top.staminaStatus:SetValue(CUF.Player.Attributes["Percentage"]["stamina"])
	CUF.PlayerUI.MainFrame.top.magickaStatus:SetValue(CUF.Player.Attributes["Percentage"]["magicka"])
	CUF.PlayerUI.MainFrame.top.mountStatus:SetValue(CUF.Player.Attributes["Percentage"]["mountStamina"])
	CUF.PlayerUI.MainFrame.top.werewolfStatus:SetValue(CUF.Player.Attributes["Percentage"]["werewolf"])
	CUF.PlayerUI.MainFrame.top.shieldStatus:SetValue(CUF.Player.Attributes["shield"])
	CUF.PlayerUI.MainFrame.top.rankStatus:SetValue(CUF.Player.Attributes["rankProgress"])
	CUF.PlayerUI.MainFrame.top.expStatus:SetValue(CUF.Player.Attributes["expProgress"])
	
	--Target Status.
	CUF.PlayerUI.MainFrame.top.hitStatus:SetValue(CUF.Target.Attributes["Percentage"]["health"])
	CUF.PlayerUI.MainFrame.top.hitShieldStatus:SetValue(CUF.Target.Attributes["shield"])
	
	--d(CUF.Player.Attributes["Shield"])
	
	if (CUF.Target.Attributes["name"] == "") then 
		--No target.
		CUF.PlayerUI.MainFrame.top.hitLabel:SetText("")
		CUF.PlayerUI.MainFrame.top.hitHealthPowerLabel:SetText("")
		CUF.PlayerUI.MainFrame.top.hitAvARankTexture:SetHidden(true)
		CUF.PlayerUI.MainFrame.top.targetLabel:SetColor(1.0, 1.0, 1.0, 0.0)
	else
		--Target
		--Target power
		CUF.PlayerUI.MainFrame.top.hitHealthPowerLabel:SetText(CUF.Target.Attributes["Power"]["health"])
		if (CUF.Target.Attributes["isPlayer"] == true ) then
			--Display Class Icon.
			CUF.PlayerUI.MainFrame.top.hitClassTexture:SetTexture("/esoui/art/contacts/social_classicon_" .. 	CUF.Target.Attributes["class"] .. ".dds")
			
			--Display Target pvp rank Icon.
			CUF.PlayerUI.MainFrame.top.hitAvARankLabel:SetText(CUF.Target.Attributes["rank"])
			CUF.PlayerUI.MainFrame.top.hitAvARankTexture:SetTexture(GetAvARankIcon(CUF.Target.Attributes["rank"]))
			CUF.PlayerUI.MainFrame.top.hitAvARankTexture:SetHidden(false)
		else
			--Non-Player.
			CUF.PlayerUI.MainFrame.top.hitAvARankTexture:SetHidden(true)
		end
	end
	
	--Get target level.
	local level = 0
	if CUF.Target.Attributes["isVeteran"] == true then
		level = CUF.Target.Attributes["veteran"]
	else
		level = CUF.Target.Attributes["level"]
	end
	
	CUF.PlayerUI.MainFrame.top.targetLevel:SetText(level)
 	if CUF.Target.Attributes["isVeteran"] == true then
		CUF.PlayerUI.MainFrame.top.targetLabel:SetText(CUF.Target.Attributes["name"])
		CUF.PlayerUI.MainFrame.top.championLevelTexture:SetHidden(false)
	elseif level > 0 then
		CUF.PlayerUI.MainFrame.top.targetLabel:SetText(CUF.Target.Attributes["name"])
		CUF.PlayerUI.MainFrame.top.championLevelTexture:SetHidden(true)
	else
		CUF.PlayerUI.MainFrame.top.targetLabel:SetText("")
		CUF.PlayerUI.MainFrame.top.championLevelTexture:SetHidden(true)
	end
	
	CUF.PlayerUI.MainFrame.top.targetLabel:SetColor(CUF.Target.Attributes["unitColor"][1],
													CUF.Target.Attributes["unitColor"][2],
													CUF.Target.Attributes["unitColor"][3],
													1.0)
											  
	CUF.PlayerUI.MainFrame.top.hitLabel:SetColor(CUF.Target.Attributes["reactionColor"][1],
												 CUF.Target.Attributes["reactionColor"][2],
												 CUF.Target.Attributes["reactionColor"][3],
												 1.0)
												 
	if CUF.Target.Attributes["Percentage"]["health"] <= 0.25 then
		CUF.PlayerUI.MainFrame.top.hitExecuteTexture:SetHidden(false)
		CUF.PlayerUI.MainFrame.top.hitLabel:SetText("")
	else
		CUF.PlayerUI.MainFrame.top.hitExecuteTexture:SetHidden(true)
		CUF.PlayerUI.MainFrame.top.hitLabel:SetText(math.ceil(CUF.Target.Attributes["Percentage"]["health"] * 100) .. "%")
	end
    
	
	--Target alliance
	if  CUF.Target.Attributes["alliance"] ~= "neutral" then
		CUF.PlayerUI.MainFrame.top.allianceTexture:SetTexture("/esoui/art/ava/ava_allianceflag_" .. CUF.Target.Attributes["alliance"] .. ".dds")
		CUF.PlayerUI.MainFrame.top.allianceTexture:SetHidden(false)
	else
		CUF.PlayerUI.MainFrame.top.allianceTexture:SetHidden(true)
	end
	
	--Target's caption.
	if CUF.Target.Attributes["caption"] ~= "" then
		CUF.PlayerUI.MainFrame.top.hitUnitCaption:SetHidden(false)
		CUF.PlayerUI.MainFrame.top.hitUnitCaption:SetText(CUF.Target.Attributes["caption"])
		CUF.PlayerUI.MainFrame.top.hitUnitCaption.backdrop:SetWidth(CUF.PlayerUI.MainFrame.top.hitUnitCaption:GetTextWidth() + 75)
	else
		CUF.PlayerUI.MainFrame.top.hitUnitCaption:SetHidden(true)
		CUF.PlayerUI.MainFrame.top.hitUnitCaption:SetText("")
	end
	
	--Get player level.
	level = 0
	if CUF.Player.Attributes["level"] == 50 then
		level = CUF.Player.Attributes["veteran"]
	else
		level = CUF.Player.Attributes["level"]
	end
	
	--CUF.PlayerUI.MainFrame.top.nameLabel:SetText(CUF.Target.Attributes["name"])
	CUF.PlayerUI.MainFrame.top.playerNameLabel:SetText(CUF.Player.Attributes["name"])
		
	if CUF.Player.Attributes["veteran"] > 0 then
	elseif level > 0 then
	end
	
	
	--Player pct's
	--d(CUF.Player.Attributes["Percentage"]["Magicka"])
	CUF.PlayerUI.MainFrame.top.healthPctLabel:SetText(math.ceil(CUF.Player.Attributes["Percentage"]["health"] * 100) .. "%")
	CUF.PlayerUI.MainFrame.top.staminaPctLabel:SetText(math.ceil(CUF.Player.Attributes["Percentage"]["stamina"] * 100) .. "%")
	CUF.PlayerUI.MainFrame.top.magickaPctLabel:SetText(math.ceil(CUF.Player.Attributes["Percentage"]["magicka"] * 100) .. "%")
	--Player power
	CUF.PlayerUI.MainFrame.top.healthPowerLabel:SetText(CUF.Player.Attributes["Power"]["health"])
	CUF.PlayerUI.MainFrame.top.staminaPowerLabel:SetText(CUF.Player.Attributes["Power"]["stamina"])
	CUF.PlayerUI.MainFrame.top.magickaPowerLabel:SetText(CUF.Player.Attributes["Power"]["magicka"])
	--Player pvp rank.
	CUF.PlayerUI.MainFrame.top.rankLabel:SetText(CUF.Player.Attributes["rank"])
	CUF.PlayerUI.MainFrame.top.avARankTexture:SetTexture(GetAvARankIcon(CUF.Player.Attributes["rank"]))
	
	--Target buffs
	for i = 1, CUF.Target.Attributes["maxBuffs"], 1 do
		local currentIcon = CUF.PlayerUI.MainFrame.top.Icons[i]
		if i <= CUF.Target.Attributes["buffCount"] then
			--name, start, finish, slot, stack, icon, type, effectType, abilityType, statusEffectType = GetUnitBuffInfo('player', i)
			local name, start, finish, slot, stack, icon, buffType, effectType = GetUnitBuffInfo('reticleover', i)
			--d(name)
			CUF.PlayerUI.MainFrame.top.Icons[i]:SetHidden(false)
			CUF.PlayerUI.MainFrame.top.Icons[i]:SetTexture(icon)
			--CUF.PlayerUI.MainFrame.top:SetWidth(iconSize * i)
			--CUF.PlayerUI.MainFrame.top.backdrop:SetWidth(iconSize * i)
			
			
			if effectType == BUFF_EFFECT_TYPE_DEBUFF then     --Debuff.
				CUF.PlayerUI.MainFrame.top.Icons[i].backdrop:SetEdgeColor(0.7, 0.2, 0.2, 0.6)
			elseif effectType == BUFF_EFFECT_TYPE_BUFF then   --Buff.
				CUF.PlayerUI.MainFrame.top.Icons[i].backdrop:SetEdgeColor(0.1, 0.7, 0.1, 0.6)
			end
			
			--Passive ability where start == finish.
			if start == finish then
				CUF.PlayerUI.MainFrame.top.Icons[i].backdrop:SetEdgeColor(0.2, 0.7, 0.7, 0.6)
				CUF.PlayerUI.MainFrame.top.Icons[i].status:SetValue(0.0)
				currentIcon.label:SetText("")
			elseif finish > start then
				local current = (GetGameTimeMilliseconds() / 1000)
				--local remaining = finish - current
				local elapsed = current - start
				local totalTime = finish - start

				local pct = elapsed / totalTime
				pct = math.abs(pct - 1.0)
				CUF.PlayerUI.MainFrame.top.Icons[i].status:SetValue(pct)
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
		else
			--Loop through rest of the icons on hide them.
			CUF.PlayerUI.MainFrame.top.Icons[i]:SetHidden(true)
		end
	end
	
	return
end

function CUF.PlayerUI.MainFrame.Disable()
	if (CUF.PlayerUI.MainFrame.top) == nil then return end
	CUF.PlayerUI.MainFrame.top:SetHidden(true)
	return
end