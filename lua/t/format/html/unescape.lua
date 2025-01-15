local to = {apos="'",lt='<',gt='>',quot='"',q='"',a='&',s="'",g='>',l='<',amp='&',}
return function(x)
  if type(x)~='string' then return x end
  return string.gsub(x, '&(#?x?([%d%a]+));',
    function(a,b)
      if to[a] then return to[a] end
      if b:match('^%d+$') then
        local ar = (string.sub(a, 1, 1)=='#' and string.sub(a, 2, 1)~='x') and b or tonumber(b,16)
        return string.char(ar) or nil
      end
    end)
end