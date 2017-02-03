#!/bin/bash

function build_extension() {
    pushd amfext
        phpize
        ./configure --enable-debug --disable-all --enable-libxml --enable-simplexml --enable-dom --with-amf
        make
        make install
    popd
}

function run_tests() {
    export NO_INTERACTION=1
    export REPORT_EXIT_STATUS=1
    export TEST_PHP_EXECUTABLE=$(which php)

    pushd amfext
        php run-tests.php --show-diff -d extension=modules/amf.so -n ./tests/*.phpt
        retval=$?
    popd
    return $retval;
}

# Command line arguments
ACTION=$1

set -e

case $ACTION in
    before_script)
        # Build the extension
        build_extension
    ;;

    script)
        # Run tests
        set +e
        run_tests || exit 1
    ;;

    *)
        echo "Unknown action. Valid actions are: before_script and script"
        exit 1
    ;;
esac

