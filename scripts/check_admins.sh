
check_admin()
{
    playername=$1
    adminname=$2
    adminlevel=$3
    onduty_goto=$(grep -i ":goto " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_goto=$(grep -i ":goto " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_sendto=$(grep -i ":sendto " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_sendto=$(grep -i ":sendto " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_aduty=$(grep -i ":aduty " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_aduty=$(grep -i ":aduty " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_revive=$(grep -i ":revive " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_revive=$(grep -i ":revive " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_givegun=$(grep -i ":givegun " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_givegun=$(grep -i ":givegun " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_givemoney=$(grep -i ":givemoney " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_givemoney=$(grep -i ":givemoney " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_veh=$(grep -i ":veh " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_veh=$(grep -i ":veh " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_warn=$(grep -i ":warn " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_warn=$(grep -i ":warn " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_ar=$(grep -i ":ar " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_ar=$(grep -i ":ar " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_dm=$(grep -i ":dm " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_dm=$(grep -i ":dm " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_ban=$(grep -i ":ban " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_ban=$(grep -i ":ban " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_nrn=$(grep -i ":nrn " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_nrn=$(grep -i ":nrn " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_flag=$(grep -i ":flag " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_flag=$(grep -i ":flag " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_removeflag=$(grep -i ":removeflag " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_removeflag=$(grep -i ":removeflag " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_event=$(grep -i ":event " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_event=$(grep -i ":event " server_log.txt | grep -i "\[$playername\]" | wc -l)
    onduty_kick=$(grep -i ":kick " server_log.txt | grep -i "\[$adminname\]" | wc -l)
    offduty_kick=$(grep -i ":kick " server_log.txt | grep -i "\[$playername\]" | wc -l)
    echo ${playername},${adminname},${adminlevel},${onduty_goto},${offduty_goto},${onduty_sendto},${offduty_sendto},${onduty_aduty},${offduty_aduty},${onduty_revive},${offduty_revive},${onduty_givegun},${offduty_givegun},${onduty_givemoney},${offduty_givemoney},${onduty_veh},${offduty_veh},${onduty_warn},${offduty_warn},${onduty_ar},${offduty_ar},${onduty_dm},${offduty_dm},${onduty_ban},${offduty_ban},${onduty_nrn},${offduty_nrn},${onduty_flag},${offduty_flag},${onduty_removeflag},${offduty_removeflag},${onduty_event},${offduty_event},${onduty_kick},${offduty_kick}
}

mysql_database=$( grep mysql_database scriptfiles/server.cfg | cut -f2 -d= )
mysql_hostname=$( grep mysql_hostname scriptfiles/server.cfg | cut -f2 -d= )
mysql_username=$( grep mysql_username scriptfiles/server.cfg | cut -f2 -d= )
mysql_password=$( grep mysql_password scriptfiles/server.cfg | cut -f2 -d= )
ADMINS=($(echo "select username,adminname,adminlevel from users where adminlevel>0 and uid>10;" | mysql -h $mysql_hostname -u $mysql_username -p$mysql_password -Bs --database=$mysql_database ))
unset mysql_password
unset mysql_username
unset mysql_hostname
unset mysql_database
echo playername,adminname,adminlevel,onduty goto,offduty goto,onduty sendto,offduty sendto,onduty aduty,offduty aduty,onduty revive,offduty revive,onduty givegun,offduty givegun,onduty givemoney,offduty givemoney,onduty veh,offduty veh,onduty warn,offduty warn,onduty ar,offduty ar,onduty dm,offduty dm,onduty ban,offduty ban,onduty nrn,offduty nrn,onduty flag,offduty flag,onduty removeflag,offduty removeflag,onduty event,offduty event,onduty kick,offduty kick
for i in $(seq 0 1 $((${#ADMINS[@]}/3-1)) ) ; do
    check_admin ${ADMINS[$i*3+0]} ${ADMINS[$i*3+1]} ${ADMINS[$i*3+2]} 
done


