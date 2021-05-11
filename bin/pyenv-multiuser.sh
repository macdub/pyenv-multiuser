#! /usr/bin/env bash

set -e
[ -n "$PYENV_DEBUG" ] && set -x

if [ -z "$PYENV_ROOT" ]; then
    PYENV_ROOT="${HOME}/.pyenv"
fi

ALTER_FILES=$(grep -lR '${PYENV_ROOT}/shims' $PYENV_ROOT)

backup_files() {
    for filename in ${ALTER_FILES[@]}; do
        backup="$(echo $filename | sed 's/\//__/g')"
        echo "Backing up $filename -> $backup"
        cp $filename "./backups/$backup"
    done
}

restore_files() {
    for filename in $(ls ./backups/); do
        restore=$(echo $filename | sed 's/__/\//g')
        echo "Restoring $filename -> $restore"
        cp $filename $restore
    done
}

alter_files() {
    for filename in ${ALTER_FILES[@]}; do
        echo "Altering $filename"
        sed 's/${PYENV_ROOT}\/shims/${PYENV_LOCAL_SHIM}/g'
    done
}

clean_backups() {
    rm ./backups/*
}

update_multiuser() {
    STATUS=0
    restore_files()
    clean_backups()
    pyenv update
    STATUS="$?"

    if [ "$STATUS" != "0" ]; then
        return $STATUS
    fi

    ALTER_FILES=$(grep -lR '${PYENV_ROOT}/shims' $PYENV_ROOT)
    backup_files()
    alter_files()
}

init_multiuser() {
    backup_files()
    alter_files()
}

setup_shim_dir() {
    if [ -e "$PYENV_LOCAL_SHIM" ]; then
        echo "Directory '$PYENV_LOCAL_SHIM' does not exist. Would you like to create it now? [Y/n]"
        read YN
        YN=${YN:-y}

        case "$YN" in
            y | Y)
                mkdir $PYENV_LOCAL_SHIM
                ;;
            *)
                echo "You will need to create '$PYENV_LOCAL_SHIM' manually"
                ;;
        esac
    fi
}

user_init() {
    echo "# Add the following to your profile"

    if [ -z "$PYENV_LOCAL_SHIM" ]; then
        echo "PYENV_LOCAL_SHIM not set. Would you like to use the default setting ($HOME/.pyenv_local_shim)? [Y/n]"
        read USE_DEFAULT
        USE_DEFAULT=${USE_DEFAULT:-y}

        case "$USE_DEFAULT" in
            y | Y)
                echo "export PYENV_LOCAL_SHIM=$HOME/.pyenv_local_shim"
                setup_shim_dir()
                ;;

            *)
                echo "# replace '<PATH>' with your desired location path for your local shim directory"
                echo "export PYENV_LOCAL_SHIM=<PATH>"
        esac
    fi
}

STATUS=0
shopt -s nullglob
PARAM=$1

case "$PARAM" in
    baseinit)
        init_multiuser()
        ;;

    init)
        user_init()
        ;;

    update)
        update_multiuser()
        STATUS="$?"
        ;;

    *)
        echo "USAGE: pyenv multiuser [option]"
        echo "  OPTIONS:"
        echo "      baseinit     : used initialize the multiuser setup. Should only need done once per install"
        echo "      init         : initialize the shim path at the individual user level"
        echo "      update       : perform an update of pyenv accounting for the multiuser setup"
        ;;
esac

shopt -u nullglob
exit "$STATUS"
