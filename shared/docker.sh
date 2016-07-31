#!/usr/bin/env bash

# Work with docker
export DOCKER_HOST=unix:///var/run/docker.sock

unset -f d
d() {
    case "$1" in
        "ps")
            case $2 in
                "--names")
                    docker ps --format '{{.Names}}' ${@:3}
                    ;;
                "--short")
                    docker ps --format 'table {{.Image}}\t{{.Names}}\t{{.Status}}' ${@:3}
                    ;;
                "stopped")
                    docker ps -f "status=exited"
                    ;;
                *)
                    docker ps ${@:2}
                    ;;
            esac
            ;;
        "img")
            docker images ${@:2}
            ;;
        "rmi")
            if [ "$2" = "untagged" ]; then
                TARGETS="$(docker images | grep '"'"'^<none>'"'"' | awk '"'"'{print $3}'"'"')"

                if [ -z "$TARGETS" ]; then
                    echo "No $2 images found"
                else
                    docker rmi ${TARGETS}
                fi
            elif [ "$2" = "all" ]; then
                TARGETS="$(docker images -q)"

                if [ -z "$TARGETS" ]; then
                    echo "No images found"
                else
                    docker rmi ${TARGETS}
                fi
            else
                docker rmi ${@:2}
            fi
            ;;
        "pull")
            docker pull ${@:2}
            ;;
        "push")
            docker push ${@:2}
            ;;
        "build")
            docker build -t ${@:2}
            ;;
        "daemon")
            docker daemon ${@:2}
            ;;
        "attach")
            docker attach ${@:2}
            ;;
        "logs")
            docker log ${@:2}
            ;;
        "run")
            docker run -t -i --net=host ${@:2}
            ;;
        "stop")
            if [ "$2" = "all" ]; then
                TARGETS="$(docker ps -q)"

                if [ -z "$TARGETS" ]; then
                    echo "No active containers"
                else
                    docker stop ${TARGETS}
                fi
            else
                docker stop ${@:2}
            fi
            ;;
        "rm")
            if [ "$2" = "all" ]; then
                TARGETS="$(docker ps -a -q)"

                if [ -z "$TARGETS" ]; then
                    echo "No containers found"
                else
                    docker rm ${TARGETS}
                fi
            elif [ "$2" = "stopped" ]; then
                TARGETS="$(docker ps --filter "status=exited" -q)"

                if [ -z "$TARGETS" ]; then
                    echo "No containers found"
                else
                    docker rm ${TARGETS}
                fi
            else
                docker rm ${@:2}
            fi
            ;;
        "bash")
            docker exec -it $2 /bin/bash ${@:3}
            ;;
        "stats")
            TARGETS="$(d ps --names)"

            if [ -z "$TARGETS" ]; then
                echo "No active containers found"
            else
                if [ "$2" = "" ]; then
                    docker stats ${TARGETS}
                elif [[ $2 == --* ]]; then
                    docker stats ${TARGETS} $2
                else
                    docker stats ${@:2}
                fi
            fi
            ;;
        *)
            echo "Incorrect d command: $@"
            ;;
    esac
}
