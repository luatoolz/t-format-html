require 't'
return {
  any    = string.tohash([[ a article b base bdo blockquote body br button caption circle cite code dd defs dfn div dl DOCTYPE dt em figcaption figure footer foreignobject form g h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe image img input kbd label li line link mark marker meta nav noscript ol p path pattern pre q rect rt ruby samp script section small source span strong style sub sup svg symbol table tbody td text tfoot th thead title tr ul var video ]]),
  paired = string.tohash([[ article body circle defs figcaption figure footer g h3 h4 head header html iframe li line nav path rect script section source style svg symbol title ul video ]]),
  header = {DOCTYPE=10, html=5, head=5, ['/head']=20, title=5, ['/title']=10, ['style']=1, ['/style']=2, meta=1, link=1},
}