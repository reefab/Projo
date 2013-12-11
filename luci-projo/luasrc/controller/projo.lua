module("luci.controller.projo", package.seeall)


host = "192.168.1.3"
port = 2323

commands = {
        ["power"]= {["on"]= "POW=ON", ["off"]= "POW=OFF", ["status"]= "POW=?"},
        ["blank"]= {["on"]= "BLANK=ON", ["off"]= "BLANK=OFF", ["status"]= "BLANK=?"},
        ["modelname"]= {["status"]= "MODELNAME=?"},
        ["menu"]= {
                    ["on"]= "MENU=ON",
                    ["off"]= "MENU=OFF",
                    ["up"]= "UP",
                    ["down"]= "DOWN",
                    ["right"]= "RIGHT",
                    ["left"]= "LEFT",
                    ["enter"]= "ENTER"
                },
        ["3d"]= {
                ["status"]= "3D=?",
                ["sbs"]= "3D=SBS",
                ["tb"]= "3D=TB",
                ["fs"]= "3D=FS",
                ["off"]= "3D=OFF"
              }
}

function index()
    entry({"projo", "power"}, call("power")).dependent=false
    entry({"projo", "power", "on"}, call("power")).dependent=false
    entry({"projo", "power", "off"}, call("power")).dependent=false
end

function power()
    --luci.http.prepare_content("application/json")
    --luci.http.write_json({["status"]= "ok"})

    luci.http.prepare_content("application/json")
    if get_method() == 'GET' then
        local result = read_serial(commands.power.status)
        luci.http.write_json({["status"]= result:lower()})
    else
        local status = get_node()
        --luci.http.write_json({["status"]= status})
        if commands.power[status] then
            write_serial(commands.power[status])
            luci.http.write_json({["status"]= "ok"})
        end
    end
end


function read_serial(command)
    require("nixio.util")
    local nixio = require("nixio")
    local sock, code, msg = nixio.connect(host, port)
    if not sock then
        return nil, code, msg
    end
    local ser_command = string.format("\r*%s#\r", command)
    sock:sendall(ser_command)

    local linesrc = sock:linesource()
    local line, code, error = linesrc()

    line = linesrc()
    local key, value = line:match("(%w+)=(%w+)")
    sock:close()
    return value
end

function write_serial(command)
    require("nixio.util")
    local nixio = require("nixio")
    local sock, code, msg = nixio.connect(host, port)
    if not sock then
        return nil, code, msg
    end
    local ser_command = string.format("\r*%s#\r", command)
    sock:sendall(ser_command)
    sock:close()
end

function get_method()
    return luci.http.getenv("REQUEST_METHOD")
end

function get_node()
    local uri = luci.http.getenv("REQUEST_URI")
    return uri:match("(%w+)$")
end
