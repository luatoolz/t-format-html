local t=require "t"
local is = t.is
local checker = t.checker
htmlparser_opts = {silent=true, looplimit=32768}
local htmlparser = require "htmlparser"
local _ = htmlparser_opts

local function unescape_html(x)
  local str = x
  str = string.gsub( str, '&apos;', "'" )
  str = string.gsub( str, '&lt;', '<' )
  str = string.gsub( str, '&gt;', '>' )
  str = string.gsub( str, '&quot;', '"' )
  str = string.gsub( str, '&q;', '"' )
  str = string.gsub( str, '&a;', '&' )
  str = string.gsub( str, '&s;', "'" )
  str = string.gsub( str, '&g;', '>' )
  str = string.gsub( str, '&l;', '<' )
--  str = string.gsub( str, '&#(%d+);', function(n) return string.char(n) end )
--  str = string.gsub( str, '&#x(%d+);', function(n) return string.char(tonumber(n,16)) end )
  str = string.gsub( str, '&amp;', '&' ) -- Be sure to do this after all others
  return str
end

-- ElementNode class
local ElementNode = require "htmlparser.ElementNode"
local SetInstance = ElementNode.select()
local class = {}
local mt = {}

mt.ElementNode = ElementNode.mt
mt.Set = getmetatable(SetInstance)
class.ElementNode = mt.ElementNode.__index
class.Set = mt.Set.__index

-- gettext()
-- textonly()
-- getcontent()
local func = {
  text=class.ElementNode["textonly"],
  content=class.ElementNode["getcontent"],
}
local attr = {title=true, href=true, value=true}

mt.ElementNode.__index = function(self, key)
	if type(key)=='number' then
		return (self.nodes or {})[key] or {}
	end
	if type(key)=='string' then
		if attr[key] then return (self.attributes or {})[key] end
		if func[key] then
      local rv = func[key](self)
      if type(rv)=='string' then rv = unescape_html(rv):trim() end
      return rv
		end
		if key=='next' then
			return self.parent~=nil and self.parent or self
		end
		return rawget(self, key) or rawget(class.ElementNode, key)
	end
end

local el__index = function(self, key)
	if type(key)=='string' then
		if func[key] or attr[key] then
      local rv = {}
      for _,v in pairs(self) do
        table.insert(rv, v[key])
      end
      return rv
		end
		return rawget(self, key)
	end
end

local el_call = mt.ElementNode.__call
mt.ElementNode.__call = function(self, ...)
  local rv = el_call(self, ...)
  return setmetatable(rv, { __index = el__index })
end

mt.Set.__index = function(self, key)
	if type(key)=='string' then
    if func[key] or attr[key] then
      local rv = {}
      for k,v in self:tolist() do
        table.insert(rv, v[key])
      end
      return rv
    else
		  return class.Set[key]
    end
	end
	if type(key)=='number' then
		return self:tolist()[key] or {}
	end
end

local types = checker({[htmlparser]=true, [mt.ElementNode]=true, [mt.Set]=true}, getmetatable)
return setmetatable({}, {
  __call = function(self, body, ...)
    if type(body)=='table' and (rawequal(getmetatable(self), getmetatable(body)) or types(body)) then return body end
    if type(body)=='string' and is.html(body) then return htmlparser.parse(body, ...) end
  end,
  __mod = function(self, it) return (types(it) or is.html(it)) and true end,
})