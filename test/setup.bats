#!/usr/bin/env ./tests/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load helper

@test "create setup.true file" {
    assert [ ! -e "${PYENV_ROOT}/plugins/pyenv-multiuser/setup.true" ]
    pyenv multiuser setup
    assert [ -e "${PYENV_ROOT}/plugins/pyenv-multiuser/setup.true" ]
}

@test "check backed up files are good" {
    SUMS=($(grep -lr '${PYENV_ROOT}/shims' "$PYENV_ROOT"))
    pyenv multiuser setup
    ALTER_FILES=($(grep -lr '${PYENV_ROOT}/shims' "$PYENV_ROOT/plugins/pyenv-multiuser/backup"))  # this should pull the files from the backup folder
    
    assert [[ "${#SUMS]}" = "${#ALTER_FILES[@]}" ]]

    # this check will need to be better as it only looks at the number of files between the backup and the source.
    # it would be better to ensure that the two sets of files are exactly the same; md5sum should be sufficient.
}
