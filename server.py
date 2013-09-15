#!/usr/bin/env python
from flask import Flask, request, jsonify, send_file
import serial
import re

DEVICE = '/dev/ttyATH0'

SPEED = 115200

COMMANDS = {
        "power": {"on": "POW=ON", "off": "POW=OFF", "status": "POW=?"},
        "blank": {"on": "BLANK=ON", "off": "BLANK=OFF", "status": "BLANK=?"},
        "modelname": {"status": "MODELNAME=?"},
        "menu": {
                    "on": "MENU=ON",
                    "off": "MENU=OFF",
                    "up": "UP",
                    "down": "DOWN",
                    "right": "RIGHT",
                    "left": "LEFT",
                    "enter": "ENTER"
                },
        "3d": {
                "status": "3D=?",
                "sbs": "3D=SBS",
                "tb": "3D=TB",
                "fs": "3D=FS",
                "off": "3D=OFF"
              }
}

app = Flask(__name__, static_url_path='')
ser = serial.Serial(DEVICE, SPEED, timeout=1)

def read_serial(command):
    """Send a command via serial and return the answer"""
    ser_command = "\r*%s#\r" % command
    ser.write(ser_command)
    out = ser.readlines()
    m = re.search("(\w+)=(\w+)", out[-1])
    answer = m.group(2)
    return answer

def write_serial(command):
    """Send a command via serial"""
    ser_command = "\r*%s#\r" % command
    ser.write(ser_command)

@app.route("/")
def index():
    return send_file("static/index.html")

@app.route('/power', methods=['GET'])
@app.route('/power/<status>', methods=['PUT'])
def power(status=None):
    if request.method == 'GET':
        answer = read_serial(COMMANDS["power"]["status"])
        return jsonify({"status": answer == "ON"})
    else:
        if status == 'on':
            write_serial(COMMANDS["power"]["on"])
            return jsonify({"status": "ok"})
        elif status == 'off':
            write_serial(COMMANDS["power"]["off"])
            return jsonify({"status": "ok"})

@app.route('/blank', methods=['GET'])
@app.route('/blank/<status>', methods=['PUT'])
def blank(status=None):
    if request.method == 'GET':
        answer = read_serial(COMMANDS["blank"]["status"])
        return jsonify({"status": answer == "ON"})
    else:
        if status == 'on':
            write_serial(COMMANDS["blank"]["on"])
            return jsonify({"status": "ok"})
        elif status == 'off':
            write_serial(COMMANDS["blank"]["off"])
            return jsonify({"status": "ok"})

@app.route('/menu/<action>', methods=['PUT'])
def menu(action=None):
    if action in COMMANDS["menu"]:
        write_serial(COMMANDS["menu"][action])
        return jsonify({"status": "ok"})

@app.route('/modelname', methods=['GET'])
def modelname(status=None):
    if request.method == 'GET':
        answer = read_serial(COMMANDS["modelname"]['status'])
        return jsonify({"status": answer.lower()})

@app.route('/3d', methods=['GET'])
@app.route('/3d/<status>', methods=['PUT'])
def threedee(status=None):
    if request.method == 'GET':
        answer = read_serial(COMMANDS["3d"]["status"])
        return jsonify({"status": answer})
    else:
        if status in COMMANDS["3d"]:
            write_serial(COMMANDS["3d"][status])
            if answer == "TB":
                result = "Top-Bottom"
            elif answer == "SBS":
                result = "Side-by-Side"
            elif answer == "OFF":
                result = "None"
            return jsonify({"status": result})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

ser.close()
