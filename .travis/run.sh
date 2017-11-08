#!/bin/bash

set -e
set -x

if [[ "${RUN_INTEGRATION_TESTS}" == "1" ]]; then
    sudo mkdir -p /etc/pykmip/certs
    cd /etc/pykmip/certs
    sudo openssl req -x509 -subj "/CN=test" -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
    cd -
    sudo cp ./.travis/pykmip.conf /etc/pykmip/pykmip.conf
    sudo cp ./.travis/server.conf /etc/pykmip/server.conf
    python -V
    python -m site
    pwd
#    python -c "from __future__ import print_function; import site; print(site.getsitepackages()[0])"
#    sudo python setup.py install
    source ~/.venv/bin/activate
    sudo python ./bin/run_server.py &
    tox -e integration -- --config client
else
    tox
fi

