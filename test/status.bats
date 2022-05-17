#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load helper

@test "display status" {
    run pyenv multiuser setup
    run pyenv multiuser status
}
