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
    echo "PYENV_ROOT: ${PYENV_ROOT}"
    SUMS=($(grep -lr '${PYENV_ROOT}/shims' "$PYENV_BASE"))
    run pyenv multiuser setup

    echo "BACKUP FILES: " $(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup")
    BACK_CNT=$(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup" | wc -l)
    
    echo "SUMS: ${#SUMS[@]} BACK COUNT: ${BACK_CNT}"
    assert [ "${#SUMS[@]}" = "${BACK_CNT}" ]

    # this check will need to be better as it only looks at the number of files between the backup and the source.
    # it would be better to ensure that the two sets of files are exactly the same; md5sum should be sufficient.
}
