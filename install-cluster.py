#!/usr/bin/env python

import json
import sys
import os
import urlparse
import subprocess
import requests

# Original Script
'''
: ${AMBARI_HOST:=$AMBARISERVER_PORT_8080_TCP_ADDR}
: ${BLUEPRINT:=single-node-hdfs-yarn}

echo AMBARI_HOST=${AMBARI_HOST:? ambari server address is mandatory, fallback is a linked containers exposed 8080}

./wait-for-host-number.sh

java -jar ambari-shell.jar --ambari.host=$AMBARI_HOST << EOF
blueprint defaults
cluster build --blueprint $BLUEPRINT
cluster autoAssign
cluster create --exitOnFinish true
EOF
'''

AMBARI_HOST = os.getenv('AMBARISERVER_PORT_8080_TCP_ADDR')
BLUEPRINT_URL = os.getenv('BLUEPRINT', 'https://gist.githubusercontent.com/tfhartmann/fb200312dcd6816ea2dd/raw/ae686e2e8ad373896f1befd94d69ba2b2e7534b2/single-node-hdfs-yarn-thtest.json')

BP = requests.get(BLUEPRINT_URL).json()
BLUEPRINT_NAME =  BP['Blueprints']['blueprint_name']

subprocess.call( ['/tmp/wait-for-host-number.sh'])

if bool(urlparse.urlparse(BLUEPRINT_URL).netloc):
    # If URL run the URL installer 
    print AMBARI_HOST
    os.putenv('BLUEPRINT_URL', BLUEPRINT_URL)
    os.putenv('BLUEPRINT_NAME', BLUEPRINT_NAME)
    subprocess.call( ['/tmp/install-cluster-url.sh'])
    #subprocess.call( ['java', '-jar', 'ambari-shell.jar', '--cmdfile=/tmp/shell_cmds.txt', "--ambari.host="+AMBARI_HOST ])
else:
    # Run the normal install script
    print 'File: ', BLUEPRINT_URL
    subprocess.call( ['/tmp/install-cluster.sh'])

print AMBARI_HOST
