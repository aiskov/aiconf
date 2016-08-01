#!/usr/bin/env bash

unset -f _aiconf
_aiconf() {
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'save reload update' -- "$cur" ) )

    return 0
}
complete -F _aiconf -o default aiconf

unset -f _to
_to() {
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'dev vm log' -- "$cur" ) )

    return 0
}
complete -F _to -o default to

unset -f _vm
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