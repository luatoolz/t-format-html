local subst = {["&"]="&amp;", ['"']="&quot;", ["'"]="&apos;", ["<"]="&lt;", [">"]="&gt;"}
return function(value)
  if type(value) == "number" then return value end
  return tostring(value):gsub("[&\"'<>]", subst)
end