#!/usr/bin/env bash

# Work with docker
if [ $OSTYPE == "linux-gnu" ]; then
    echo "Docker host: ${DOCKER_HOST}"
    # export DOCKER_HOST=""
else
    export DOCKER_HOST=unix:///var/run/docker.sock
fi

unset -f d
d() {
    case "$1" in
        "help")
            echo "ps img rmi pull push build daemon attach logs run stop rm bash stats"
            ;;
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
        "volumes")
            case $2 in
                "--names")
                    docker volume ls --format '{{.Name}}' ${@:3}
                    ;;
                "--compose")
                    docker volume ls --format '{{.Name}}\t{{.Label "com.docker.compose.project"}}\t{{.Label "com.docker.compose.volume"}}' ${@:3}
                    ;;
                *)
                    docker volume ls ${@:2}
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
            docker logs ${@:2} 2>&1 | less
            ;;
        "inspect")
             docker inspect ${@:2} 2>&1 | less
            ;;
        "v-inspect")
             docker volume inspect ${@:2} 2>&1 | less
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
        "restart")
            docker restart ${@:2}
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
                echo "No active containers found."
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

unset -f _d
_d() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("ps" "img" "rmi" "pull" "push" "build" "daemon" "attach" "logs" "inspect" "run" "stop"
                       "rm" "bash" "stats" "restart" "volumes" "v-inspect")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    elif [ $COMP_CWORD -ge 2 ]; then
        case "$prev" in
            "ps")
                local options=("-a" "--all" "-f" "--filter" "--format" "--help" "-n" "--last" "-l" "--latest"
                               "--no-trunc" "-q" "--quiet" "-s" "--size --names --short stopped")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "volumes")
                local options=("--filter" "-f" "--format" "--quiet" "-q" "--names" "--compose")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;

            "img")
                local options=("-a" "--all" "--digests" "-f" "--filter" "--format" "--help" "--no-trunc" "-q" "--quiet")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "rmi")
                local options=("-f" "--force" "--help" "--no-prune" "untagged" "all")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "pull")
                local options=("-a" "--all-tags" "--disable-content-trust")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "push")
                local options=("--disable-content-trust")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "build")
                local options=("-f" "--file=" "--force-rm" "--no-cache" "--pull" "-q" "--quiet" "--rm" "-m" "--memory"
                               "--memory-swap" "-c" "--cpu-shares" "--cpuset-mems" "--cpuset-cpus" "--cgroup-parent"
                               "--ulimit")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "daemon")
                local options=("--api-cors-header" "-b" "--bridge" "--bip" "-D" "--debug" "--default-gateway"
                               "--default-gateway-v6" "--dns" "--dns-search" "--default-ulimit" "-e" "--exec-driver"
                               "--exec-opt" "--exec-root" "--fixed-cidr" "--fixed-cidr-v6" "-G" "--group" "-g" "--graph"
                               "-H" "--host" "-h" "--help" "--icc" "--insecure-registry" "--ip" "--ip-forward"
                               "--ip-masq" "--iptables" "--ipv6" "-l" "--log-level" "--label" "--log-driver" "--log-opt"
                               "--mtu" "-p" "--pidfile" "--registry-mirror" "-s" "--storage-driver" "--selinux-enabled"
                               "--storage-opt" "--tls" "--tlscacert" "--tlscert" "--tlskey" "--tlsverify"
                               "--userland-proxy")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "attach")
                local names=$(d ps --names | tr '\n' ' ')
                local options=("--no-stdin" "--sig-proxy")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "logs")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("--since" "-t" "--timestamps" "--tail")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "inspect")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("--format" "-f" "--size"  "-s" "--type")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "v-inspect")
                local names=$(d volumes --names | tr '\n' ' ')
                local options=("--format" "-f")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "run")
                local options=("-a" "--attach" "--add-host" "--blkio-weight" "-c" "--cpu-shares" "--cap-add"
                               "--cap-drop" "--cgroup-parent" "--cidfile" "--cpu-period" "--cpu-quota" "--cpuset-cpus"
                               "--cpuset-mems" "-d" "--detach" "--device" "--dns" "--dns-search" "-e" "--env"
                               "--entrypoint" "--env-file" "--expose" "--group-add" "-h" "--hostname" "--help" "-i"
                               "--interactive" "--ipc" "-l" "--label" "--label-file" "--link" "--log-driver" "--log-opt"
                               "--lxc-conf" "-m" "--memory" "--mac-address" "--memory-swap" "--memory-swappiness"
                               "--name" "--net" "--oom-kill-disable" "-P" "--publish-all" "-p" "--publish" "--pid"
                               "--privileged" "--read-only" "--restart" "--rm" "--security-opt" "--sig-proxy" "-t"
                               "--tty" "-u" "--user" "--ulimit" "--disable-content-trust" "--uts" "-v" "--volume"
                               "--volumes-from" "-w" "--workdir")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "stop")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("all")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "restart")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("--time" "-t")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "rm")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("-l" "--link" "-v" "--volumes" "all" "stopped")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "bash")
                local names=$(d ps --names | tr '\n' ' ')
                COMPREPLY=($(compgen -W '$names' -- "$cur"))
                ;;
            "stats")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("--help" "--no-stream")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            *)
                ;;
        esac
    fi

    return 0
}
complete -F _d -o default d
