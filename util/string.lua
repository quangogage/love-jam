---@class str
local str = {}

function str.getWords(input)
  local words = {}

  for word in input:gmatch("[%a%d]+") do
    table.insert(words,word)
  end

  return words
end

return str
