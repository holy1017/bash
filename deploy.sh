t_lst="deploy.lst"
t_path="$(cd "$(dirname "$0")" && pwd)/"

echo "list filw : $t_path$t_lst"

while read line ; do
  echo $line

  #
  rex="T *$"
  if [[ $line =~ ^#.* ]] || [[ $Line =~ $rgx ]] ; then continue ; fi

  arr=($line);
  nc -zw1 ${arr[3]} 22 ;
  if [ $? -eq 0 ] ;
  then
    echo ""
    sftp ${arr[2]}@${arr[3]} << EOF 2> /dev/null
mkdir $t_path
lcd $t_path
cd $t_path
put *.*
chmod 775 *.sh
EOF
  else
    echo "FAIL"
  fi

done < $t_path$t_lst

