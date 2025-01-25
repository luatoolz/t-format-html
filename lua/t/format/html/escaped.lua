require 't'
local escaped = string.matcher('&#?x?[%d%a]+;')
return function(x) return escaped(x) and true or nil end