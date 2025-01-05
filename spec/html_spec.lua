describe('html', function()
  local t, is, path, format, html, td
  setup(function()
    t = require "t"
    is = t.is
    path = t.path
    format = t.format
    html = format.html
    td = function(...) return path('testdata', ...).content end
  end)
  it("meta", function()
    assert.is_true(is.callable(html))
  end)
  it("html", function()
    assert.is_true(is.html(td("content/cbsnews.com_texas")))
		assert.equal('html', format % td("content/cbsnews.com_texas"))
  end)
end)