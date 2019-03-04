local parser = require "uf.pbc.parser"
local protobuf = require "uf.pbc.protobuf"

local M = {}

--
function M.readFile(filePath, fileName)
    local buffer = cc.FileUtils:getInstance():getStringFromFile(filePath)
    parser.registerBuffer(fileName, buffer)
end

--
function M.readBuffer(buffer, fileName)
    parser.registerBuffer(fileName, buffer )
end

--
local function _expand(t)
    if type(t) == "table" then
        for k, v in pairs(t) do  
            if type(v) == "table"  then
                local meta = getmetatable(v)
                if meta and meta.__pairs ~= nil then
                    protobuf.expand(v)
                end
                _expand(v)
            else

            end
        end
    end
end

--
function M.encode(id, buff)
    return protobuf.encode(id, buff)
end

--
function M.decode(id, buff, len)
    if len == 0 then
        --buffer len =0 , donot need to parse
        return {}
    end
    
    local buff, err = protobuf.decode(id, buff, len)
    _expand(buff)

    if buff == false then
        --print("buff error " .. key .. ":" .. err)
        return nil, false
    else
        return buff, true
    end
end

return M