#!/usr/bin/env bash

unset -f c
c() {
    case "$1" in
        "rsa-encrypt")
            openssl rsautl -in $2 -encrypt -pubin -inkey $3 -out $4
            ;;
        "rsa-encrypt")
            openssl rsautl -in $2 -decrypt -inkey $3 -out $4
            ;;
        *)
            echo "Incorrect aiconf command: $@"
            ;;
    esac
}

