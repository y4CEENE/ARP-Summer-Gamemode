import os
from os import listdir
from os.path import isfile, join

location = "scriptfiles/users/"
users = [f for f in listdir(location) if isfile(join(location, f))]

def GetParamValue(line):
    return line[line.index('=')+1:].rstrip("\n")

oldparams = ['Key','Level','AdminLevel','AdminName','Health','Armor','UpgradePoints','IP','Sex','Age','Skin','SPos_x','SPos_y','SPos_z','SPos_r','Int','VirtualWorld','PhoneNr','Faction','Rank','Cash','Bank','Crimes','Arrested','WantedLevel','Pot','Crack','Materials','Gun0','Gun1','Gun2','Gun3','Gun4','Gun5','Gun6','Gun7','Gun8','Gun9','Gun10','Gun11','Paycheck','FishSkill','BoxSkill','ArmsSkill','LawSkill','DetSkill','SmugglerSkill','SexSkill','TruckSkill','CarSkill','ForkliftSkill','DrugsSkill']
newparams = ['password' ,'level' ,'adminlevel' ,'adminname' ,'health' ,'armor' ,'upgradepoints' ,'ip' ,'gender' ,'age' ,'skin' ,'pos_x' ,'pos_y' ,'pos_z' ,'pos_a' ,'interior' ,'world' ,'phone' ,'faction' ,'factionrank' ,'cash' ,'bank' ,'crimes' ,'arrested' ,'wantedlevel' ,'weed' ,'cocaine' ,'materials' ,'weapon_1' ,'weapon_2' ,'weapon_3' ,'weapon_4' ,'weapon_5' ,'weapon_6' ,'weapon_7' ,'weapon_8' ,'weapon_9' ,'weapon_10' ,'weapon_11' ,'weapon_12' ,'paycheck' ,'fishingskill' ,'guardskill' ,'weaponskill' ,'lawyerskill' ,'detectiveskill' ,'smugglerskill' ,'hookerskill' ,'truckerskill' ,'carjackerskill' ,'forkliftskill' ,'drugdealerskill']


