local M = {}

-- cd - conversion descriptor, see http://ittner.github.io/lua-iconv/
-- args - request uri arguments table, it's modified by this function
function M.iconv(cd, args)
    for key, val in pairs(args) do
        if type(val) == "table" then
            for k, v in pairs(val) do
                val[k] = cd:iconv(v)
            end
        else
            args[key] = cd:iconv(val)
        end
    end
    return args
end

return M
