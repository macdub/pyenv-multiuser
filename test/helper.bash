unset PYENV_VERSION
unset PYENV_DIR

# Will be testing on a docker image with two pyenv setups
# CONTROL: /pyenv  TEST: /pyenv-test
#export PYENV_ROOT="/pyenv-test"
#export PYENV_BASE="/pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
HOME="/tmp/test_home"

teardown() {
    run pyenv multiuser restore
    if [ -e "$HOME/my_pyenv_shims" ]; then
        rm -r "$HOME/my_pyenv_shims"
    fi

    if [ -e "$HOME/.pyenv_local_shim" ];then
        rm -r "$HOME/.pyenv_local_shim"
    fi
}

flunk() {
    {
        if [ "$#" -eq 0 ]; then
            cat -
        else
            echo "$@"
        fi
    }
    return 1
}

assert_success() {
    if [ "$status" -ne 0 ]; then
        flunk "command failed with exit status $status"
    elif [ "$#" -gt 0 ]; then
        assert_output "$1"
    fi
}

assert_failure() {
    if [ "$status" -eq 0 ]; then
        flunk "expected failed exit status"
    elif [ "$#" -gt 0 ]; then
        assert_output "$1"
    fi
}

assert_equal() {
    if [ "$1" -ne "$2" ]; then
        {
            echo "expected: $1"
            echo "got: $2"
        } | flunk
    fi
}

assert_output() {
    local expected
    if [ $# -e 0 ]; then
        expected="$(cat -)"
    else
        expected="$1"
    fi
    assert_equal "$expected" "$output"
}

assert_line() {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        assert_equal "$2" "${lines[$1]}"
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" = "$1" ]; then
                return 0
            fi
        done
        flunk "expected line '$1'"
    fi
}

assert() {
    if ! "$@"; then
        flunk "failed: $@"
    fi
}

findfiles() {
    grep_opts=$1
    
    find ${PYENV_ROOT} -type f ! -name '*.md' ! -name '.git*' ! -path "${PYENV_ROOT}/.git/*" ! -path "${PYENV_ROOT}/.github/*" ! -path "${PYENV_ROOT}/test/*" ! -path "${PYENV_ROOT}/man/*" ! -path "${PYENV_ROOT}/plugins/pyenv-multiuser/*" -prune -exec grep $grep_opts '/shims' {} \;
}
