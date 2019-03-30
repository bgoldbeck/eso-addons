

CBD.Player = {}
CBD.Player.Info = {
	["BuffCount"] = 0,
	["MaxBuffs"]  = 16,
}

	
function CBD.Player.Initialize()
end

function CBD.Player.Update()
	CBD.Player.Info["BuffCount"] = GetNumBuffs('player')
	
end
