CamelotCombatTab.LFGFilter = {}

function CamelotCombatTab.LFGFilter.Initialize()
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_CHAT_MESSAGE_CHANNEL, CamelotCombatTab.LFGFilter.OnChatMessage)
end

function CamelotCombatTab.LFGFilter.OnChatMessage(event, channel, from, message)
	lookingStrings = 
	{
		"LFG", "LF ", "lfg", "lf ", "lfm", "LFM", "forming", "dps"
	}
	from = string.gsub(from, "%^.*", "")
	
	for i = 1, #lookingStrings, 1 do
		if string.match(message, lookingStrings[i]) then
			--Add new event to list.
			CamelotCombatTab.Combat.List.Push(from .. ": |cFF55FF" .. message)
			--Update the UI.
			CamelotCombatTab.UI.MainFrame.Update()
			for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
				CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
				CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetAlpha(1.0)
				CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
				CamelotCombatTab.lastTime = GetFrameTimeSeconds()
			end
		end
	end
end
