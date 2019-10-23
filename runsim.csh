#!/bin/bash
echo "Regression started"
args=("$@")
arg_count=${#args[@]}
i=0
run_list=""
iter=2;
priority=0
delay=0
cur_log="temp.log"
report_log="report.log"
while [ $i -lt $arg_count ]
        do
        case ${args[$i]} in
                -f)
                       run_list=${args[$i+1]};;
                -i)
                       iter=${args[$i+1]};;
								-d)
                       delay=${args[$i+1]};;
								-p)
                       prob=${args[$i+1]};;
                *)
                        exit 1;;
        esac
    i=`expr $i + 2`
done
echo "Run list file = $run_list Iter count $iter"

# Read the file in parameter and fill the array named "array"
getArray() {
    test_list_arr=() # Create array
    while IFS= read -r line # Read a line
    do
        test_list_arr+=("$line") # Append line to the array
    done < "$1"
}

getArray $run_list
echo "--------------------">$report_log
echo "Regression Result ..">$report_log
echo "--------------------">$report_log
# Print the file (print each element of the array)
result="Failed"
err_str=""
err_str_c=0
for cur_test in "${test_list_arr[@]}"
do
    echo "Running test : $cur_test"
  if [ $cur_test == "RANDOM_STALL_TEST" ]; then
	make runc t=$cur_test i=$iter d=$delay p=$prob >$cur_log
  elif [ $cur_test == "RANDOM_TEST_WITH_DELAY" ]; then
	make runc t=$cur_test i=$iter d=$delay p=0 >$cur_log
	else
	make runc t=$cur_test i=$iter d=0 p=0 >$cur_log
  fi
	err_str=$(grep -r -e  "ERROR :" $cur_log) 
	if [ $err_str_c -eq 0 ];then
		result="Passed"
	fi	
	echo "$result	: $cur_test	">>$report_log
done
echo "--------------------">>$report_log
getArray $report_log
for line_str in "${test_list_arr[@]}"
do
    echo "$line_str"
done
rm -rf $cur_log
rm -rf $report_log
