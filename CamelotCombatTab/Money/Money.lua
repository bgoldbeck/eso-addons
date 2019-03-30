

CamelotCombatTab.Money = {}

function CamelotCombatTab.Money.Initialize()
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_MONEY_UPDATE, CamelotCombatTab.Money.OnMoneyUpdate)
end


function CamelotCombatTab.Money.OnMoneyUpdate(eventCode, newMoney, oldMoney, reason) 
	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
	CamelotCombatTab.lastTime = GetFrameTimeSeconds()
	
	--What did we get?
	local gained = newMoney - oldMoney
	
	--Don't show any weird stuff.
	if gained == 0 then return end
	
	local context = ""
	if gained > 0 then
		context = "You earned"
	elseif gained < 0 then
		context = "You spent"
	end
	--The message to show
	local newMessage = string.format(CamelotCombatTab.savedVars.moneyGainColor .. "%s %s coin", context, gained)

	--Add new event to list.
	CamelotCombatTab.Combat.List.Push(newMessage)
	
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
end