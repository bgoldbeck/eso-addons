
CUF.Group = {}
CUF.Group.Info = {
	["size"] = 0, 
	["leader"] = "",
}
	
CUF.Group.MemberInfo = {
	
	["name"] = "",
	["inRange"] = false,
	["online"] = false,
	["healthPct"] = 0,
	["health"] = 0,
	["health_max"] = 0,
	["shieldPct"] = 0, 
	["isDead"]    = false,
	["class"]    = "",
	["level"]    = 1,
	["cplevel"]  = 0,

}

function CUF.Group.Initialize()
	
	for i = 1, 4, 1 do
		CUF.Group.MemberInfo[i] = {}
		CUF.Group.MemberInfo[i]["name"] = "test_" .. i
		CUF.Group.MemberInfo[i]["inRange"] = true
		CUF.Group.MemberInfo[i]["online"] = true
		CUF.Group.MemberInfo[i]["healthPct"] = 24.0 / i
		CUF.Group.MemberInfo[i]["health"] = 999
		CUF.Group.MemberInfo[i]["health_max"] = 1000 
		CUF.Group.MemberInfo[i]["shieldPct"] = 0.1
		CUF.Group.MemberInfo[i]["isDead"] = false
		CUF.Group.MemberInfo[i]["class"] = "Nightblade"
		CUF.Group.MemberInfo[i]["level"] = 1
		CUF.Group.MemberInfo[i]["cplevel"] = 0
	end
	CUF.Group.Info["size"] = 0
	CUF.Group.Info["leader"] = "test_1"
end


function CUF.Group.Update()
	if CUF.Group.MemberInfo[1] == nil then return end
	CUF.Group.Info["size"] = GetGroupSize()
	
	for i = 1, 4, 1 do
		CUF.Group.MemberInfo[i] = {}
		CUF.Group.MemberInfo[i]["name"] = ""
		CUF.Group.MemberInfo[i]["inRange"] = false
		CUF.Group.MemberInfo[i]["online"] = false
		CUF.Group.MemberInfo[i]["healthPct"] = 0
		CUF.Group.MemberInfo[i]["shieldPct"] = 0
		CUF.Group.MemberInfo[i]["isDead"] = false
		CUF.Group.MemberInfo[i]["class"] = ""
	end
	
	if CUF.Group.Info["size"] < 1 then return end

	for i = 1, 4, 1 do
		
		if GetUnitName("group" .. i) ~= "" then
			
			--Find who is leader.
			if IsUnitGroupLeader("group" .. i) then
				CUF.Group.Info["leader"] = GetUnitName("group" .. i)
			end
			--Get Health pcts.
			local current, maximum, effMax = GetUnitPower("group" .. i, POWERTYPE_HEALTH)
			local pct = current / maximum
			
			CUF.Group.MemberInfo[i]["health"] = current
			CUF.Group.MemberInfo[i]["health_max"] = maximum
			CUF.Group.MemberInfo[i]["healthPct"] = pct
			
			--Get Shield Status
			local shieldValue = GetUnitAttributeVisualizerEffectInfo('group' .. i, ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH)
			if shieldValue ~= nil then
				local _, maximumHealth ,_ = GetUnitPower( "group" .. i, POWERTYPE_HEALTH )
				CUF.Group.MemberInfo[i]["shieldPct"] = (shieldValue / maximumHealth)
			else
				CUF.Group.MemberInfo[i]["shieldPct"] = 0
			end
			--Get the name.
			CUF.Group.MemberInfo[i]["name"] = GetUnitName("group" .. i)
			--Get Online.
			CUF.Group.MemberInfo[i]["online"] = IsUnitOnline("group" .. i)
			
			--Dead?
			CUF.Group.MemberInfo[i]["isDead"] = IsUnitDead("group" .. i)
			--In Range?
			if GetUnitName('player') == CUF.Group.MemberInfo[i]["name"] then
				CUF.Group.MemberInfo[i]["inRange"] = true --Self always in range.
			else
				CUF.Group.MemberInfo[i]["inRange"] = IsUnitInGroupSupportRange("group" .. i)
			end
			--Get class.
		    CUF.Group.MemberInfo[i]["class"] = GetUnitClass("group" .. i)
			
		else
			--d(i)
			--CUF.Group.MemberInfo[i]["online"] = false
			--CUF.Group.MemberInfo[i]["shieldPct"] = 0
			--CUF.Group.MemberInfo[i]["healthPct"] = 0
			--CUF.Group.MemberInfo[i]["name"]      = ""       --Blank Name.
			--CUF.Group.MemberInfo[i]["inRange"]   = false
			--CUF.Group.MemberInfo[i]["isDead"]   = false
		end
		
	end
end
