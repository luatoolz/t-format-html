require 't'
local escaped = string.matcher('%&%#?x?%w+;')
return function(x) return escaped(x) and true or nil end