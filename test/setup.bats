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
    FILES=($(findfiles "-Hl"))
    COUNT="${#FILES[@]}"
    run pyenv multiuser setup

    echo "FOUND FILES: " ${FILES[@]}
    echo "BACKUP FILES: " $(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup")
    BACK_CNT=$(ls "${PYENV_ROOT}/plugins/pyenv-multiuser/backup" | wc -l)
    
    echo "COUNT: ${COUNT} BACK COUNT: ${BACK_CNT}"
    assert [ "${COUNT}" = "${BACK_CNT}" ]
}

#@test "check all shim locations replaced" {
#    EXPECTED=$(findfiles "-H" | wc -l)
#    echo "Expect to make ${EXPECTED} line changes"
#
#    assert [ "${EXPECTED}" -gt 0 ]
#
#    echo "Running setup"
#    run pyenv multiuser setup
#    echo $output
#
#    echo "Checking status"
#    run pyenv multiuser status
#    echo $output
#
#    echo "Checking remaining count"
#    findfiles "-H"
#    FOUND=$(findfiles "-H" | wc -l)
#
#    assert_equal "0" "${FOUND}"
#}

@test "verify backup files" {
    run pyenv multiuser setup
    SUM=($(findfiles "-Hl" | xargs md5sum))
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
