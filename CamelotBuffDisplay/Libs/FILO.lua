-- CHILLCODE™
-- GLOBAL
FILO = {}
local print = d

-- Create a Table with stack functions
function FILO:Create()
  
function ripairs(t)
  local max = 1
  while t[max] ~= nil do
    max = max + 1
  end
  local function ripairs_it(t, i)
	i = i-1
	local v = t[i]
	if v ~= nil then
	  return i,v
	else
	  return nil
	end
  end
  return ripairs_it, t, max
  end
  -- stack table
  local t = {}
  -- entry table
  t._et = {}

  -- push a value on to the stack
  function t:push(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ripairs(targs) do
        table.insert(self._et, v)
      end
    end
  end

  -- pop a value from the stack
  function t:pop(num)

    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get First entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[1])
		
        -- remove last value
        table.remove(self._et)
      else
        break
      end
    end
    -- return unpacked entries
    return unpack(entries)
  end

  -- get entries
  function t:getn()
    return #self._et
  end

  -- list values
  function t:list()
    for i,v in pairs(self._et) do
      print(i, v)
    end
  end
  return t

end

-- CHILLCODE™