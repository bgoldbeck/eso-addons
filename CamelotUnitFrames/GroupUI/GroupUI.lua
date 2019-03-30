

CUF.GroupUI = {}

function CUF.GroupUI.Initialize()
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_GROUP_MEMBER_JOINED,           CUF.GroupUI.RemoveDefaultGroupFrame)
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_GROUP_INVITE_RECEIVED,         CUF.GroupUI.RemoveDefaultGroupFrame)
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_GROUP_MEMBER_LEFT,             CUF.GroupUI.RemoveDefaultGroupFrame)
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_GROUP_MEMBER_CONNECTED_STATUS, CUF.GroupUI.RemoveDefaultGroupFrame)
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_LEADER_UPDATE,                 CUF.GroupUI.RemoveDefaultGroupFrame)
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_PLAYER_COMBAT_STATE,           CUF.GroupUI.RemoveDefaultGroupFrame)
	EVENT_MANAGER:RegisterForEvent(CUF.name, EVENT_EXPERIENCE_UPDATE,             CUF.GroupUI.RemoveDefaultGroupFrame)
	CUF.GroupUI.RemoveDefaultGroupFrame()
end

function CUF.GroupUI.RemoveDefaultGroupFrame()
	for i = 1, 4, 1 do
		local ctrl   = "ZO_GroupUnitFramegroup"
		local frame  = _G[ctrl..i]
		if frame ~= nil then
			frame:SetScale(0.0)
			frame:SetHidden(true)
		end
	end
end
