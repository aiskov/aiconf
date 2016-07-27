#!/bin/bash

_aiconf() {
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'save reload update' -- "$cur" ) )

    return 0
}
complete -F _aiconf -o default aiconf

_to() {
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'dev vm log' -- "$cur" ) )

    return 0
}
complete -F _to -o default to

_d() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("ps" "img" "rmi" "pull" "push" "build" "daemon" "attach" "log" "run" "stop"
                       "rm" "bash" "destroy" "stats")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    elif [ $COMP_CWORD -ge 2 ]; then
        case "$prev" in
            "ps")
                local options=("-a" "--all" "-f" "--filter" "--format" "--help" "-n" "--last" "-l" "--latest"
                               "--no-trunc" "-q" "--quiet" "-s" "--size --names stopped")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "img")
                local options=("-a" "--all" "--digests" "-f" "--filter" "--format" "--help" "--no-trunc" "-q" "--quiet")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
                ;;
            "rmi")
                local options=("-f" "--force" "--help" "--no-prune" "untagged")
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
                local options=("-f" "--follow" "--since" "-t" "--timestamps" "--tail")
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
            "rm")
                local names=$(d ps --names -a | tr '\n' ' ')
                local options=("-f" "--force" "-l" "--link" "-v" "--volumes" "all")
                options=$(join ' ' ${options[@]})
                COMPREPLY=($(compgen -W '$names $options' -- "$cur"))
                ;;
            "bash")
                local names=$(d ps --names -a | tr '\n' ' ')
                COMPREPLY=($(compgen -W '$options' -- "$cur"))
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

_vm() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("up" "down" "reload" "rebuild" "status")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    else
        local dirs=$(all_dirs | tr '\n' ' ')
        COMPREPLY=($(compgen -W '$dirs' -- "$cur"))
    fi

    return 0
}
complete -F _vm -o default vm
complete -F _vm -o default mongo
complete -F _vm -o default maria
complete -F _vm -o default mysql