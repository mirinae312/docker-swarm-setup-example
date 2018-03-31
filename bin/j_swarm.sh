#!/usr/bin/env bash

# init swarm cluster
# - @param1 docker-machine name (swarm manager node name)
init()
{
    local DOCKER_MACHINE_NAME=$1
    local DOCKER_MACHINE_IP=$(docker-machine ip ${DOCKER_MACHINE_NAME})
    echo "init swarm from manager-node (${DOCKER_MACHINE_NAME}) ..."

    # docker command
    # --advertise-addr : manager node publish this addresss, and the other nodes in the swarm must be able to access the manager at the IP address.
    docker-machine ssh ${DOCKER_MACHINE_NAME} \
        "docker swarm init \
        --advertise-addr ${DOCKER_MACHINE_IP}"


    echo "swarm initialize from manager-node (${DOCKER_MACHINE_NAME}) ..."
}


# join manager replica into swarm
# - @param1 swarm node join type ('manager' or 'worker')
# - @param2 docker-machine name
# - @param3 docker-machine name (swarm leader(manager) node name of swarm)
join()
{
    local SWARM_NODE_JOIN_TYPE=$1
    local DOCKER_MACHINE_NAME=$2
    local DOCKER_MACHINE_NAME__SWARM_LEADER=$3
    echo "join ${SWARM_NODE_JOIN_TYPE}(${DOCKER_MACHINE_NAME}) into swarm(leader: ${DOCKER_MACHINE_NAME__SWARM_LEADER}) ..."


    # docker command
    docker-machine ssh ${DOCKER_MACHINE_NAME} $(_join_command ${DOCKER_MACHINE_NAME__SWARM_LEADER} ${SWARM_NODE_JOIN_TYPE})


    echo "joined ${SWARM_NODE_JOIN_TYPE}(${DOCKER_MACHINE_NAME}) into swarm(leader: ${DOCKER_MACHINE_NAME__SWARM_LEADER}) ..."
}

# get join command for swarm node type
# - @param1 docker-machine name (swarm manager node name of swarm cluster)
# - @param2 swarm node join type ('manager' or 'worker')
_join_command()
{
    local DOCKER_MACHINE_NAME__SWARM_LEADER=$1
    local SWARM_NODE_JOIN_TYPE=$2

    echo $(docker-machine ssh ${DOCKER_MACHINE_NAME__SWARM_LEADER} "docker swarm join-token ${SWARM_NODE_JOIN_TYPE}" | grep -E "(docker).*\:([0-9]+)" -o)
}


# leave from swarm
# - @param1 docker-machine name
leave()
{
    local DOCKER_MACHINE_NAME=$1
    docker-machine ssh ${DOCKER_MACHINE_NAME} "docker swarm leave"
}



# shell script command support
OPTION=${1}
case ${OPTION} in
    "init")
        if [ ! "${2}" ];then
            echo "ERROR : required : j_swarm.sh init 'docker-machine node name'"
            exit 1
        fi
        init ${2}
    ;;
    "join")
        if [ ! "${2}" ];then
            echo "ERROR(bad join type: ${2}) : required : j_swarm.sh join 'swarm-node join-type' 'docker-machine name of swarm-leader'"
            exit 1
        fi
        if [ ! "${3}" ];then
            echo "ERROR(bad worker docker-machine name: ${3}) : required : j_swarm.sh join 'swarm-node join-type' 'docker-machine node name' 'docker-machine node name of swarm-leader'"
            exit 1
        fi
        if [ ! "${4}" ];then
            echo "ERROR(bad leader(manager) docker-machine name: ${4}) : required : j_swarm.sh join 'swarm-node join-type' 'docker-machine node name' 'docker-machine node name of swarm-leader'"
            exit 1
        fi
        join ${2} ${3} ${4}
    ;;
    *)
        echo "ERROR: wrong command ( ${OPTION} )"
        exit 1
    ;;
    "leave")
        if [ ! "${2}" ];then
            echo "ERROR : required : j_swarm.sh leave 'docker-machine node name'"
            exit 1
        fi
        leave ${2}
    ;;
esac