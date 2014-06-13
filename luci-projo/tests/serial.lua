print("Serial Command Test")
local SERIAL_DEVICE = '/dev/ttyATH0'
local serial = io.open(SERIAL_DEVICE, 'rw')
require "nixio"

function write_serial(command)
    local ser_command = string.format("*%s#", command)
    print("Sending command to device")
    serial:write("\r")
    nixio.nanosleep(1)
    print(ser_command)
    serial:write(ser_command)
    nixio.nanosleep(1)
    serial:write("\r")
    while true do
      for line in io.lines("/dev/ttyATH0") do
        print(serial:read())
      end
    end
    --print("Reading reply")
    --while reply==nil do
    --    reply=serial:read()
    --    serial:flush()
    --end
    --print(reply)
    serial:close()
    print("done")
end

write_serial("POW=?")
