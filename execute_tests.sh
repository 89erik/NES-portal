#/bin/bash

for test_file in `ls tests/*.test`; do
   test_executor/6502_tester portal.nes symbols.txt $test_file  > /dev/null
   if [[ $? -eq 0 ]]; then
       echo -e "  \e[32m[PASS]\e[0m    $(basename $test_file .test)"
   else
       echo -e "  \e[31m[FAIL]\e[0m    $(basename $test_file .test)"
   fi

done
