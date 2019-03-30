

CamelotCombatTab.Player = {}
CamelotCombatTab.Player.exp     = nil
CamelotCombatTab.Player.vetExp = nil
CamelotCombatTab.Player.level	= nil
CamelotCombatTab.Player.name   = nil
CamelotCombatTab.Player.money  = nil

function CamelotCombatTab.Player.Initialize()
	CamelotCombatTab.Player.exp    = GetUnitXP("player")
	CamelotCombatTab.Player.vetExp = GetUnitVeteranPoints("player")
	CamelotCombatTab.Player.level	= GetUnitLevel('player')
	CamelotCombatTab.Player.name  = GetUnitName("player")
	CamelotCombatTab.Player.money  = GetCurrentMoney()
end