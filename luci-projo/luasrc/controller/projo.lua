module("luci.controller.projo", package.seeall)


host = "127.0.0.1"
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
    entry({"projo", "blank"}, call("blank")).dependent=false
    entry({"projo", "blank", "on"}, call("blank")).dependent=false
    entry({"projo", "blank", "off"}, call("blank")).dependent=false
    entry({"projo", "menu", "on"}, call("menu")).dependent=false
    entry({"projo", "menu", "off"}, call("menu")).dependent=false
    entry({"projo", "menu", "up"}, call("menu")).dependent=false
    entry({"projo", "menu", "down"}, call("menu")).dependent=false
    entry({"projo", "menu", "right"}, call("menu")).dependent=false
    entry({"projo", "menu", "left"}, call("menu")).dependent=false
    entry({"projo", "menu", "enter"}, call("menu")).dependent=false
    entry({"projo", "modelname"}, call("modelname")).dependent=false
    entry({"projo", "3d"}, call("threedee")).dependent=false
    entry({"projo", "3d", "sbs"}, call("threedee")).dependent=false
    entry({"projo", "3d", "tb"}, call("threedee")).dependent=false
    entry({"projo", "3d", "fs"}, call("threedee")).dependent=false
    entry({"projo", "3d", "off"}, call("threedee")).dependent=false
end

function power()
    luci.http.prepare_content("application/json")
    if get_method() == 'GET' then
        local result = read_serial(commands.power.status)
        luci.http.write_json({["status"]= result:lower()})
    else
        local status = get_node()
        if commands.power[status] then
            write_serial(commands.power[status])
            luci.http.write_json({["status"]= "ok"})
        end
    end
end

function blank()
    luci.http.prepare_content("application/json")
    if get_method() == 'GET' then
        local result = read_serial(commands.blank.status)
        luci.http.write_json({["status"]= result:lower()})
    else
        local status = get_node()
        if commands.blank[status] then
            write_serial(commands.blank[status])
            luci.http.write_json({["status"]= "ok"})
        end
    end
end

function menu()
    luci.http.prepare_content("application/json")
    local status = get_node()
    if commands.blank[status] then
        write_serial(commands.menu[status])
        luci.http.write_json({["status"]= "ok"})
    end
end

function modelname()
    luci.http.prepare_content("application/json")
    local result = ''
    result = read_serial(commands.modelname.status)
    luci.http.write_json({["status"]= result:lower()})
end

function threedee()
    luci.http.prepare_content("application/json")
    if get_method() == 'GET' then
        local result = read_serial(commands["3d"].status)
        luci.http.write_json({["status"]= result})
    else
        local status = get_node()
        if commands.blank[status] then
            local result = "None"
            write_serial(commands["3d"][status])
            if status == "TB" then
                result = "Top-Bottom"
            elseif status == "SBS" then
                result = "Side-by-Side"
            elseif status == "OFF" then
                result = "None"
            end
            luci.http.write_json({["status"]= result})
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
