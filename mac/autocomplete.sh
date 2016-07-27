#!/bin/bash

_aiconf()
{
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'save reload update' -- "$cur" ) )

    return 0
}

complete -F _aiconf -o default aiconf

_to()
{
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'dev vm log' -- "$cur" ) )

    return 0
}
complete -F _to -o default to

_d()
{
    local cur
    _get_comp_words_by_ref cur

    case $cur in
        "stop")
            echo $cur
            COMPREPLY=( $( compgen -W 'stop all' -- "$cur" ) )
            ;;
        *)
            COMPREPLY=( $( compgen -W 'ps img rmi pull push build daemon attach log run stop rm bash destroy stats' -- "$cur" ) )
            ;;
    esac


    return 0
}
complete -F _d -o default d