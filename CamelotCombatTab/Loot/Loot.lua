


CamelotCombatTab.Loot = {}


function CamelotCombatTab.Loot.Initialize()
	EVENT_MANAGER:UnregisterForEvent(CamelotCombatTab.name, EVENT_LOOT_RECEIVED)
	EVENT_MANAGER:RegisterForEvent(CamelotCombatTab.name, EVENT_LOOT_RECEIVED, CamelotCombatTab.Loot.OnItemLooted)
end


function CamelotCombatTab.Loot.OnItemLooted(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self)
	if not self then return end

	for i = 1,  CamelotCombatTab.savedVars.visibleLines, 1 do
		CamelotCombatTab.UI.MainFrame.Top.Lines[i]:SetHidden(false)
	end
	
	CamelotCombatTab.UI.MainFrame.Top:SetAlpha(1.0)
	CamelotCombatTab.lastTime = GetFrameTimeSeconds()
	itemName = zo_strformat("<<t:1>>", itemName)
	--local text, color = ZO_LinkHandler_ParseLink( itemName )
	--d(itemName)
	--d(text)
	--if text == nil then return end
	--text = string.gsub(text, "%^.*", "")
	--text = zo_strformat(SI_TOOLTIP_ITEM_NAME, text)
	
	--if color == nil then color = "ffffff" end
	--if text == nil then return end
	
	--d(text)
	local newMessage = string.format("%sLooted %s of %s", CamelotCombatTab.savedVars.lootColor, quantity, itemName)
	
	
	--Add new event to list.
	CamelotCombatTab.Combat.List.Push(newMessage)
	--Update the UI.
	CamelotCombatTab.UI.MainFrame.Update()
end