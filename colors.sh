for m in {0..7};do
for n in {0..7};do
echo -e "\033[3${n};4${m}m \\\033[3${n};4${m}m \033[0;0m 
done
done
