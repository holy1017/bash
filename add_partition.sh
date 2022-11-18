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
  if [[ "$2" =~ "FF" ]]||[[ "$2" =~ "US" ]]
  then
   return
  fi
  maxv="to_date(replace(max(high_value),'''',''),'$2')"
 fi

 check=true
 while $check ; do
 now=$(edb-psql -t -csv -c "
select $maxv
from
where table_name=upper('$1')
")
 if [-z "$now" ]; then
  break
 fi
 next=$(date -d"$now KST +1 month" +%F %T")
 nexts=$(date -d"$now KST +1 month" +%s")
 if (( $maxs > $nexts )) ; then
  pt_nm=$(date -d"$now" +"%Y%m")
  if [ -z "$2" ] ;  then
   pt_vl="'$next'"
  else
   pt_vl="to_char('$next'::timestamp,'$2')"
  fi
  ddl=$(eval echo $3)
  deb-psql -d tomas -U tomas -p 5444 -t -c "
alter table $1 add partition pt_$pt_nm values less than ($pt_lv);
$ddl
;"
 else
  check=false
 echo "END"
 fi
 done
}

add_partition "table_name" "" "
add table \${1}_pt\$pt_nm add unique \(key\) ;
"

add_partition "table_name" "YYMMDD" "
add table \${1}_pt\$pt_nm add unique \(key\) ;
"
