unset PYENV_VERSION
unset PYENV_DIR

# Will be testing on a docker image with two pyenv setups
# CONTROL: /pyenv  TEST: /pyenv-test

flunk() {
    {
        if [ "$#" -eq 0 ]; then
            cat -
        else
            echo "$@"
        fi
    } | sed "s:${PYENV_TEST_DIR}:TEST_DIR:g" >&2
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
    if [ "$1" != "$2" ]; then
        {
            echo "expected: $1"
            echo "actual: $2"
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
