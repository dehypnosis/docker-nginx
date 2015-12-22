functions = require("functions")
iconv = require("iconv")
luaunit = require("luaunit")

data = {
    { ["q1"] = "abc", ["q2"] = "123" },
    { ["q1"] = { "abc", "def" } },
    { ["q1"] = "абв", ["q2"] = "123" },
    { ["q1"] = { "абв", "где" } },
}

expect = {
    { ["q1"] = "abc", ["q2"] = "123" },
    { ["q1"] = { "abc", "def" } },
    { ["q1"] = "Р°Р±РІ", ["q2"] = "123" },
    { ["q1"] = { "Р°Р±РІ", "РіРґРµ" } },
}

TestFunctions = {}
function TestFunctions:testInconv()
    local cd = iconv.new("utf8", "cp1251")
    for k, _ in pairs(data) do
        luaunit.assertEquals(functions.iconv(cd, data[k]), expect[k])
    end
end

os.exit(luaunit.LuaUnit.run())
