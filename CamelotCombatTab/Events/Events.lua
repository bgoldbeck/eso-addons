
CamelotCombatTab.Events = {}



function CamelotCombatTab.Events.Initialize()
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_CAMPAIGN_QUEUE_STATE_CHANGED, CamelotCombatTab.Events.CampaignStateUpdate)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_LEADER_UPDATE, CamelotCombatTab.Events.OnGroupLeaderUpdate)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_GROUP_MEMBER_JOINED, CamelotCombatTab.Events.OnMemberJoinedGroup)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_GROUP_MEMBER_LEFT, CamelotCombatTab.Events.OnMemberLeftGroup)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_GROUP_INVITE_RECEIVED, CamelotCombatTab.Events.OnGroupInviteReceived)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_RESURRECT_REQUEST, CamelotCombatTab.Events.OnResurrectRequest)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_REVENGE_KILL, CamelotCombatTab.Events.OnRevengeKill)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_JUMP_FAILED, CamelotCombatTab.Events.OnJumpFailed)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_JUMP_FAILED, CamelotCombatTab.Events.OnLockpickSuccess)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_LOCKPICK_SUCCESS, CamelotCombatTab.Events.OnLockpickSuccess)
    EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_LOCKPICK_FAILED, CamelotCombatTab.Events.OnLockpickFailed)
	
end

function CamelotCombatTab.Events.CampaignStateUpdate(event, campaignId, isGroup, state)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local newMessage = ""
	local color = CamelotCombatTab.savedVars.eventColor
	if state == CAMPAIGN_QUEUE_REQUEST_STATE_CONFIRMING then
		if isGroup == true then
			newMessage = color .. "[Your group is ready to enter Cyrodil on " .. GetCampaignName(campaignId, isGroup) .. "]"
		else
			newMessage = color .. "[You are ready to enter Cyrodil on " .. GetCampaignName(campaignId, isGroup) .. "]"
		end
	end
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnGroupLeaderUpdate(eventCode, leaderTag)
	if leaderTag == "" or leaderTag == nil then return end
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local newMessage = color .. "[The group leader has changed to " .. GetUnitName(leaderTag) .. "]"
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnMemberJoinedGroup(eventCode, memberName)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	memberName = string.gsub(memberName, "%^.*", "")
	local newMessage = color .. "[" .. memberName .. " has joined the group]"	
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnMemberLeftGroup(eventCode, memberName)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	memberName = string.gsub(memberName, "%^.*", "")
	
	local newMessage = color .. "[" .. memberName .. " has left the group]"
	
	--Add new event to list.
	CamelotCombatTab.Combat.List.Push(newMessage)
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
end

function CamelotCombatTab.Events.OnGroupInviteReceived(eventCode, inviterName)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local newMessage = color .. "[Group invite request from " .. inviterName .. "]"
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnResurrectRequest(eventCode, requester, timeLeftToAccept)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local newMessage = color .. "[" .. requester .. " has offered you a resurrection!]"
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnRevengeKill(eventCode, killedPlayerName)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local resolvedName = killedPlayerName:match("([^^]+)^([^^]+)")
	local newMessage = ""
	if resolvedName ~= nil then
		local newMessage = color .. "[You have taken your revenge upon " .. resolvedName .. "!]"
	end
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnJumpFailed(eventCode, reason)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local newMessage = color .. "[Jump failed!]"
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnLockpickSuccess(eventCode)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local newMessage = color .. "[Lockpick success!]"
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

function CamelotCombatTab.Events.OnLockpickFailed(eventCode)
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	local color = CamelotCombatTab.savedVars.eventColor
	local newMessage = color .. "[Lockpick failed!]"
	
	if newMessage ~= "" then
		--Add new event to list.
		CamelotCombatTab.Combat.List.Push(newMessage)
		--Update the UI.
		CamelotCombatTab.UI.MainFrame.Update()
	end
end

