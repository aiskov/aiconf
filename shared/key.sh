#!/usr/bin/env bash

unset -f key
key() {
    case "$1" in
        "add")
            if [ -n "$4" ]; then
                local alias_name=${4}
            else
                local alias_name=$(basename /var/log/daily.out)
            fi

            if [ "$2" == "java" ]; then
                sudo keytool -import -trustcacerts -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -alias ${alias_name} -file $3
            else
                keytool -import -trustcacerts -keystore $2 -noprompt -alias ${alias_name} -file $3
            fi
            ;;
        "remove")
            if [ "$2" == "java" ]; then
                sudo keytool -delete -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -alias $3

            else
                keytool -delete -keystore $2 -noprompt -alias $3
            fi
            ;;
        "list")
            if [ "$2" == "java" ]; then
                sudo keytool -list -v -keystore ${JAVA_HOME}/jre/lib/security/cacerts
            else
                keytool -list -v -keystore $3
            fi
            ;;
        "verify")
            openssl x509 -in $2 -text
            ;;
        "download")
            echo -n | openssl s_client -connect ${2}:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${2}.crt
            ;;
        *)
            echo "Incorrect d command: $@"
            ;;
    esac
}

_key() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("add" "download" "verify" "remove" "list")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    fi

    return 0
}
complete -F _key -o default key