oldcarparams = []
newcarparams = []
for user in users:
    filename = location + user
    username = os.path.splitext(user)[0]
    paramnames = []
    lines = open(filename, 'r').readlines()
    ownerid="(SELECT uid from users where username='"+username+"')"
    
    values = {}
    
    for index in range(len(oldparams)):
        values[newparams[index]] = '0'

    if values['faction'] != 0:
        if values['faction'] == 1:
            #LSPD
            values['faction']=3
        elif values['faction'] == 2:
            #FBI
            values['faction']=5
        elif values['faction'] == 3:
            #FMD
            values['faction']=1
    
    
    cars = [{},{},{},{},{},{},{},{},{},{}]
    
    for index in range(10):
        cars[index]['pos_x'] = '0'
        cars[index]['pos_y'] = '0'
        cars[index]['pos_z'] = '0'
        cars[index]['pos_a'] = '0'
        cars[index]['modelid'] = '0'
        cars[index]['alarm'] = '0'
        cars[index]['locked'] = '0'
        cars[index]['paintjob'] = '0'
        cars[index]['color1'] = '0'
        cars[index]['color2'] = '0'
        cars[index]['fuel'] = '0'
        cars[index]['weapon_1'] = '0'
        cars[index]['weapon_2'] = '0'
        cars[index]['weapon_3'] = '0'
        cars[index]['trunk'] = '0'

    for line in lines:
        for index in range(len(oldparams)):
            if(line.startswith(oldparams[index]+'=')):
                values[newparams[index]] = GetParamValue(line)
        for index in range(10):
            if(line.startswith('pv'+str(index)+'PosX=')):
                cars[index]['pos_x'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'PosY=')):
                cars[index]['pos_y'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'PosZ=')):
                cars[index]['pos_z'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'PosAngle=')):
                cars[index]['pos_a'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'ModelId=')):
                cars[index]['modelid'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Lock=')):
                cars[index]['alarm'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Locked=')):
                cars[index]['locked'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'PaintJob=')):
                cars[index]['paintjob'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Color1=')):
                cars[index]['color1'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Color2=')):
                cars[index]['color2'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Fuel=')):
                cars[index]['fuel'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Weapon0=')):
                cars[index]['weapon_1'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Weapon1=')):
                cars[index]['weapon_2'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'Weapon2=')):
                cars[index]['weapon_3'] = GetParamValue(line)
            elif(line.startswith('pv'+str(index)+'WepUpgrade=')):
                cars[index]['trunk'] = GetParamValue(line)
        
    print("INSERT INTO users (username,password ,level ,adminlevel ,adminname ,health ,armor ,upgradepoints ,ip ,gender ,age ,skin ,pos_x ,pos_y ,pos_z ,pos_a ,interior ,world ,phone ,faction ,factionrank ,cash ,bank ,crimes ,arrested ,wantedlevel ,weed ,cocaine ,materials ,weapon_1 ,weapon_2 ,weapon_3 ,weapon_4 ,weapon_5 ,weapon_6 ,weapon_7 ,weapon_8 ,weapon_9 ,weapon_10 ,weapon_11 ,weapon_12 ,paycheck ,fishingskill ,guardskill ,weaponskill ,lawyerskill ,detectiveskill ,smugglerskill ,hookerskill ,truckerskill ,carjackerskill ,forkliftskill ,drugdealerskill,passwordchanged,gunlicense)")
    print("    VALUES ('"+username+"','"+values['password']+"','"+values['level']+"','"+values['adminlevel']+"','"+values['adminname']+"','"+values['health']+"','"+values['armor']+"','"+values['upgradepoints']+"','"+values['ip']+"','"+values['gender']+"','"+values['age']+"','"+values['skin']+"','"+values['pos_x']+"','"+values['pos_y']+"','"+values['pos_z']+"','"+values['pos_a']+"','"+values['interior']+"','"+values['world']+"','"+values['phone']+"','"+values['faction']+"','"+values['factionrank']+"','"+values['cash']+"','"+values['bank']+"','"+values['crimes']+"','"+values['arrested']+"','"+values['wantedlevel']+"','"+values['weed']+"','"+values['cocaine']+"','"+values['materials']+"','"+values['weapon_1']+"','"+values['weapon_2']+"','"+values['weapon_3']+"','"+values['weapon_4']+"','"+values['weapon_5']+"','"+values['weapon_6']+"','"+values['weapon_7']+"','"+values['weapon_8']+"','"+values['weapon_9']+"','"+values['weapon_10']+"','"+values['weapon_11']+"','"+values['weapon_12']+"','"+values['paycheck']+"','"+values['fishingskill']+"','"+values['guardskill']+"','"+values['weaponskill']+"','"+values['lawyerskill']+"','"+values['detectiveskill']+"','"+values['smugglerskill']+"','"+values['hookerskill']+"','"+values['truckerskill']+"','"+values['carjackerskill']+"','"+values['forkliftskill']+"','"+values['drugdealerskill']+"',1,1);")
    
    for index in range(10):
        if(cars[index]['modelid'] != '0'):
            print("INSERT INTO vehicles (ownerid,owner,price,pos_x,pos_y,pos_z,pos_a,modelid,alarm,locked,paintjob,color1,color2,fuel,weapon_1,weapon_2,weapon_3,trunk)")
            print("   VALUES ("+ownerid+",'"+username+"',10000,'"+cars[index]['pos_x']+"', '"+cars[index]['pos_y']+"', '"+cars[index]['pos_z']+"', '"+cars[index]['pos_a']+"', '"+cars[index]['modelid']+"', '"+cars[index]['alarm']+"', '"+cars[index]['locked']+"', '"+cars[index]['paintjob']+"', '"+cars[index]['color1']+"', '"+cars[index]['color2']+"', '"+cars[index]['fuel']+"', '"+cars[index]['weapon_1']+"', '"+cars[index]['weapon_2']+"', '"+cars[index]['weapon_3']+"', '"+cars[index]['trunk']+"');")

    
