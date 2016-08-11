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
