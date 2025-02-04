describe('html', function()
  local t, is, path, format, html, td
  setup(function()
    t = require "t"
    is = t.is
    path = t.path
    format = t.format
    html = format.html
    td = function(...) return path('testdata', ...).file.content end
  end)
  it("meta", function()
    assert.is_true(is.callable(html))
  end)
  it("html", function()
    local data = td("content/cbsnews.com_texas")
    assert.is_true(is.html(data))
		assert.equal('html', format % data)
  end)
  it("root", function()
    local root = html(td("content/cbsnews.com_texas"))
    local divs = root('div')
    assert.is_table(divs)
    assert.is_table(divs[1])
    assert.is_table(divs[1].nodes)
    local not_empty = divs[1]
    assert.not_nil(next(not_empty))

    local nodivs = root('div.noneexistent')
    assert.is_table(nodivs)
    assert.is_table(nodivs[1])
    assert.is_nil(nodivs[1].nodes)
    assert.is_nil(nodivs.nodes)

    local empty = nodivs[1]
    assert.equal(0, #empty)
    assert.is_nil(next(empty))
  end)
end)