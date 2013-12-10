require "nixio.util"
local nixio = require "nixio"

local host = "192.168.1.3"
local port = 2323

local commands = {
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


module("luci.controller.projo.rest", package.seeall)

function read_serial(command)
    local sock, code, msg = nixio.connect(host, port)
    if not sock then
        return nil, code, msg
    end
    ser_command = string.format("\r*%s#\r", command)
    sock:sendall(ser_command)

    local linesrc = sock:linesource()
    local line, code, error = linesrc()

    line = linesrc()
    local key, value = line:match("(%w+)=(%w+)")
    sock:close()
end

function write_serial(command)
    local sock, code, msg = nixio.connect(host, port)
    if not sock then
        return nil, code, msg
    end
    ser_command = string.format("\r*%s#\r", command)
    sock:sendall(ser_command)
    sock:close()
end

function index()
    entry({"projo", "power"}, call("power_status")).dependent=false
end

function power_status()
    read_serial(command.power.status)
    luci.http.prepare_content("application/json")
    luci.http.write_json({["status"]= true})
end
