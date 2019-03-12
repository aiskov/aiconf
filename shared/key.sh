#!/usr/bin/env bash

unset -f import_key
import_key() {
    if [ $OSTYPE == "linux-gnu" ]
    then
        DIRECTORY=/usr/local/share/ca-certificates/cacert.org

        [ ! -d "$DIRECTORY" ] && mkdir -p "${DIRECTORY}"
        
        wget -q -O /usr/local/share/ca-certificates/cacert.org/ "${1}"
        update-ca-certificates
    else 
        echo "Key import for mac not available." >&2
    fi
}

unset -f key
key() {
    LEGACY_PATH=${JAVA_HOME}/jre/lib/security/cacerts
    NEW_PATH=${JAVA_HOME}/lib/security/cacerts

    if [ -f "${LEGACY_PATH}" ]
    then
        JAVA_KEYSTORE_PATH="${LEGACY_PATH}"
    else 
        JAVA_KEYSTORE_PATH="${NEW_PATH}"
    fi

    case "$1" in
        "generate")
            if [ "$2" == "key" ]; then
                openssl req -newkey rsa:2048 -nodes -keyout $3
            elif [ "$2" == "cert" ]; then
                openssl req -key $3 -new -out $4
            fi
            ;;
        "add")
            if [ -n "$4" ]; then
                local alias_name=${4}
            else
                local alias_name=$(basename /var/log/daily.out)
            fi

            if [ "$2" == "java" ]
            then
                sudo keytool -import -trustcacerts -keystore ${JAVA_KEYSTORE_PATH} -noprompt -alias ${alias_name} -file $3
            else
                keytool -import -trustcacerts -keystore $2 -noprompt -alias ${alias_name} -file $3
            fi
            ;;
        "remove")
            if [ "$2" == "java" ]; then
                sudo keytool -delete -keystore ${JAVA_KEYSTORE_PATH} -noprompt -alias $3

            else
                keytool -delete -keystore $2 -noprompt -alias $3
            fi
            ;;
        "list")
            if [ "$2" == "java" ]; then
                sudo keytool -list ${@:3} -keystore ${JAVA_KEYSTORE_PATH}
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
        local options=("add" "download" "verify" "remove" "list" "generate")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    fi

    return 0
}
complete -F _key -o default key
