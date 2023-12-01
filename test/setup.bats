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
    SUMS=($(grep -lr '\/shims' "${PYENV_BASE}/libexec"))
    run pyenv multiuser setup

    echo "BACKUP FILES: " $(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup")
    BACK_CNT=$(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup" | wc -l)
    
    echo "SUMS: ${#SUMS[@]} BACK COUNT: ${BACK_CNT}"
    assert [ "${#SUMS[@]}" = "${BACK_CNT}" ]
}

@test "check all shim locations replaced" {
    EXPECTED=($(grep -r '\/shims' "${PYENV_ROOT}/libexec" | wc -l))
    printf 'Expect to make %d line changes\n' "${EXPECTED}"

    assert [ "${EXPECTED}" -gt 0 ]

    echo "Running setup"
    run pyenv multiuser setup

    echo "Checking remaining count"
    FOUND=($(grep -r '\/shims' "${PYENV_ROOT}/libexec" | wc -l))

    assert_equal "0" "${FOUND}"
}

@test "verify backup files" {
    run pyenv multiuser setup
    SUM=($(find "${PYENV_BASE}/libexec" -type f -exec grep -Hl '/shims' {} \; | xargs md5sum))
    ALT=($(find "${PYENV_ROOT}/plugins/pyenv-multiuser/backup" -type f -not -path '*/\.*' | xargs md5sum))

    assert_equal ${#SUM[@]} ${#ALT[@]}

    echo '----- BASE FILES -----'
    printf '%s\n' "${SUM[@]}"

    echo '----- BACKUPS -----'
    printf '%s\n' "${ALT[@]}"
    echo

    itr=0
    while [ $itr -lt ${#ALT[@]} ]
    do
        echo "Checking BASE: ${SUM[$i]}"
        assert_success `[[ "${ALT[@]}" =~ "${SUM[$i]}" ]]`
        itr=$(( $itr + 2 ))
    done
}
