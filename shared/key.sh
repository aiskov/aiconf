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
                keytool -import -trustcacerts -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -alias ${alias_name} -file $3
            else
                keytool -import -trustcacerts -keystore $2 -noprompt -alias ${alias_name} -file $3
            fi
            ;;
        "download")
            echo -n | openssl s_client -connect ${2}:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${2}.crt
            ;;
        *)
            echo "Incorrect d command: $@"
            ;;
    esac
}