local t=require 't'
local tag = require 't.format.html.tag'
local gmatch = t.gmatch
local ok = 0.8

return function(x)
  local found, balance, head, cost, bad = 0, 0, 0, 0, 0
  local loop = 0

  local function getcost(alt)
    if found > 0 then
      local b = balance
      if not b or b == 0 then b = 1 end
      return (cost / (cost + b + bad)) ^ 10
    end
    return alt or 0
  end

  local function process(q)
    loop = loop + 1
    q = q:gsub('%s*', '')

    local it, clean = q, q:gsub('%/*', '')
    local closing = it ~= clean
    q = clean

    if tag.any[q] then
      found = found + 1
      if tag.header[it] then
        head = head + 1
        cost = cost + tag.header[it]
      else
        if closing then
          balance = balance - 1
          cost = cost + 2
        else
          balance = balance + 1
          cost = cost + 1
        end
      end
    else
      bad = bad + 2
    end
    return getcost(0)
  end

  if type(x) == 'string' then
    if not x:match('^%s*%<.*%>%s*$') then return nil end
    local header = x:match('^(.*%<%s*%/%s*head%s*%>)')
    if header then
      for m in gmatch.htmltags(header) do
        local bb = process(m)
        if bb > ok then return true end
      end
    end
    for m in gmatch.htmltags(header) do if process(m) > ok then return true end end
  end
  return getcost() > ok or nil
end