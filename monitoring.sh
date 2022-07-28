arch=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
usedRam=$(free -m | awk '$1 == "Mem:" {print $3}')
maxRam=$(free -m | awk '$1 == "Mem:" {print $2}')
perRam=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
usedDisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
maxDisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
perDisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
perLoad=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lastBoot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmNumbs=$(lsblk | grep "lvm" | wc -l)
infoLvm=$(if [ $lvmSayisi -eq 0 ]; then echo no; else echo yes; fi)
conT=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
activeUsers=$(users | wc -w)
ipAddr=$(hostname -I)
macAddr=$(ip link show | awk '$1 == "link/ether" {print $2}')
sudoNumbs=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "
	Architecture   $arch
	CPU physical   $pcpu
	vCPU           $vcpu
	Memory Usage   $usedRam/$maxRam MB ($perRam%)
	Disk Usage     $usedDisk/$maxDisk GB ($perDisk%)
	CPU load       $perLoad
	Last Boot      $lastBoot
	LVM use        $infoLvm
	Connexions TCP $conT ESTABLISHED
	User log       $activeUsers
	Network        IP:$ipAddr MAC:($macAddr)
	Sudo           $sudoNumbs cmd
"
