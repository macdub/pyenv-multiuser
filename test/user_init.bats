#!/usr/bin/env ./tests/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load helper

@test "init user default shims '~/.pyenv_local_shim'" {
    # assert that the default shim directory doesn't exist
    assert [[ ! -d "$HOME/.pyenv_local_shim" ]]

    # perform the init
    pyenv multiuser init

    # assert the directory was created
    assert [[ -d "$HOME/.pyenv_local_shim" ]]
}

@test "init user custom shims '~/my_pyenv_shims'" {
    # assert the custom directory doesn't exist
    assert [[ ! -d "$HOME/my_pyenv_shims" ]]

    # perform init with custom dir
    pyenv multiuser init "$HOME/my_pyenv_shims"

    # assert the custom directory was created
    assert [[ -d "$HOME/my_pyenv_shims" ]]
}
