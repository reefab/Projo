from fabric.api import *

def projo():
    env.hosts = ['projo.local']
    env.user = "root"
    env.port = 22
    env.shell = '/bin/ash -c'

def build():
    local('grunt build')

def upload():
    put('static/', '/srv/projo/')
    put('server.py', '/srv/projo/', mirror_local_mode=True)

def restart_server():
    run('/etc/init.d/projo stop')
    run('/etc/init.d/projo start')

def deploy():
    build()
    upload()
    restart_server()

def package():
    build()
    version = prompt("Version number?")
    local('tar cfvzp projo-%s.tar.gz server.py *.md projo static' % version)
