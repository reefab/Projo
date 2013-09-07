from flask import Flask, request, jsonify
import serial
import re
app = Flask(__name__)

DEVICE = '/dev/ttyATH0'

SPEED = 115200

COMMANDS = {
        "power": {"on": "POW=ON", "off": "POW=OFF", "status": "POW=?"},
        "blank": {"on": "BLANK=ON", "off": "BLANK=OFF", "status": "BLANK=?"},
        "menu":  {"on": "MENU=ON", "off": "MENU=OFF"},
        "model": {"status": "MODELNAME=?"},
        "up": "UP",
        "down": "DOWN",
        "right": "RIGHT",
        "left": "LEFT",
        "enter": "ENTER"
}

ser = serial.Serial(DEVICE, SPEED, timeout=1)

def read_serial(command):
    """Send a command via serial and return the answer"""
    ser_command = "\r*%s#\r" % command
    app.logger.debug(ser_command)
    ser.write(ser_command)
    out = ser.readlines()
    app.logger.debug(out)
    m = re.search("(\w+)=(\w+)", out[-1])
    answer = m.group(2)
    return answer

def write_serial(command):
    """Send a command via serial"""
    ser_command = "\r*%s#\r" % command
    app.logger.debug(ser_command)
    ser.write(ser_command)

@app.route('/power', methods=['GET'])
@app.route('/power/<status>', methods=['PUT'])
def power(status=None):
    if request.method == 'GET':
        answer = read_serial(COMMANDS["power"]["status"])
        return jsonify({"status": answer.lower()})
    else:
        if status == 'on':
            write_serial(COMMANDS["power"]["on"])
        elif status == 'off':
            write_serial(COMMANDS["power"]["off"])

@app.route('/blank', methods=['GET'])
@app.route('/blank/<status>', methods=['PUT'])
def blank(status=None):
    if request.method == 'GET':
        answer = read_serial(COMMANDS["blank"]["status"])
        return jsonify({"status": answer.lower()})
    else:
        if status == 'on':
            write_serial(COMMANDS["blank"]["on"])
        elif status == 'off':
            write_serial(COMMANDS["blank"]["off"])

if __name__ == "__main__":
    app.run(host='0.0.0.0')

ser.close()
