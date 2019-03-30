
CamelotCombatTab.Combat.List = {}

function CamelotCombatTab.Combat.List.Initialize()
	local ii = 1
	for i = 1, CamelotCombatTab.savedVars.visibleLines, 1 do
		local str = ""
		for j = 1, ii, 1 do
			str = str .. string.format("%c", 32)
		end
		ii = ii + 1
		--d("T" .. str .. "TEST")
		CamelotCombatTab.Combat.List.Push(str)
	end
end

function CamelotCombatTab.Combat.List.Push(value)
	
	for i = 1, 5 do
		if CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List] == value .. " [x" .. i .. "]" then
			
			CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List] = value .. "[x" .. (i + 1) .. "]"
			return
		end
	end
	
	if CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List] == value then
		CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List] = CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List] .. " [x2]"
		return
	end
	
	--New is on top and we will reverse traverse orders.
	CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List + 1] = value
	
	--Check if our stack is full. We must remove old lines.
	if #CamelotCombatTab.Combat.List > CamelotCombatTab.savedVars.numLines then
		local difference = #CamelotCombatTab.Combat.List - CamelotCombatTab.savedVars.numLines
		
		--Erased from list.
		CamelotCombatTab.Combat.List:Pop(difference)
	end
end


function CamelotCombatTab.Combat.List.Pop()
	--Pop the oldest first. Lower index = older.
	--CamelotCombatTab.Combat.List[1] = nil --Remove first element.
	
	--Shift every element in the list by i - 1
	for i = 2, #CamelotCombatTab.Combat.List, 1 do
		--Previous element = this element.
		CamelotCombatTab.Combat.List[i - 1] = CamelotCombatTab.Combat.List[i]
	end
	--Delete the last element in the list as it is redundant now.
	CamelotCombatTab.Combat.List[#CamelotCombatTab.Combat.List] = nil
	
end