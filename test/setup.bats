#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load helper

@test "setup multiuser environment" {
    assert [ ! -e "${PYENV_ROOT}/plugins/pyenv-multiuser/setup.true" ]
    run pyenv multiuser setup
    assert [ -e "${PYENV_ROOT}/plugins/pyenv-multiuser/setup.true" ]
}

@test "check that the setup created file backups" {
    SUMS=($(grep -lr '${PYENV_ROOT}/shims' "$PYENV_BASE"))
    run pyenv multiuser setup

    echo "BACKUP FILES: " $(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup")
    BACK_CNT=$(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup" | wc -l)
    
    echo "SUMS: ${#SUMS[@]} BACK COUNT: ${BACK_CNT}"
    assert [ "${#SUMS[@]}" = "${BACK_CNT}" ]
}

@test "verify backup files" {
    run pyenv multiuser setup
    SUM=($(grep -lr '${PYENV_ROOT}/shims' "$PYENV_BASE" | xargs md5sum))
    ALT=($(find "${PYENV_ROOT}/plugins/pyenv-multiuser/backup" -type f -not -path '*/\.*' | xargs md5sum))

    assert [ ${#SUM[@]} = ${#ALT[@]} ]

    itr=0
    while [ $itr -lt ${#ALT[@]} ]
    do
        echo "Checking BASE: ${SUM[$i]} BACKUP: ${ALT[$i]} FILE: ${SUM[$(( $i + 1 ))]}"
        assert [ ${SUM[$i]} = ${ALT[$i]} ]
        itr=$(( $itr + 2 ))
    done
}