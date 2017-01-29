#/bin/bash

RC=0
for test_file in `ls tests/*.test`; do
    msg=$(test_executor/6502_tester portal.nes symbols.txt $test_file 2>&1 >/dev/null)
    if [[ $? -eq 0 ]]; then
       echo -e "  \e[32m[PASS]\e[0m    $(basename $test_file .test)"
    else
       echo -e "  \e[31m[FAIL]\e[0m    $(basename $test_file .test)"
       while read -r line; do
               echo "                $line"
           done <<< "$msg"
       RC=1
    fi
done
exit $RC
