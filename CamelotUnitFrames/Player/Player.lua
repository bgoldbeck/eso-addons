

CUF.Player = {}
CUF.Player.Attributes = {
		["Percentage"] = {
			 ["health"]    = 1,
			 ["stamina"]   = 1,
			 ["magicka"]   = 1,
			 ["ultimate"]  = 1, 
			 ["mountStamina"]  = 0, },
		 ["shield"]    = 0,
		 ["rankProgress"] = 0,
		 ["expProgress"] = 0,
		 ["name"]  = "", 
		 ["veteran"]  = 0, 
		 ["level"]  = 0, 
		 ["class"]  = 0, 
		 ["rank"]  = 0, 
		 ["isDead"] = false,
		 ["Power"]  = {
			["health"] = 0,
			["stamina"] = 0,
			["magicka"] = 0,
			["ultimate"] = 0,
			["mountStamina"] = 0, },
		 --["Alliance"] = "neutral"
	}
	
function CUF.Player.Initialize()

	CUF.Player.Attributes["name"]    	   = GetUnitName('player')
	CUF.Player.Attributes["class"]         = GetUnitClass('player')

end

function CUF.Player.Update()
	local attributes = {
		{["name"] = "health"      , ["type"] = POWERTYPE_HEALTH   },
		{["name"] = "stamina"     , ["type"] = POWERTYPE_STAMINA  },
		{["name"] = "magicka"     , ["type"] = POWERTYPE_MAGICKA  },
		{["name"] = "ultimate"    , ["type"] = POWERTYPE_ULTIMATE },
		{["name"] = "mountStamina", ["type"] = POWERTYPE_MOUNT_STAMINA },
		{["name"] = "werewolf", ["type"] = POWERTYPE_WEREWOLF },
	}
	--Get the pct/power values.
	for i = 1, #attributes, 1 do
		local current, maximum, effMax = GetUnitPower( "player" , attributes[i].type )
		pct = current / maximum
	
		CUF.Player.Attributes["Percentage"][attributes[i].name] = pct
		CUF.Player.Attributes["Power"][attributes[i].name] = current
		
	end
	
	--Alliance Progress
	local aPogress = {GetAvARankProgress(GetUnitAvARankPoints('player'))}
	local aMax     = aPogress[2] - aPogress[1]
	local aCurrent = GetUnitAvARankPoints('player') - aPogress[1]
	local avaRankPct = aCurrent / aMax
	
	local xpPct = 1.0
	--Exp Progress
	if (IsUnitChampion('player')) then
		local cp = GetUnitChampionPoints("player")
		if cp < GetChampionPointsPlayerProgressionCap() then
			cp = GetChampionPointsPlayerProgressionCap()
		end
		xpMax = GetNumChampionXPInChampionPoint(cp)
		xpPct = GetPlayerChampionXP() / xpMax
	else
		local xp = GetUnitXP('player')
		local xpMax = GetUnitXPMax('player')
		xpPct = xp / xpMax
	end
	
	CUF.Player.Attributes["rankProgress"]  = avaRankPct
	CUF.Player.Attributes["expProgress"]   = xpPct
	CUF.Player.Attributes["level"]         = GetUnitLevel('player')
	CUF.Player.Attributes["rank"]          = GetUnitAvARank('player')
	CUF.Player.Attributes["veteran"]       = GetUnitChampionBattleLevel('player')
	CUF.Player.Attributes["name"]    	   = GetUnitName('player')
	CUF.Player.Attributes["isDead"]    	   = IsUnitDead('player')
	
	--Shield
	local shieldValue = GetUnitAttributeVisualizerEffectInfo('player', ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH)
	
	if shieldValue ~= nil then
		local _, maximumHealth ,_ = GetUnitPower( "player" , POWERTYPE_HEALTH )
		--CUF.Player.Attributes["shield"]    	   = (shieldValue / maximumHealth) + CUF.Player.Attributes["Percentage"]["health"] 
		CUF.Player.Attributes["shield"]    	   = shieldValue / maximumHealth
	else
		CUF.Player.Attributes["shield"]    	   = 0
	end
	
end
