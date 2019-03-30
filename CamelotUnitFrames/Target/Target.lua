


CUF.Target = {}
CUF.Target.Attributes = {
		 ["Percentage"] = {
			["health"]    = 1, },
		 --["Stamina"]   = 1,
		 --["Magicka"]   = 1,
		 --["Ultimate"]  = 1,
		 ["Power"] = {
			["health"] = 0, },
		 ["level"]     = 1,
		 ["shield"]    = 0,
		 ["veteran"]   = 0,
		 ["class"]     = "",
		 ["rank"]      = 0,
		 ["alliance"]  = 0,
		 ["name"]  = "",
		 ["unitColor"]  = {1.0, 1.0, 1.0},
		 ["reactionColor"]  = {0.0, 0.0, 0.0},
		 ["isPlayer"]     = false,
		 ["caption"]    = "",
	     ["buffCount"] = 0,
	     ["maxBuffs"]  = 16,
	}
	
function CUF.Target.Initialize()
    CUF.Target.Attributes["maxBuffs"] = 16
end

function CUF.Target.Update()
	local attributes = {
		{["name"] = "health"  , ["type"] = POWERTYPE_HEALTH   },
		--{["name"] = "Stamina" , ["type"] = POWERTYPE_STAMINA  },
		--{["name"] = "Magicka" , ["type"] = POWERTYPE_MAGICKA  },
		--{["name"] = "Ultimate", ["type"] = POWERTYPE_ULTIMATE },
	}
	
	--Get the pct/power values.
	for i = 1, #attributes, 1 do
		local current, maximum, effMax = GetUnitPower( 'reticleover' , attributes[i].type )
		pct = current / maximum
		CUF.Target.Attributes["Percentage"][attributes[i].name] = pct
		CUF.Target.Attributes["Power"][attributes[i].name]      = current
	end
	
	--Get The targets buff count
	CUF.Target.Attributes["buffCount"]     = GetNumBuffs('reticleover')
	CUF.Target.Attributes["level"]         = GetUnitLevel('reticleover')
	CUF.Target.Attributes["veteran"]       = GetUnitVeteranRank('reticleover')
	CUF.Target.Attributes["class"]         = GetUnitClass('reticleover')
	CUF.Target.Attributes["name"]    	   = GetUnitName('reticleover')
	CUF.Target.Attributes["rank"]          = GetUnitAvARank('reticleover')
	CUF.Target.Attributes["isVeteran"]     = IsUnitVeteran('reticleover')
	CUF.Target.Attributes["isDead"]        = IsUnitDead('reticleover')
	CUF.Target.Attributes["reactionColor"] = {GetUnitReactionColor('reticleover')}
	CUF.Target.Attributes["isPlayer"]      = IsUnitPlayer('reticleover')
	CUF.Target.Attributes["caption"]       = GetUnitCaption('reticleover') or GetUnitTitle('reticleover')
	
	local alliance = ""
	
	if GetUnitAlliance('reticleover') == ALLIANCE_ALDMERI_DOMINION then
		alliance = "aldmeri"
	elseif GetUnitAlliance('reticleover') == ALLIANCE_DAGGERFALL_COVENANT then
		alliance = "daggerfall"
	elseif GetUnitAlliance('reticleover') == ALLIANCE_EBONHEART_PACT then
		alliance = "ebonheart"
	else
		alliance = "neutral"
	end
	
	CUF.Target.Attributes["alliance"]      = alliance
	
	CUF.Target.Attributes["unitColor"] = {1.0, 1.0, 1.0}  --Default to white.
	
	if IsUnitGrouped('reticleover') then
		--Target is a grouped.
		CUF.Target.Attributes["unitColor"] = {0.95, 0.6 , 0.2}
	elseif IsUnitFriend( 'reticleover' ) then
		--Target is a friendy.
		CUF.Target.Attributes["unitColor"] = {0.05, 0.6 ,0.6}
	elseif(GetUnitName('reticleover') ~= "" and IsUnitPlayer('reticleover')) then
		--For every guild.
		for guildId = 1, GetNumGuilds(), 1 do
			--And for every member in each guild.
			for memberId = 1, GetNumGuildMembers(guildId), 1 do
				cvar = {GetGuildMemberCharacterInfo(guildId, memberId)}
				if cvar[2] == GetRawUnitName('reticleover') then
					--Target is a guildy.
					CUF.Target.Attributes["unitColor"] = {0.0, 0.8, 0.0}
				end
			end
		end
	end
	--Shield
	local shieldValue = GetUnitAttributeVisualizerEffectInfo('reticleover', ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH)
	if shieldValue ~= nil then
		local _, maximumHealth ,_ = GetUnitPower( "reticleover" , POWERTYPE_HEALTH )
		CUF.Target.Attributes["shield"]    	   = (shieldValue / maximumHealth)
	else
		CUF.Target.Attributes["shield"]    	   = 0
	end
	return
end
