describe('escape', function()
  local t, is, path, html, td
  setup(function()
    t = require "t"
    is = t.is
    path = t.path
    html = t.format.html
    td = path('testdata', 'content')
  end)
  it("meta", function()
    assert.is_true(is.callable(html))
  end)
  it("html", function()
    assert.is_true(html.escaped((td/"escaped.html").content))
    assert.is_true(html.escaped((td/"escaped2.html").content))
    assert.is_true(html.escaped((td/"escaped3.html").content))

    assert.is_nil(html.escaped((td/"unescaped.html").content))
    assert.equal('Tiago Danin :)', html.unescape('&#84;&#105;&#97;&#103;&#111;&#32;&#68;&#97;&#110;&#105;&#110;&#32;&#58;&#41;'))
  end)
end)