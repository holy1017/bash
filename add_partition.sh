echo "$(date "+%F %T") start | tee -a $0.log

echo "\$1 : $1" | tee -a $0.log

if [ -z "$1" ] ; then
 max=${date -d"+ 1 year 1 month" +"%F %T"}
 maxs=${date -d"+ 1 year 1 month" +"%s"}
else
 max=${date -d"$1 KST + 1 year 1 month" +"%F %T"}
 maxs=${date -d"$1 KST + 1 year 1 month" +"%s"}
fi

function add_partition () {
 if [ -z "$2" ] ; then
  maxv="replace(max(high_value),'''','')"
 else
  maxv="to_date(replace(max(high_value),'''',''),'$2')"
 fi

 check=true
 while $check ; do
 
 done
}

add_partition "table_name" "" "
add index ~~~
"

add_partition "table_name" "YYMMDD" "
add index ~~~
"
