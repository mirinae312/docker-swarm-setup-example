#!/usr/bin/env bash

# create docker-machine
# - @param1 docker-machine name
create()
{
    local DOCKER_MACHINE_NAME=$1
    echo "create docker-machine : ${DOCKER_MACHINE_NAME} ..."

    # docker command
    docker-machine create \
        --driver xhyve \
        --xhyve-cpu-count "1" \
        --xhyve-disk-size "5000" \
        --xhyve-memory-size "1024" \
        ${DOCKER_MACHINE_NAME}

    echo "docker-machine(${DOCKER_MACHINE_NAME}) is created"
}

# remove docker-machine
# - @param1 docker-machine name
remove()
{
    local DOCKER_MACHINE_NAME=$1
    echo "remove docker-machine : ${DOCKER_MACHINE_NAME} ..."

    # docker command
    docker-machine rm -y ${DOCKER_MACHINE_NAME}

    echo "docker-machine(${DOCKER_MACHINE_NAME}) is removed"
}

# start docker-machine
# - @param1 docker-machine name
start()
{
    local DOCKER_MACHINE_NAME=$1
    echo "start docker-machine : ${DOCKER_MACHINE_NAME} ..."

    docker-machine start ${DOCKER_MACHINE_NAME}

    echo "docker-machine(${DOCKER_MACHINE_NAME}) is started"
}

# stop docker-machine
# - @param1 docker-machine name
stop()
{
    local DOCKER_MACHINE_NAME=$1
    echo "stop docker-machine : ${DOCKER_MACHINE_NAME} ..."

    docker-machine stop ${DOCKER_MACHINE_NAME}

    echo "docker-machine(${DOCKER_MACHINE_NAME}) is stopped"
}



# shell script command support
OPTION=${1}
case ${OPTION} in
    "create")
        if [ ! "${2}" ];then
            echo "ERROR(bad docker-machine name: ${2}) : required : j_docker_machine.sh create 'docker-machine node name'"
            exit 1
        fi
        create ${2}
    ;;
    "remove")
        if [ ! "${2}" ];then
            echo "ERROR(bad docker-machine name: ${2}) : required : j_docker_machine.sh remove 'docker-machine node name'"
            exit 1
        fi
        remove ${2}
    ;;
    "start")
        if [ ! "${2}" ];then
            echo "ERROR(bad docker-machine name: ${2}) : required : j_docker_machine.sh start 'docker-machine node name'"
            exit 1
        fi
        start ${2}
    ;;
    "stop")
        if [ ! "${2}" ];then
            echo "ERROR(bad docker-machine name: ${2}) : required : j_docker_machine.sh stop 'docker-machine node name'"
            exit 1
        fi
        stop ${2}
    ;;
    *)
        echo "ERROR: wrong sub command ( ${OPTION} )"
        exit 1
    ;;
esac