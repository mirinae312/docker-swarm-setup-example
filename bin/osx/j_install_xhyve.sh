#!/usr/bin/env bash

# install xhyve driver
install_xhyve()
{
    brew install xhyve docker-machine-driver-xhyve

    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
}


install_xhyve