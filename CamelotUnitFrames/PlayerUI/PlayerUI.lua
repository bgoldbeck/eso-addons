

CUF.PlayerUI = {}

function CUF.PlayerUI.Initialize()	
	--Remove health bars.
	ZO_PlayerAttributeMagicka:UnregisterForEvent(EVENT_POWER_UPDATE)
	ZO_PlayerAttributeMagicka:UnregisterForEvent(EVENT_INTERFACE_SETTING_CHANGED)
	ZO_PlayerAttributeMagicka:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:UnregisterForUpdate("ZO_PlayerAttributeMagickaFadeUpdate")
	ZO_PlayerAttributeMagicka:SetHidden(true)
	ZO_PlayerAttributeMagicka:SetScale(0.0)
	
	ZO_PlayerAttributeStamina:UnregisterForEvent(EVENT_POWER_UPDATE)
	ZO_PlayerAttributeStamina:UnregisterForEvent(EVENT_INTERFACE_SETTING_CHANGED)
	ZO_PlayerAttributeStamina:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:UnregisterForUpdate("ZO_PlayerAttributeStaminaFadeUpdate")
	ZO_PlayerAttributeStamina:SetHidden(true)
	ZO_PlayerAttributeStamina:SetScale(0.0)
	
	ZO_PlayerAttributeHealth:UnregisterForEvent(EVENT_POWER_UPDATE)
	ZO_PlayerAttributeHealth:UnregisterForEvent(EVENT_INTERFACE_SETTING_CHANGED)
	ZO_PlayerAttributeHealth:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:UnregisterForUpdate("ZO_PlayerAttributeHealthFadeUpdate")
	ZO_PlayerAttributeHealth:SetHidden(true)
	ZO_PlayerAttributeHealth:SetScale(0.0)
	
	
	ZO_PlayerAttributeMountStamina:SetScale(0.0)
	ZO_TargetUnitFramereticleover:SetScale(0.0)  --Remove top target frame.
end