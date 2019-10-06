#!/usr/bin/env bash

export LOG_DIR="/var/log"

# Utils
do_times() {
    local i="0"

    while [ $i -lt ${2:-3} ]; do
        $1
        sleep ${3:-1}
        i=$[$i+1]
    done
}

unset -f containsElement
containsElement() {
  local e
  for e in "${2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

unset -f join
join() {
    local IFS="$1"
    shift
    echo "$*"
}

unset -f load_scripts
load_scripts() {
    cd $1

    for s in $(ls); do
        . ${s}
    done

    cd - &> /dev/null
}

unset -f all_dirs
all_dirs() {
    local target
    if [ "$1" = "" ]; then
        target="./"
    else
        target="$1/"
    fi

    local dirs=$(find ${target} -type d -maxdepth 1)
    echo "$dirs" | sed "s|^$target||g" | sed "s|^/||g" | sed '/^\s*$/d'
}

# Others
unset -f pc
pc() {
    str="$*"
    python -c "print(${str})"
}

unset -f github_download_last
github_download_last() {
    api="https://api.github.com/repos/${1}/releases/latest"
    url=$(curl -s "${api}" | grep browser_download_url | grep "${2-.zip}" | cut -d : -f 2,3 | tr -d '[:space:]' | tr -d '["]')
    wget "${url}" 
}

unset -f sudof
sudof() {
    FUNC=$(declare -f ${1})
    sudo bash -c "${FUNC}; ${1} ${@:2}; unset -f ${1}"
}

# Work with proc
alias is_runned="ps aux | grep -v grep | grep"
alias mem_top="ps wwaxm -o pid,%cpu,command | head -5"
alias cpu_top="ps wwaxr -o pid,%cpu,command | head -5"
alias ttop="top -R -F -s 10 -o rsize"
alias be_awake="caffeinate -u -t"

# Work with date
alias aid_week='date +%V'
alias aid_date='date "+%Y-%m-%d"'
alias aid_time='date "+%H:%M:%S"'
alias aid_date_time='date "+%Y-%m-%dT%H:%M:%S"'

# Work with files
alias search="find . -name"
alias rsearch="find . -regex"
