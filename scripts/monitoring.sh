

echo PLAYERS_COUNT,CPU_USAGE,TOTAL_MEM,USED_MEM,FREE_MEM,DISK_USAGE,RX-OK,RX-ERR,RX-DRP,RX-OVR,TX-OK,TX-ERR,TX-DRP,TX-OVR,Flg
while true
do
    PLAYERS_COUNT=$(./SampPlayersCount.py)
    TOTAL_MEM=$(free -m | grep Mem | sed 's/ \+/\t/g' | cut -f2)
    USED_MEM=$(free -m | grep Mem | sed 's/ \+/\t/g' | cut -f3)
    FREE_MEM=$(free -m | grep Mem | sed 's/ \+/\t/g' | cut -f4)
    DISK_USAGE=$(df | grep ploop44294p1 |  sed 's/ \+/\t/g' | cut -f5)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    NETWORK_USAGE=$(netstat -i | grep venet0 |head -n 1 |  sed 's/ \+/,/g'|cut -d ',' -f3-)

    echo $PLAYERS_COUNT,$TOTAL_MEM,$USED_MEM,$FREE_MEM,$DISK_USAGE,$CPU_USAGE,$NETWORK_USAGE
    sleep 1 
done

