local t=require "t"
local is = t.is
local checker = t.checker
local pkg = t.pkg(...)
local unescape = pkg.unescape
local escape = pkg.escape
local escaped = pkg.escaped

htmlparser_opts = {silent=true, looplimit=32768}
local htmlparser = require "htmlparser"
local _ = htmlparser_opts

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
local attr = {title=true, href=true, value=true, content=true, type=true}
local tables = {nodes=true, attributes=true}

mt.ElementNode.__index = function(self, key)
  if tables[key] then
    return rawget(self, key) or {}
  end
	if type(key)=='number' then
    return self.nodes[key] or {}
	end
	if type(key)=='string' then
		if attr[key] then
      local rv = string.null(self.attributes[key])
      if rv then return rv end
    end
		if func[key] then
      local rv = func[key](self)
      if type(rv)=='string' then rv = string.null(unescape(rv):trim()) end
      return rv
		end
		if key=='next' then
			return self.parent~=nil and self.parent or self
		end
		return rawget(self, key) or rawget(class.ElementNode, key)
	end
end
mt.ElementNode.__mul = function(self, f)
  return table.map(self.nodes, f)
end

local el__index = function(self, key)
  if type(key)=='number' then
    return rawget(self, key) or {}
  end
	if type(key)=='string' then
    return rawget(self, key) or self[1][key]
	end
end

local el_call = mt.ElementNode.__call
mt.ElementNode.__call = function(self, ...)
  local rv = el_call(self, ...)

  return setmetatable(rv, { __name='ElementNodeList', __index = el__index, __mod = table.filter, __mul=table.map })
end

mt.Set.__index = function(self, key)
  local el = rawget(SetInstance, key)
  if el then return el end
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
mt.ElementNode.__name = 'ElementNode'
mt.Set.__name = 'Set'

return setmetatable({
  escape = escape,
  unescape = unescape,
  escaped = escaped,
}, {
  __call = function(self, body, ...)
    if type(body)=='table' and (rawequal(getmetatable(self), getmetatable(body)) or types(body)) then return body end
    if type(body)=='string' and is.html(body) then return htmlparser.parse(body, ...) end
  end,
  __mod = function(self, it) return (types(it) or is.html(it)) and true end,
})