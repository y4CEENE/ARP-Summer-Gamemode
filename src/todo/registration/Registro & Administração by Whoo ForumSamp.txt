/*-----------------------------------------------------------------------------
|                                                                              |
|					• Registro & Administração MySQL.                          |
|		 				- by Whoo.                                             |
|																			   |
|					• Servidor Utilizando                                      |
|	     				- Plugin MySql R39 by BlueG                            |
|		 				- sscanf2	by Y_Less                                  |
|		 				- zcmd by Zeex                                         |
|                                                                              |
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
» INCLUES » INCLUES » INCLUES » INCLUES » INCLUES » INCLUES » INCLUES » INCLUES
-------------------------------------------------------------------------------*/
#include 					< 		a_samp 		>
#include 					< 		sscanf2		>
#include 					< 		zcmd 		>
#include                    <       a_mysql     >
/*------------------------------------------------------------------------------
» DIALOGS » DIALOGS » DIALOGS » DIALOGS » DIALOGS » DIALOGS » DIALOGS » DIALOGS
-------------------------------------------------------------------------------*/
#define 					d_registro							( 1 )
#define 					d_login								( 2 )
#define                     d_registro_aviso                	( 3	)
#define                     d_admins_on                         ( 4	)
/*------------------------------------------------------------------------------
» SEXO_PLAYER » SEXO_PLAYER » SEXO_PLAYER » SEXO_PLAYER » SEXO_PLAYER » SEXO_PLA
-------------------------------------------------------------------------------*/
#define 					p_masculino                     	 ( 1 )
#define 					p_feminino                      	 ( 2 )
#define                     s_masculino                         ( 240 )
#define                     s_feminino                          ( 216 )
/*------------------------------------------------------------------------------
# CONEXÃO_MYSQL  			# CONEXÃO_MYSQL  				  # CONEXÃO_MYSQL
------------------------------------------------------------------------------*/
#define 				HOST    						"localhost"
#define 				USER    						"user"
#define 				DATABASE 						"database"
#define 				PASSWORD 						"password"

#define                 MAX_PLAYER_PASSWORD             (16)
/*------------------------------------------------------------------------------
» CORES _ MSG » CORES _ MSG » CORES _ MSG » CORES _ MSG » CORES _ MSG » CORES _
-------------------------------------------------------------------------------*/
#define                     mensagem                    	SendClientMessage
#define                     mensagem_all                    SendClientMessageToAll

#define                     c_branco_hex                        "{F8F8FF}"
#define                     c_vermelho_hex                      "{EE3B3B}"
#define                     c_azul_hex                         	"{6495ED}"
#define                     c_rosa_hex                          "{FAA2FA}"
#define                     c_cinza_hex                         "{696969}"
#define                     c_azul_claro_hex                    "{AFEEEE}"
#define                     c_cinza_claro_hex                   "{BEBEBE}"


new mysql_c;
enum player_dados
{
	ORM:ORMID,
	id,
	nome[24],
	senha[16],
	skin,
	dinheiro,
	level,
	sexo,
	admin,
	emprego
};



new
	s_dialog[256],
	erro_senha[MAX_PLAYERS],
	DATA_INFO[MAX_PLAYERS][player_dados],
	bool:ContaExiste[MAX_PLAYERS]
;


new
	Text:wTuning[15],
	Text:wWheels[9],
	Text:wColor[9],
	Text:wPaintJob[3],
	Text:wNitro[3],
	Text:wNeon[6],
	Text:registro_draw[28],
	Text:sexo_draw[15],
	Text:Relogio[2]
;

new
	 bool:wTuningDraw[MAX_PLAYERS],
	 bool:AtivarCarGod[MAX_PLAYERS],
	 bool:p_Logado[MAX_PLAYERS],
	 bool:Turbo[MAX_PLAYERS]
;

new

	NEON_P[MAX_VEHICLES],
	NEON_S[MAX_VEHICLES]
;



new
	dp_veiculos[18],
	dp_portao
;

new
    a_cmd[256]
;

main()
{
	print("-------------------------------------");
	print("     GM CARREGADO COM SUCESSO.       ");
	print(" 	V1.0 By Whoo Forum Samp			");
	print("-------------------------------------");

}

public OnGameModeInit()
{


    mysql_c = mysql_connect(HOST, USER, DATABASE, PASSWORD);
    
	/*

	não é recomendável criar uma tabela utilizando script no gamemode ja que sera criada uma vez só

	CREATE TABLE IF NOT EXISTS `contasp`
   (`id` int(11) NOT NULL AUTO_INCREMENT,
   `nome` varchar(255) NOT NULL,
   `senha` varchar(255) NOT NULL,
    `skin` int(11) NOT NULL,
   `dinheiro` int(11) NOT NULL,
    `level` int(11) NOT NULL,
    `sexo` int(11) NOT NULL,
   `admin` int(11) NOT NULL,
   `emprego` int(11) NOT NULL,
    PRIMARY KEY (`id`))
	

	*/	

    printf("%s", mysql_errno(mysql_c) == 0 ? ("Conectado ao banco de dados") : ("Falha ao conectar ao banco de dados"));


	SetGameModeText("RPG - AHS");

	tempo_real();
	SetTimer("tempo_real", 120000, true);

	dp_portao = CreateObject(980, 1548.65955, -1627.60107, 15.04578,   0.00000, 0.00000, 269.97717);
	CreateObject(3749, 1549.32837, -1627.57788, 17.36279,   0.00000, 0.00000, 270.08295);
	dp_veiculos[0] = AddStaticVehicleEx(596, 1535.6932, -1676.3667, 13.0518, 359.7990, -1, -1, 100);
	dp_veiculos[1] = AddStaticVehicleEx(596, 1535.5873, -1669.0464, 13.0518, 359.7990, -1, -1, 100);
	dp_veiculos[2] = AddStaticVehicleEx(596, 1591.0942, -1606.4717, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[3] = AddStaticVehicleEx(596, 1564.8998, -1606.6538, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[4] = AddStaticVehicleEx(596, 1568.8962, -1606.6490, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[5] = AddStaticVehicleEx(596, 1572.8884, -1606.6442, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[6] = AddStaticVehicleEx(596, 1576.3025, -1606.6399, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[7] = AddStaticVehicleEx(596, 1579.9821, -1606.6351, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[8] = AddStaticVehicleEx(596, 1583.5234, -1606.6582, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[9] = AddStaticVehicleEx(596, 1587.3358, -1606.4675, 12.9923, 359.9057, -1, -1, 100);
	dp_veiculos[10] = AddStaticVehicleEx(427, 1554.1199, -1607.0854, 13.3711, 1.5282, -1, -1, 100);
	dp_veiculos[11] = AddStaticVehicleEx(427, 1561.1278, -1606.8398, 13.3711, 1.5282, -1, -1, 100);
	dp_veiculos[12] = AddStaticVehicleEx(427, 1557.5861, -1606.9319, 13.3711, 1.5282, -1, -1, 100);
	dp_veiculos[13] = AddStaticVehicleEx(427, 1601.4954, -1700.2534, 5.8354, 449.1338, -1, -1, 100);
	dp_veiculos[14] = AddStaticVehicleEx(427, 1601.4110, -1704.1182, 5.8354, 449.1338, -1, -1, 100);
	dp_veiculos[15] = AddStaticVehicleEx(596, 1600.7094, -1696.1484, 5.7263, 89.8691, -1, -1, 100);
	dp_veiculos[16] = AddStaticVehicleEx(596, 1600.9277, -1688.1681, 5.7263, 89.8691, -1, -1, 100);
	dp_veiculos[17] = AddStaticVehicleEx(596, 1600.6254, -1692.2239, 5.7263, 89.8691, -1, -1, 100);



	CreateVehicle(481, 833.1193, -1334.8323, 13.1531, 0.0000, -1, -1, 100);
	CreateVehicle(481, 830.0495, -1334.8363, 13.1531, 0.0000, -1, -1, 100);
	CreateVehicle(481, 830.6771, -1334.8352, 13.1531, 0.0000, -1, -1, 100);
	CreateVehicle(481, 831.3922, -1334.8344, 13.1531, 0.0000, -1, -1, 100);
	CreateVehicle(481, 832.2032, -1334.8334, 13.1531, 0.0000, -1, -1, 100);
	CreateVehicle(483, 819.7554, -1316.2386, 13.5029, 90.2656, -1, -1, 100);
 	AddPlayerClass(0,	332.2479,	-1517.9346,	35.8672,	234.2808,	0,	0,	0,	0,	0,	0);

	SetTimer("p_relogio",1000,1);
	Relogio[0] = TextDrawCreate(448.000000, 411.000000, "");
	TextDrawBackgroundColor(Relogio[0], 255);
	TextDrawFont(Relogio[0], 3);
	TextDrawLetterSize(Relogio[0], 0.419999, 1.399999);
	TextDrawColor(Relogio[0], -1);
	TextDrawSetOutline(Relogio[0], 1);
	TextDrawSetProportional(Relogio[0], 1);
	TextDrawSetSelectable(Relogio[0], 0);

	Relogio[1] = TextDrawCreate(505.000000, 396.000000, "");
	TextDrawBackgroundColor(Relogio[1], 255);
	TextDrawFont(Relogio[1], 3);
	TextDrawLetterSize(Relogio[1], 0.419999, 1.399999);
	TextDrawColor(Relogio[1], -1);
	TextDrawSetOutline(Relogio[1], 1);
	TextDrawSetProportional(Relogio[1], 1);
	TextDrawSetSelectable(Relogio[1], 0);

	registro_draw[0] = TextDrawCreate(660.000000, 2.000000, "_");
	TextDrawBackgroundColor(registro_draw[0], 255);
	TextDrawFont(registro_draw[0], 1);
	TextDrawLetterSize(registro_draw[0], 0.400000, 6.199998);
	TextDrawColor(registro_draw[0], -1);
	TextDrawSetOutline(registro_draw[0], 0);
	TextDrawSetProportional(registro_draw[0], 1);
	TextDrawSetShadow(registro_draw[0], 1);
	TextDrawUseBox(registro_draw[0], 1);
	TextDrawBoxColor(registro_draw[0], 875836671);
	TextDrawTextSize(registro_draw[0], -10.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[0], 0);

	registro_draw[1] = TextDrawCreate(660.000000, 390.000000, "_");
	TextDrawBackgroundColor(registro_draw[1], 255);
	TextDrawFont(registro_draw[1], 1);
	TextDrawLetterSize(registro_draw[1], 0.400000, 6.599998);
	TextDrawColor(registro_draw[1], -1);
	TextDrawSetOutline(registro_draw[1], 0);
	TextDrawSetProportional(registro_draw[1], 1);
	TextDrawSetShadow(registro_draw[1], 1);
	TextDrawUseBox(registro_draw[1], 1);
	TextDrawBoxColor(registro_draw[1], 875836671);
	TextDrawTextSize(registro_draw[1], -10.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[1], 0);

	registro_draw[2] = TextDrawCreate(660.000000, 390.000000, "_");
	TextDrawBackgroundColor(registro_draw[2], 255);
	TextDrawFont(registro_draw[2], 1);
	TextDrawLetterSize(registro_draw[2], 0.400000, -0.200000);
	TextDrawColor(registro_draw[2], -1);
	TextDrawSetOutline(registro_draw[2], 0);
	TextDrawSetProportional(registro_draw[2], 1);
	TextDrawSetShadow(registro_draw[2], 1);
	TextDrawUseBox(registro_draw[2], 1);
	TextDrawBoxColor(registro_draw[2], 512819199);
	TextDrawTextSize(registro_draw[2], -10.000000, -61.000000);
	TextDrawSetSelectable(registro_draw[2], 0);

	registro_draw[3] = TextDrawCreate(660.000000, 60.000000, "_");
	TextDrawBackgroundColor(registro_draw[3], 255);
	TextDrawFont(registro_draw[3], 1);
	TextDrawLetterSize(registro_draw[3], 0.400000, -0.200000);
	TextDrawColor(registro_draw[3], -1);
	TextDrawSetOutline(registro_draw[3], 0);
	TextDrawSetProportional(registro_draw[3], 1);
	TextDrawSetShadow(registro_draw[3], 1);
	TextDrawUseBox(registro_draw[3], 1);
	TextDrawBoxColor(registro_draw[3], 512819199);
	TextDrawTextSize(registro_draw[3], -10.000000, -61.000000);
	TextDrawSetSelectable(registro_draw[3], 0);

	registro_draw[4] = TextDrawCreate(529.000000, 124.000000, "_");
	TextDrawBackgroundColor(registro_draw[4], 255);
	TextDrawFont(registro_draw[4], 1);
	TextDrawLetterSize(registro_draw[4], 0.400000, 1.299998);
	TextDrawColor(registro_draw[4], -1);
	TextDrawSetOutline(registro_draw[4], 0);
	TextDrawSetProportional(registro_draw[4], 1);
	TextDrawSetShadow(registro_draw[4], 1);
	TextDrawUseBox(registro_draw[4], 1);
	TextDrawBoxColor(registro_draw[4], 875836671);
	TextDrawTextSize(registro_draw[4], 118.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[4], 0);

	registro_draw[5] = TextDrawCreate(529.000000, 139.000000, "_");
	TextDrawBackgroundColor(registro_draw[5], 255);
	TextDrawFont(registro_draw[5], 1);
	TextDrawLetterSize(registro_draw[5], 0.400000, 1.299998);
	TextDrawColor(registro_draw[5], -1);
	TextDrawSetOutline(registro_draw[5], 0);
	TextDrawSetProportional(registro_draw[5], 1);
	TextDrawSetShadow(registro_draw[5], 1);
	TextDrawUseBox(registro_draw[5], 1);
	TextDrawBoxColor(registro_draw[5], 512819199);
	TextDrawTextSize(registro_draw[5], 118.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[5], 0);

	registro_draw[6] = TextDrawCreate(529.000000, 154.000000, "_");
	TextDrawBackgroundColor(registro_draw[6], 255);
	TextDrawFont(registro_draw[6], 1);
	TextDrawLetterSize(registro_draw[6], 0.400000, 19.299999);
	TextDrawColor(registro_draw[6], -1);
	TextDrawSetOutline(registro_draw[6], 0);
	TextDrawSetProportional(registro_draw[6], 1);
	TextDrawSetShadow(registro_draw[6], 1);
	TextDrawUseBox(registro_draw[6], 1);
	TextDrawBoxColor(registro_draw[6], 875836671);
	TextDrawTextSize(registro_draw[6], 118.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[6], 0);

	registro_draw[7] = TextDrawCreate(377.000000, 161.000000, "_");
	TextDrawBackgroundColor(registro_draw[7], 255);
	TextDrawFont(registro_draw[7], 1);
	TextDrawLetterSize(registro_draw[7], 0.400000, 1.299998);
	TextDrawColor(registro_draw[7], -1);
	TextDrawSetOutline(registro_draw[7], 0);
	TextDrawSetProportional(registro_draw[7], 1);
	TextDrawSetShadow(registro_draw[7], 1);
	TextDrawUseBox(registro_draw[7], 1);
	TextDrawBoxColor(registro_draw[7], 512819199);
	TextDrawTextSize(registro_draw[7], 262.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[7], 0);

	registro_draw[8] = TextDrawCreate(529.000000, 176.000000, "_");
	TextDrawBackgroundColor(registro_draw[8], 255);
	TextDrawFont(registro_draw[8], 1);
	TextDrawLetterSize(registro_draw[8], 0.400000, -0.200001);
	TextDrawColor(registro_draw[8], -1);
	TextDrawSetOutline(registro_draw[8], 0);
	TextDrawSetProportional(registro_draw[8], 1);
	TextDrawSetShadow(registro_draw[8], 1);
	TextDrawUseBox(registro_draw[8], 1);
	TextDrawBoxColor(registro_draw[8], 512819199);
	TextDrawTextSize(registro_draw[8], 118.000000, 0.000000);
	TextDrawSetSelectable(registro_draw[8], 0);

	registro_draw[9] = TextDrawCreate(285.000000, 161.000000, "informacoes");
	TextDrawBackgroundColor(registro_draw[9], 255);
	TextDrawFont(registro_draw[9], 2);
	TextDrawLetterSize(registro_draw[9], 0.250000, 1.100000);
	TextDrawColor(registro_draw[9], -1);
	TextDrawSetOutline(registro_draw[9], 0);
	TextDrawSetProportional(registro_draw[9], 1);
	TextDrawSetShadow(registro_draw[9], 0);
	TextDrawSetSelectable(registro_draw[9], 0);

	registro_draw[10] = TextDrawCreate(133.000000, 191.000000, "servidor rpg");
	TextDrawBackgroundColor(registro_draw[10], 255);
	TextDrawFont(registro_draw[10], 2);
	TextDrawLetterSize(registro_draw[10], 0.280000, 1.100000);
	TextDrawColor(registro_draw[10], -1);
	TextDrawSetOutline(registro_draw[10], 0);
	TextDrawSetProportional(registro_draw[10], 1);
	TextDrawSetShadow(registro_draw[10], 0);
	TextDrawSetSelectable(registro_draw[10], 0);

	registro_draw[11] = TextDrawCreate(133.000000, 202.000000, "Server Nome: AHS - SERVER");
	TextDrawBackgroundColor(registro_draw[11], 255);
	TextDrawFont(registro_draw[11], 2);
	TextDrawLetterSize(registro_draw[11], 0.280000, 1.100000);
	TextDrawColor(registro_draw[11], -1);
	TextDrawSetOutline(registro_draw[11], 0);
	TextDrawSetProportional(registro_draw[11], 1);
	TextDrawSetShadow(registro_draw[11], 0);
	TextDrawSetSelectable(registro_draw[11], 0);

	registro_draw[12] = TextDrawCreate(133.000000, 213.000000, "Server Mode: RPG/RP");
	TextDrawBackgroundColor(registro_draw[12], 255);
	TextDrawFont(registro_draw[12], 2);
	TextDrawLetterSize(registro_draw[12], 0.280000, 1.100000);
	TextDrawColor(registro_draw[12], -1);
	TextDrawSetOutline(registro_draw[12], 0);
	TextDrawSetProportional(registro_draw[12], 1);
	TextDrawSetShadow(registro_draw[12], 0);
	TextDrawSetSelectable(registro_draw[12], 0);

	registro_draw[13] = TextDrawCreate(133.000000, 224.000000, "MAXIMO DE PLAYERS: 500");
	TextDrawBackgroundColor(registro_draw[13], 255);
	TextDrawFont(registro_draw[13], 2);
	TextDrawLetterSize(registro_draw[13], 0.280000, 1.100000);
	TextDrawColor(registro_draw[13], -1);
	TextDrawSetOutline(registro_draw[13], 0);
	TextDrawSetProportional(registro_draw[13], 1);
	TextDrawSetShadow(registro_draw[13], 0);
	TextDrawSetSelectable(registro_draw[13], 0);

	registro_draw[14] = TextDrawCreate(133.000000, 235.000000, "IP: 127.0.0.1");
	TextDrawBackgroundColor(registro_draw[14], 255);
	TextDrawFont(registro_draw[14], 2);
	TextDrawLetterSize(registro_draw[14], 0.280000, 1.100000);
	TextDrawColor(registro_draw[14], -1);
	TextDrawSetOutline(registro_draw[14], 0);
	TextDrawSetProportional(registro_draw[14], 1);
	TextDrawSetShadow(registro_draw[14], 0);
	TextDrawSetSelectable(registro_draw[14], 0);

	registro_draw[15] = TextDrawCreate(133.000000, 246.000000, "criado por: Whoo");
	TextDrawBackgroundColor(registro_draw[15], 255);
	TextDrawFont(registro_draw[15], 2);
	TextDrawLetterSize(registro_draw[15], 0.280000, 1.100000);
	TextDrawColor(registro_draw[15], -1);
	TextDrawSetOutline(registro_draw[15], 0);
	TextDrawSetProportional(registro_draw[15], 1);
	TextDrawSetShadow(registro_draw[15], 0);
	TextDrawSetSelectable(registro_draw[15], 0);

	registro_draw[16] = TextDrawCreate(133.000000, 257.000000, "SITE: WWW.AHS-SERVER.COM.BR");
	TextDrawBackgroundColor(registro_draw[16], 255);
	TextDrawFont(registro_draw[16], 2);
	TextDrawLetterSize(registro_draw[16], 0.280000, 1.100000);
	TextDrawColor(registro_draw[16], -1);
	TextDrawSetOutline(registro_draw[16], 0);
	TextDrawSetProportional(registro_draw[16], 1);
	TextDrawSetShadow(registro_draw[16], 0);
	TextDrawSetSelectable(registro_draw[16], 0);

	registro_draw[17] = TextDrawCreate(133.000000, 268.000000, "_");
	TextDrawBackgroundColor(registro_draw[17], 255);
	TextDrawFont(registro_draw[17], 2);
	TextDrawLetterSize(registro_draw[17], 0.280000, 1.100000);
	TextDrawColor(registro_draw[17], -1);
	TextDrawSetOutline(registro_draw[17], 0);
	TextDrawSetProportional(registro_draw[17], 1);
	TextDrawSetShadow(registro_draw[17], 0);
	TextDrawSetSelectable(registro_draw[17], 0);

	registro_draw[18] = TextDrawCreate(133.000000, 279.000000, "_");
	TextDrawBackgroundColor(registro_draw[18], 255);
	TextDrawFont(registro_draw[18], 2);
	TextDrawLetterSize(registro_draw[18], 0.280000, 1.100000);
	TextDrawColor(registro_draw[18], -1);
	TextDrawSetOutline(registro_draw[18], 0);
	TextDrawSetProportional(registro_draw[18], 1);
	TextDrawSetShadow(registro_draw[18], 0);
	TextDrawSetSelectable(registro_draw[18], 0);

	registro_draw[19] = TextDrawCreate(133.000000, 290.000000, "_");
	TextDrawBackgroundColor(registro_draw[19], 255);
	TextDrawFont(registro_draw[19], 2);
	TextDrawLetterSize(registro_draw[19], 0.280000, 1.100000);
	TextDrawColor(registro_draw[19], -1);
	TextDrawSetOutline(registro_draw[19], 0);
	TextDrawSetProportional(registro_draw[19], 1);
	TextDrawSetShadow(registro_draw[19], 0);
	TextDrawSetSelectable(registro_draw[19], 0);

	registro_draw[20] = TextDrawCreate(133.000000, 301.000000, "_");
	TextDrawBackgroundColor(registro_draw[20], 255);
	TextDrawFont(registro_draw[20], 2);
	TextDrawLetterSize(registro_draw[20], 0.280000, 1.100000);
	TextDrawColor(registro_draw[20], -1);
	TextDrawSetOutline(registro_draw[20], 0);
	TextDrawSetProportional(registro_draw[20], 1);
	TextDrawSetShadow(registro_draw[20], 0);
	TextDrawSetSelectable(registro_draw[20], 0);

	registro_draw[21] = TextDrawCreate(133.000000, 312.000000, "_");
	TextDrawBackgroundColor(registro_draw[21], 255);
	TextDrawFont(registro_draw[21], 2);
	TextDrawLetterSize(registro_draw[21], 0.280000, 1.100000);
	TextDrawColor(registro_draw[21], -1);
	TextDrawSetOutline(registro_draw[21], 0);
	TextDrawSetProportional(registro_draw[21], 1);
	TextDrawSetShadow(registro_draw[21], 0);
	TextDrawSetSelectable(registro_draw[21], 0);

	registro_draw[22] = TextDrawCreate(280.000000, 124.000000, "AHS - SERVER");
	TextDrawBackgroundColor(registro_draw[22], 255);
	TextDrawFont(registro_draw[22], 2);
	TextDrawLetterSize(registro_draw[22], 0.280000, 1.100000);
	TextDrawColor(registro_draw[22], -1);
	TextDrawSetOutline(registro_draw[22], 0);
	TextDrawSetProportional(registro_draw[22], 1);
	TextDrawSetShadow(registro_draw[22], 0);
	TextDrawSetSelectable(registro_draw[22], 0);

	registro_draw[23] = TextDrawCreate(203.000000, 139.000000, "logar");
	TextDrawBackgroundColor(registro_draw[23], 255);
	TextDrawFont(registro_draw[23], 2);
	TextDrawLetterSize(registro_draw[23], 0.280000, 1.100000);
	TextDrawColor(registro_draw[23], -1);
	TextDrawSetOutline(registro_draw[23], 0);
	TextDrawSetProportional(registro_draw[23], 1);
	TextDrawSetShadow(registro_draw[23], 0);
	TextDrawUseBox(registro_draw[23], 1);
	TextDrawBoxColor(registro_draw[23], 0);
	TextDrawTextSize(registro_draw[23], 242.000000, 10.000000);
	TextDrawSetSelectable(registro_draw[23], 0);

	registro_draw[24] = TextDrawCreate(288.000000, 139.000000, "registrar");
	TextDrawBackgroundColor(registro_draw[24], 255);
	TextDrawFont(registro_draw[24], 2);
	TextDrawLetterSize(registro_draw[24], 0.280000, 1.100000);
	TextDrawColor(registro_draw[24], -1);
	TextDrawSetOutline(registro_draw[24], 0);
	TextDrawSetProportional(registro_draw[24], 1);
	TextDrawSetShadow(registro_draw[24], 0);
	TextDrawUseBox(registro_draw[24], 1);
	TextDrawBoxColor(registro_draw[24], 0);
	TextDrawTextSize(registro_draw[24], 353.000000, 10.000000);
	TextDrawSetSelectable(registro_draw[24], 0);

	registro_draw[25] = TextDrawCreate(396.000000, 139.000000, "sair");
	TextDrawBackgroundColor(registro_draw[25], 255);
	TextDrawFont(registro_draw[25], 2);
	TextDrawLetterSize(registro_draw[25], 0.280000, 1.100000);
	TextDrawColor(registro_draw[25], -1);
	TextDrawSetOutline(registro_draw[25], 0);
	TextDrawSetProportional(registro_draw[25], 1);
	TextDrawSetShadow(registro_draw[25], 0);
	TextDrawUseBox(registro_draw[25], 1);
	TextDrawBoxColor(registro_draw[25], 0);
	TextDrawTextSize(registro_draw[25], 427.000000, 10.000000);
	TextDrawSetSelectable(registro_draw[25], 0);

	registro_draw[26] = TextDrawCreate(514.000000, 316.000000, "~>~");
	TextDrawBackgroundColor(registro_draw[26], 255);
	TextDrawFont(registro_draw[26], 1);
	TextDrawLetterSize(registro_draw[26], 0.500000, 1.000000);
	TextDrawColor(registro_draw[26], -1);
	TextDrawSetOutline(registro_draw[26], 0);
	TextDrawSetProportional(registro_draw[26], 1);
	TextDrawSetShadow(registro_draw[26], 1);
	TextDrawUseBox(registro_draw[26], 1);
	TextDrawBoxColor(registro_draw[26], 0);
	TextDrawTextSize(registro_draw[26], 523.000000, 10.000000);
	TextDrawSetSelectable(registro_draw[26], 0);

	registro_draw[27] = TextDrawCreate(504.000000, 316.000000, "~<~");
	TextDrawBackgroundColor(registro_draw[27], 255);
	TextDrawFont(registro_draw[27], 1);
	TextDrawLetterSize(registro_draw[27], 0.500000, 1.000000);
	TextDrawColor(registro_draw[27], -1);
	TextDrawSetOutline(registro_draw[27], 0);
	TextDrawSetProportional(registro_draw[27], 1);
	TextDrawSetShadow(registro_draw[27], 1);
	TextDrawUseBox(registro_draw[27], 1);
	TextDrawBoxColor(registro_draw[27], 0);
	TextDrawTextSize(registro_draw[27], 512.000000, 10.000000);
	TextDrawSetSelectable(registro_draw[27], 0);
	for(new i = 23; i < sizeof(registro_draw); i++) { TextDrawSetSelectable(registro_draw[i], true); }

	sexo_draw[0] = TextDrawCreate(434.000000, 80.000000, "_");
	TextDrawBackgroundColor(sexo_draw[0], 255);
	TextDrawFont(sexo_draw[0], 1);
	TextDrawLetterSize(sexo_draw[0], 0.500000, 22.300001);
	TextDrawColor(sexo_draw[0], -1);
	TextDrawSetOutline(sexo_draw[0], 0);
	TextDrawSetProportional(sexo_draw[0], 1);
	TextDrawSetShadow(sexo_draw[0], 1);
	TextDrawUseBox(sexo_draw[0], 1);
	TextDrawBoxColor(sexo_draw[0], 875836671);
	TextDrawTextSize(sexo_draw[0], 195.000000, 0.000000);
	TextDrawSetSelectable(sexo_draw[0], 0);

	sexo_draw[1] = TextDrawCreate(434.000000, 100.000000, "_");
	TextDrawBackgroundColor(sexo_draw[1], 255);
	TextDrawFont(sexo_draw[1], 1);
	TextDrawLetterSize(sexo_draw[1], 0.490000, 1.699999);
	TextDrawColor(sexo_draw[1], -1);
	TextDrawSetOutline(sexo_draw[1], 0);
	TextDrawSetProportional(sexo_draw[1], 1);
	TextDrawSetShadow(sexo_draw[1], 1);
	TextDrawUseBox(sexo_draw[1], 1);
	TextDrawBoxColor(sexo_draw[1], 512819199);
	TextDrawTextSize(sexo_draw[1], 195.000000, 0.000000);
	TextDrawSetSelectable(sexo_draw[1], 0);

	sexo_draw[2] = TextDrawCreate(203.000000, 130.000000, "New Textdraw");
	TextDrawBackgroundColor(sexo_draw[2], 0);
	TextDrawFont(sexo_draw[2], 5);
	TextDrawLetterSize(sexo_draw[2], 0.500000, 1.000000);
	TextDrawColor(sexo_draw[2], -1);
	TextDrawSetOutline(sexo_draw[2], 0);
	TextDrawSetProportional(sexo_draw[2], 1);
	TextDrawSetShadow(sexo_draw[2], 1);
	TextDrawUseBox(sexo_draw[2], 1);
	TextDrawBoxColor(sexo_draw[2], 255);
	TextDrawTextSize(sexo_draw[2], 115.000000, 103.000000);
	TextDrawSetPreviewModel(sexo_draw[2], 240);
	TextDrawSetPreviewRot(sexo_draw[2], -10.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(sexo_draw[2], 0);

	sexo_draw[3] = TextDrawCreate(310.000000, 130.000000, "New Textdraw");
	TextDrawBackgroundColor(sexo_draw[3], 0);
	TextDrawFont(sexo_draw[3], 5);
	TextDrawLetterSize(sexo_draw[3], 0.500000, 1.000000);
	TextDrawColor(sexo_draw[3], -1);
	TextDrawSetOutline(sexo_draw[3], 0);
	TextDrawSetProportional(sexo_draw[3], 1);
	TextDrawSetShadow(sexo_draw[3], 1);
	TextDrawUseBox(sexo_draw[3], 1);
	TextDrawBoxColor(sexo_draw[3], 255);
	TextDrawTextSize(sexo_draw[3], 115.000000, 103.000000);
	TextDrawSetPreviewModel(sexo_draw[3], 216);
	TextDrawSetPreviewRot(sexo_draw[3], -20.000000, 0.000000, 10.000000, 1.000000);
	TextDrawSetSelectable(sexo_draw[3], 0);

	sexo_draw[4] = TextDrawCreate(294.000000, 84.000000, "sexo");
	TextDrawBackgroundColor(sexo_draw[4], 255);
	TextDrawFont(sexo_draw[4], 2);
	TextDrawLetterSize(sexo_draw[4], 0.340000, 1.100000);
	TextDrawColor(sexo_draw[4], -1);
	TextDrawSetOutline(sexo_draw[4], 0);
	TextDrawSetProportional(sexo_draw[4], 1);
	TextDrawSetShadow(sexo_draw[4], 0);
	TextDrawSetSelectable(sexo_draw[4], 0);

	sexo_draw[5] = TextDrawCreate(230.000000, 102.000000, "escolha o seu sexo abaixo");
	TextDrawBackgroundColor(sexo_draw[5], 255);
	TextDrawFont(sexo_draw[5], 2);
	TextDrawLetterSize(sexo_draw[5], 0.290000, 1.000000);
	TextDrawColor(sexo_draw[5], -1);
	TextDrawSetOutline(sexo_draw[5], 0);
	TextDrawSetProportional(sexo_draw[5], 1);
	TextDrawSetShadow(sexo_draw[5], 0);
	TextDrawSetSelectable(sexo_draw[5], 0);

	sexo_draw[6] = TextDrawCreate(434.000000, 230.000000, "_");
	TextDrawBackgroundColor(sexo_draw[6], 255);
	TextDrawFont(sexo_draw[6], 1);
	TextDrawLetterSize(sexo_draw[6], 0.490000, 1.699999);
	TextDrawColor(sexo_draw[6], -1);
	TextDrawSetOutline(sexo_draw[6], 0);
	TextDrawSetProportional(sexo_draw[6], 1);
	TextDrawSetShadow(sexo_draw[6], 1);
	TextDrawUseBox(sexo_draw[6], 1);
	TextDrawBoxColor(sexo_draw[6], 512819199);
	TextDrawTextSize(sexo_draw[6], 195.000000, 0.000000);
	TextDrawSetSelectable(sexo_draw[6], 0);

	sexo_draw[7] = TextDrawCreate(314.000000, 120.000000, "_");
	TextDrawBackgroundColor(sexo_draw[7], 255);
	TextDrawFont(sexo_draw[7], 1);
	TextDrawLetterSize(sexo_draw[7], 0.539999, 11.600002);
	TextDrawColor(sexo_draw[7], -1);
	TextDrawSetOutline(sexo_draw[7], 0);
	TextDrawSetProportional(sexo_draw[7], 1);
	TextDrawSetShadow(sexo_draw[7], 1);
	TextDrawUseBox(sexo_draw[7], 1);
	TextDrawBoxColor(sexo_draw[7], 512819199);
	TextDrawTextSize(sexo_draw[7], 311.000000, 0.000000);
	TextDrawSetSelectable(sexo_draw[7], 0);

	sexo_draw[8] = TextDrawCreate(303.000000, 257.000000, "_");
	TextDrawBackgroundColor(sexo_draw[8], 255);
	TextDrawFont(sexo_draw[8], 1);
	TextDrawLetterSize(sexo_draw[8], 0.490000, 1.699999);
	TextDrawColor(sexo_draw[8], -1);
	TextDrawSetOutline(sexo_draw[8], 0);
	TextDrawSetProportional(sexo_draw[8], 1);
	TextDrawSetShadow(sexo_draw[8], 1);
	TextDrawUseBox(sexo_draw[8], 1);
	TextDrawBoxColor(sexo_draw[8], 1768516095);
	TextDrawTextSize(sexo_draw[8], 208.000000, 2.000000);
	TextDrawSetSelectable(sexo_draw[8], 0);

	sexo_draw[9] = TextDrawCreate(421.000000, 257.000000, "_");
	TextDrawBackgroundColor(sexo_draw[9], 255);
	TextDrawFont(sexo_draw[9], 1);
	TextDrawLetterSize(sexo_draw[9], 0.490000, 1.699999);
	TextDrawColor(sexo_draw[9], -1);
	TextDrawSetOutline(sexo_draw[9], 0);
	TextDrawSetProportional(sexo_draw[9], 1);
	TextDrawSetShadow(sexo_draw[9], 1);
	TextDrawUseBox(sexo_draw[9], 1);
	TextDrawBoxColor(sexo_draw[9], 1768516095);
	TextDrawTextSize(sexo_draw[9], 325.000000, 2.000000);
	TextDrawSetSelectable(sexo_draw[9], 0);

	sexo_draw[10] = TextDrawCreate(300.000000, 260.000000, "_");
	TextDrawBackgroundColor(sexo_draw[10], 255);
	TextDrawFont(sexo_draw[10], 1);
	TextDrawLetterSize(sexo_draw[10], 0.490000, 0.999999);
	TextDrawColor(sexo_draw[10], -1);
	TextDrawSetOutline(sexo_draw[10], 0);
	TextDrawSetProportional(sexo_draw[10], 1);
	TextDrawSetShadow(sexo_draw[10], 1);
	TextDrawUseBox(sexo_draw[10], 1);
	TextDrawBoxColor(sexo_draw[10], 512819199);
	TextDrawTextSize(sexo_draw[10], 211.000000, 0.000000);
	TextDrawSetSelectable(sexo_draw[10], 0);

	sexo_draw[11] = TextDrawCreate(417.000000, 260.000000, "_");
	TextDrawBackgroundColor(sexo_draw[11], 255);
	TextDrawFont(sexo_draw[11], 1);
	TextDrawLetterSize(sexo_draw[11], 0.490000, 0.999999);
	TextDrawColor(sexo_draw[11], -1);
	TextDrawSetOutline(sexo_draw[11], 0);
	TextDrawSetProportional(sexo_draw[11], 1);
	TextDrawSetShadow(sexo_draw[11], 1);
	TextDrawUseBox(sexo_draw[11], 1);
	TextDrawBoxColor(sexo_draw[11], 512819199);
	TextDrawTextSize(sexo_draw[11], 330.000000, 0.000000);
	TextDrawSetSelectable(sexo_draw[11], 0);

	sexo_draw[12] = TextDrawCreate(241.000000, 232.000000, "masculino ou feminino ?");
	TextDrawBackgroundColor(sexo_draw[12], 255);
	TextDrawFont(sexo_draw[12], 2);
	TextDrawLetterSize(sexo_draw[12], 0.290000, 1.000000);
	TextDrawColor(sexo_draw[12], -1);
	TextDrawSetOutline(sexo_draw[12], 0);
	TextDrawSetProportional(sexo_draw[12], 1);
	TextDrawSetShadow(sexo_draw[12], 0);
	TextDrawSetSelectable(sexo_draw[12], 0);

	sexo_draw[13] = TextDrawCreate(220.000000, 260.000000, "masculino");
	TextDrawBackgroundColor(sexo_draw[13], 255);
	TextDrawFont(sexo_draw[13], 2);
	TextDrawLetterSize(sexo_draw[13], 0.310000, 1.000000);
	TextDrawColor(sexo_draw[13], -1);
	TextDrawSetOutline(sexo_draw[13], 0);
	TextDrawSetProportional(sexo_draw[13], 1);
	TextDrawSetShadow(sexo_draw[13], 0);
	TextDrawUseBox(sexo_draw[13], 1);
	TextDrawBoxColor(sexo_draw[13], 0);
	TextDrawTextSize(sexo_draw[13], 290.000000, 10.000000);
	TextDrawSetSelectable(sexo_draw[13], 0);

	sexo_draw[14] = TextDrawCreate(345.000000, 260.000000, "feminino");
	TextDrawBackgroundColor(sexo_draw[14], 255);
	TextDrawFont(sexo_draw[14], 2);
	TextDrawLetterSize(sexo_draw[14], 0.310000, 1.000000);
	TextDrawColor(sexo_draw[14], -1);
	TextDrawSetOutline(sexo_draw[14], 0);
	TextDrawSetProportional(sexo_draw[14], 1);
	TextDrawSetShadow(sexo_draw[14], 0);
	TextDrawUseBox(sexo_draw[14], 1);
	TextDrawBoxColor(sexo_draw[14], 0);
	TextDrawTextSize(sexo_draw[14], 404.000000, 10.000000);
	TextDrawSetSelectable(sexo_draw[14], 0);
    for(new i = 13; i < sizeof(sexo_draw); i++) { TextDrawSetSelectable(sexo_draw[i], true); }


	wTuning[0] = TextDrawCreate(560.000000, 102.000000, "_");
	TextDrawBackgroundColor(wTuning[0], 255);
	TextDrawFont(wTuning[0], 1);
	TextDrawLetterSize(wTuning[0], 0.709999, 1.599998);
	TextDrawColor(wTuning[0], 852308735);
	TextDrawSetOutline(wTuning[0], 0);
	TextDrawSetProportional(wTuning[0], 1);
	TextDrawSetShadow(wTuning[0], 1);
	TextDrawUseBox(wTuning[0], 1);
	TextDrawBoxColor(wTuning[0], 793726975);
	TextDrawTextSize(wTuning[0], 72.000000, 20.000000);
	TextDrawSetSelectable(wTuning[0], 0);

	wTuning[1] = TextDrawCreate(560.000000, 120.000000, "_");
	TextDrawBackgroundColor(wTuning[1], 255);
	TextDrawFont(wTuning[1], 1);
	TextDrawLetterSize(wTuning[1], 0.709999, 1.699998);
	TextDrawColor(wTuning[1], -1);
	TextDrawSetOutline(wTuning[1], 0);
	TextDrawSetProportional(wTuning[1], 1);
	TextDrawSetShadow(wTuning[1], 1);
	TextDrawUseBox(wTuning[1], 1);
	TextDrawBoxColor(wTuning[1], 150);
	TextDrawTextSize(wTuning[1], 72.000000, 20.000000);
	TextDrawSetSelectable(wTuning[1], 0);

	wTuning[2] = TextDrawCreate(243.000000, 144.000000, "_");
	TextDrawBackgroundColor(wTuning[2], 255);
	TextDrawFont(wTuning[2], 1);
	TextDrawLetterSize(wTuning[2], 0.709999, 21.299999);
	TextDrawColor(wTuning[2], -1);
	TextDrawSetOutline(wTuning[2], 0);
	TextDrawSetProportional(wTuning[2], 1);
	TextDrawSetShadow(wTuning[2], 1);
	TextDrawUseBox(wTuning[2], 1);
	TextDrawBoxColor(wTuning[2], 150);
	TextDrawTextSize(wTuning[2], 72.000000, 19.000000);
	TextDrawSetSelectable(wTuning[2], 0);

	wTuning[3] = TextDrawCreate(560.000000, 144.000000, "_");
	TextDrawBackgroundColor(wTuning[3], 255);
	TextDrawFont(wTuning[3], 1);
	TextDrawLetterSize(wTuning[3], 0.709999, 2.900000);
	TextDrawColor(wTuning[3], -1);
	TextDrawSetOutline(wTuning[3], 0);
	TextDrawSetProportional(wTuning[3], 1);
	TextDrawSetShadow(wTuning[3], 1);
	TextDrawUseBox(wTuning[3], 1);
	TextDrawBoxColor(wTuning[3], 793726975);
	TextDrawTextSize(wTuning[3], 247.000000, 19.000000);
	TextDrawSetSelectable(wTuning[3], 0);


	wTuning[4] = TextDrawCreate(262.000000, 104.000000, "wTuning System");
	TextDrawBackgroundColor(wTuning[4], 255);
	TextDrawFont(wTuning[4], 2);
	TextDrawLetterSize(wTuning[4], 0.300000, 1.000000);
	TextDrawColor(wTuning[4], -1);
	TextDrawSetOutline(wTuning[4], 0);
	TextDrawSetProportional(wTuning[4], 1);
	TextDrawSetShadow(wTuning[4], 0);
	TextDrawSetSelectable(wTuning[4], 0);


	wTuning[5] = TextDrawCreate(376.000000, 152.000000, "wTuningCar");
	TextDrawBackgroundColor(wTuning[5], 255);
	TextDrawFont(wTuning[5], 2);
	TextDrawLetterSize(wTuning[5], 0.220000, 1.100000);
	TextDrawColor(wTuning[5], -1);
	TextDrawSetOutline(wTuning[5], 0);
	TextDrawSetProportional(wTuning[5], 1);
	TextDrawSetShadow(wTuning[5], 0);
	TextDrawSetSelectable(wTuning[5], 0);


	wTuning[6] = TextDrawCreate(538.000000, 105.000000, "X");
	TextDrawBackgroundColor(wTuning[6], 255);
	TextDrawFont(wTuning[6], 1);
	TextDrawLetterSize(wTuning[6], 0.500000, 1.000000);
	TextDrawColor(wTuning[6], 255);
	TextDrawSetOutline(wTuning[6], 0);
	TextDrawSetProportional(wTuning[6], 1);
	TextDrawSetShadow(wTuning[6], 0);
	TextDrawUseBox(wTuning[6], 1);
	TextDrawBoxColor(wTuning[6], 0);
	TextDrawTextSize(wTuning[6], 550.000000, 10.000000);
	TextDrawSetSelectable(wTuning[6], 1);

	wTuning[7] = TextDrawCreate(88.000000, 123.000000, "Wheels");
	TextDrawBackgroundColor(wTuning[7], 255);
	TextDrawFont(wTuning[7], 2);
	TextDrawLetterSize(wTuning[7], 0.300000, 1.000000);
	TextDrawColor(wTuning[7], -1);
	TextDrawSetOutline(wTuning[7], 0);
	TextDrawSetProportional(wTuning[7], 1);
	TextDrawSetShadow(wTuning[7], 0);
	TextDrawUseBox(wTuning[7], 1);
	TextDrawBoxColor(wTuning[7], 0);
	TextDrawTextSize(wTuning[7], 137.000000, 10.000000);
	TextDrawSetSelectable(wTuning[7], 0);

	wTuning[8] = TextDrawCreate(150.000000, 123.000000, "Color");
	TextDrawBackgroundColor(wTuning[8], 255);
	TextDrawFont(wTuning[8], 2);
	TextDrawLetterSize(wTuning[8], 0.300000, 1.000000);
	TextDrawColor(wTuning[8], -1);
	TextDrawSetOutline(wTuning[8], 0);
	TextDrawSetProportional(wTuning[8], 1);
	TextDrawSetShadow(wTuning[8], 0);
	TextDrawUseBox(wTuning[8], 1);
	TextDrawBoxColor(wTuning[8], 0);
	TextDrawTextSize(wTuning[8], 190.000000, 10.000000);
	TextDrawSetSelectable(wTuning[8], 0);

	wTuning[9] = TextDrawCreate(204.000000, 123.000000, "paintjobs");
	TextDrawBackgroundColor(wTuning[9], 255);
	TextDrawFont(wTuning[9], 2);
	TextDrawLetterSize(wTuning[9], 0.300000, 1.000000);
	TextDrawColor(wTuning[9], -1);
	TextDrawSetOutline(wTuning[9], 0);
	TextDrawSetProportional(wTuning[9], 1);
	TextDrawSetShadow(wTuning[9], 0);
	TextDrawUseBox(wTuning[9], 1);
	TextDrawBoxColor(wTuning[9], 0);
	TextDrawTextSize(wTuning[9], 274.000000, 10.000000);
	TextDrawSetSelectable(wTuning[9], 0);

	wTuning[10] = TextDrawCreate(284.000000, 123.000000, "nitro");
	TextDrawBackgroundColor(wTuning[10], 255);
	TextDrawFont(wTuning[10], 2);
	TextDrawLetterSize(wTuning[10], 0.300000, 1.000000);
	TextDrawColor(wTuning[10], -1);
	TextDrawSetOutline(wTuning[10], 0);
	TextDrawSetProportional(wTuning[10], 1);
	TextDrawSetShadow(wTuning[10], 0);
	TextDrawUseBox(wTuning[10], 1);
	TextDrawBoxColor(wTuning[10], 0);
	TextDrawTextSize(wTuning[10], 320.000000, 10.000000);
	TextDrawSetSelectable(wTuning[10], 0);

	wTuning[11] = TextDrawCreate(334.000000, 123.000000, "hydraulics");
	TextDrawBackgroundColor(wTuning[11], 255);
	TextDrawFont(wTuning[11], 2);
	TextDrawLetterSize(wTuning[11], 0.300000, 1.000000);
	TextDrawColor(wTuning[11], -1);
	TextDrawSetOutline(wTuning[11], 0);
	TextDrawSetProportional(wTuning[11], 1);
	TextDrawSetShadow(wTuning[11], 0);
	TextDrawUseBox(wTuning[11], 1);
	TextDrawBoxColor(wTuning[11], 0);
	TextDrawTextSize(wTuning[11], 411.000000, 10.000000);
	TextDrawSetSelectable(wTuning[11], 0);

	wTuning[12] = TextDrawCreate(424.000000, 123.000000, "neon");
	TextDrawBackgroundColor(wTuning[12], 255);
	TextDrawFont(wTuning[12], 2);
	TextDrawLetterSize(wTuning[12], 0.300000, 1.000000);
	TextDrawColor(wTuning[12], -1);
	TextDrawSetOutline(wTuning[12], 0);
	TextDrawSetProportional(wTuning[12], 1);
	TextDrawSetShadow(wTuning[12], 0);
	TextDrawUseBox(wTuning[12], 1);
	TextDrawBoxColor(wTuning[12], 0);
	TextDrawTextSize(wTuning[12], 457.000000, 10.000000);
	TextDrawSetSelectable(wTuning[12], 0);

	wTuning[13] = TextDrawCreate(466.000000, 123.000000, "autotuning");
	TextDrawBackgroundColor(wTuning[13], 255);
	TextDrawFont(wTuning[13], 2);
	TextDrawLetterSize(wTuning[13], 0.300000, 1.000000);
	TextDrawColor(wTuning[13], -1);
	TextDrawSetOutline(wTuning[13], 0);
	TextDrawSetProportional(wTuning[13], 1);
	TextDrawSetShadow(wTuning[13], 0);
	TextDrawUseBox(wTuning[13], 1);
	TextDrawBoxColor(wTuning[13], 0);
	TextDrawTextSize(wTuning[13], 542.000000, 10.000000);
	TextDrawSetSelectable(wTuning[13], 0);

	/*------------------------------------------------------------------------------

	• Wheels • Wheels • Wheels • Wheels • Wheels • Wheels • Wheels • Wheels • Wheels

	------------------------------------------------------------------------------*/
	wWheels[0] = TextDrawCreate(88.000000, 149.000000, "shadow_________________");
	TextDrawBackgroundColor(wWheels[0], 255);
	TextDrawFont(wWheels[0], 2);
	TextDrawLetterSize(wWheels[0], 0.300000, 1.000000);
	TextDrawColor(wWheels[0], -1);
	TextDrawSetOutline(wWheels[0], 0);
	TextDrawSetProportional(wWheels[0], 1);
	TextDrawSetShadow(wWheels[0], 0);
	TextDrawUseBox(wWheels[0], 1);
	TextDrawBoxColor(wWheels[0], 0);
	TextDrawTextSize(wWheels[0], 190.000000, 10.000000);
	TextDrawSetSelectable(wWheels[0], 0);

	wWheels[1] = TextDrawCreate(88.000000, 168.000000, "mega______________________");
	TextDrawBackgroundColor(wWheels[1], 255);
	TextDrawFont(wWheels[1], 2);
	TextDrawLetterSize(wWheels[1], 0.300000, 1.000000);
	TextDrawColor(wWheels[1], -1);
	TextDrawSetOutline(wWheels[1], 0);
	TextDrawSetProportional(wWheels[1], 1);
	TextDrawSetShadow(wWheels[1], 0);
	TextDrawUseBox(wWheels[1], 1);
	TextDrawBoxColor(wWheels[1], 0);
	TextDrawTextSize(wWheels[1], 170.000000, 10.000000);
	TextDrawSetSelectable(wWheels[1], 0);

	wWheels[2] = TextDrawCreate(88.000000, 190.000000, "rimshine_____________");
	TextDrawBackgroundColor(wWheels[2], 255);
	TextDrawFont(wWheels[2], 2);
	TextDrawLetterSize(wWheels[2], 0.300000, 1.000000);
	TextDrawColor(wWheels[2], -1);
	TextDrawSetOutline(wWheels[2], 0);
	TextDrawSetProportional(wWheels[2], 1);
	TextDrawSetShadow(wWheels[2], 0);
	TextDrawUseBox(wWheels[2], 1);
	TextDrawBoxColor(wWheels[2], 0);
	TextDrawTextSize(wWheels[2], 171.000000, 10.000000);
	TextDrawSetSelectable(wWheels[2], 0);

	wWheels[3] = TextDrawCreate(88.000000, 213.000000, "Wires___________________");
	TextDrawBackgroundColor(wWheels[3], 255);
	TextDrawFont(wWheels[3], 2);
	TextDrawLetterSize(wWheels[3], 0.300000, 1.000000);
	TextDrawColor(wWheels[3], -1);
	TextDrawSetOutline(wWheels[3], 0);
	TextDrawSetProportional(wWheels[3], 1);
	TextDrawSetShadow(wWheels[3], 0);
	TextDrawUseBox(wWheels[3], 1);
	TextDrawBoxColor(wWheels[3], 0);
	TextDrawTextSize(wWheels[3], 171.000000, 10.000000);
	TextDrawSetSelectable(wWheels[3], 0);

	wWheels[4] = TextDrawCreate(88.000000, 233.000000, "classic_________________");
	TextDrawBackgroundColor(wWheels[4], 255);
	TextDrawFont(wWheels[4], 2);
	TextDrawLetterSize(wWheels[4], 0.300000, 1.000000);
	TextDrawColor(wWheels[4], -1);
	TextDrawSetOutline(wWheels[4], 0);
	TextDrawSetProportional(wWheels[4], 1);
	TextDrawSetShadow(wWheels[4], 0);
	TextDrawUseBox(wWheels[4], 1);
	TextDrawBoxColor(wWheels[4], 0);
	TextDrawTextSize(wWheels[4], 170.000000, 10.000000);
	TextDrawSetSelectable(wWheels[4], 0);

	wWheels[5] = TextDrawCreate(87.000000, 254.000000, "twist_____________________");
	TextDrawBackgroundColor(wWheels[5], 255);
	TextDrawFont(wWheels[5], 2);
	TextDrawLetterSize(wWheels[5], 0.300000, 1.000000);
	TextDrawColor(wWheels[5], -1);
	TextDrawSetOutline(wWheels[5], 0);
	TextDrawSetProportional(wWheels[5], 1);
	TextDrawSetShadow(wWheels[5], 0);
	TextDrawUseBox(wWheels[5], 1);
	TextDrawBoxColor(wWheels[5], 0);
	TextDrawTextSize(wWheels[5], 180.000000, 10.000000);
	TextDrawSetSelectable(wWheels[5], 0);

	wWheels[6] = TextDrawCreate(87.000000, 275.000000, "cutter__________________");
	TextDrawBackgroundColor(wWheels[6], 255);
	TextDrawFont(wWheels[6], 2);
	TextDrawLetterSize(wWheels[6], 0.300000, 1.000000);
	TextDrawColor(wWheels[6], -1);
	TextDrawSetOutline(wWheels[6], 0);
	TextDrawSetProportional(wWheels[6], 1);
	TextDrawSetShadow(wWheels[6], 0);
	TextDrawUseBox(wWheels[6], 1);
	TextDrawBoxColor(wWheels[6], 0);
	TextDrawTextSize(wWheels[6], 180.000000, 10.000000);
	TextDrawSetSelectable(wWheels[6], 0);

	wWheels[7] = TextDrawCreate(87.000000, 293.000000, "Dollar__________________");
	TextDrawBackgroundColor(wWheels[7], 255);
	TextDrawFont(wWheels[7], 2);
	TextDrawLetterSize(wWheels[7], 0.300000, 1.000000);
	TextDrawColor(wWheels[7], -1);
	TextDrawSetOutline(wWheels[7], 0);
	TextDrawSetProportional(wWheels[7], 1);
	TextDrawSetShadow(wWheels[7], 0);
	TextDrawUseBox(wWheels[7], 1);
	TextDrawBoxColor(wWheels[7], 0);
	TextDrawTextSize(wWheels[7], 170.000000, 10.000000);
	TextDrawSetSelectable(wWheels[7], 0);

	wWheels[8] = TextDrawCreate(87.000000, 312.000000, "Atomic___________________");
	TextDrawBackgroundColor(wWheels[8], 255);
	TextDrawFont(wWheels[8], 2);
	TextDrawLetterSize(wWheels[8], 0.300000, 1.000000);
	TextDrawColor(wWheels[8], -1);
	TextDrawSetOutline(wWheels[8], 0);
	TextDrawSetProportional(wWheels[8], 1);
	TextDrawSetShadow(wWheels[8], 0);
	TextDrawUseBox(wWheels[8], 1);
	TextDrawBoxColor(wWheels[8], 0);
	TextDrawTextSize(wWheels[8], 170.000000, 10.000000);
	TextDrawSetSelectable(wWheels[8], 0);
	/*------------------------------------------------------------------------------

	• Color • Color • Color • Color • Color • Color • Color • Color • Color • Color

	------------------------------------------------------------------------------*/
	wColor[0] = TextDrawCreate(88.000000, 149.000000, "Black___________________");
	TextDrawBackgroundColor(wColor[0], 255);
	TextDrawFont(wColor[0], 2);
	TextDrawLetterSize(wColor[0], 0.300000, 1.000000);
	TextDrawColor(wColor[0], -1);
	TextDrawSetOutline(wColor[0], 0);
	TextDrawSetProportional(wColor[0], 1);
	TextDrawSetShadow(wColor[0], 0);
	TextDrawUseBox(wColor[0], 1);
	TextDrawBoxColor(wColor[0], 0);
	TextDrawTextSize(wColor[0], 190.000000, 10.000000);
	TextDrawSetSelectable(wColor[0], 0);

	wColor[1] = TextDrawCreate(88.000000, 168.000000, "White____________________");
	TextDrawBackgroundColor(wColor[1], 255);
	TextDrawFont(wColor[1], 2);
	TextDrawLetterSize(wColor[1], 0.300000, 1.000000);
	TextDrawColor(wColor[1], -1);
	TextDrawSetOutline(wColor[1], 0);
	TextDrawSetProportional(wColor[1], 1);
	TextDrawSetShadow(wColor[1], 0);
	TextDrawUseBox(wColor[1], 1);
	TextDrawBoxColor(wColor[1], 0);
	TextDrawTextSize(wColor[1], 170.000000, 10.000000);
	TextDrawSetSelectable(wColor[1], 0);

	wColor[2] = TextDrawCreate(88.000000, 190.000000, "Green___________________");
	TextDrawBackgroundColor(wColor[2], 255);
	TextDrawFont(wColor[2], 2);
	TextDrawLetterSize(wColor[2], 0.300000, 1.000000);
	TextDrawColor(wColor[2], -1);
	TextDrawSetOutline(wColor[2], 0);
	TextDrawSetProportional(wColor[2], 1);
	TextDrawSetShadow(wColor[2], 0);
	TextDrawUseBox(wColor[2], 1);
	TextDrawBoxColor(wColor[2], 0);
	TextDrawTextSize(wColor[2], 171.000000, 10.000000);
	TextDrawSetSelectable(wColor[2], 0);

	wColor[3] = TextDrawCreate(88.000000, 213.000000, "Cyan_____________________");
	TextDrawBackgroundColor(wColor[3], 255);
	TextDrawFont(wColor[3], 2);
	TextDrawLetterSize(wColor[3], 0.300000, 1.000000);
	TextDrawColor(wColor[3], -1);
	TextDrawSetOutline(wColor[3], 0);
	TextDrawSetProportional(wColor[3], 1);
	TextDrawSetShadow(wColor[3], 0);
	TextDrawUseBox(wColor[3], 1);
	TextDrawBoxColor(wColor[3], 0);
	TextDrawTextSize(wColor[3], 171.000000, 10.000000);
	TextDrawSetSelectable(wColor[3], 0);

	wColor[4] = TextDrawCreate(88.000000, 233.000000, "Blue_____________________");
	TextDrawBackgroundColor(wColor[4], 255);
	TextDrawFont(wColor[4], 2);
	TextDrawLetterSize(wColor[4], 0.300000, 1.000000);
	TextDrawColor(wColor[4], -1);
	TextDrawSetOutline(wColor[4], 0);
	TextDrawSetProportional(wColor[4], 1);
	TextDrawSetShadow(wColor[4], 0);
	TextDrawUseBox(wColor[4], 1);
	TextDrawBoxColor(wColor[4], 0);
	TextDrawTextSize(wColor[4], 170.000000, 10.000000);
	TextDrawSetSelectable(wColor[4], 0);

	wColor[5] = TextDrawCreate(87.000000, 254.000000, "Yellow________________");
	TextDrawBackgroundColor(wColor[5], 255);
	TextDrawFont(wColor[5], 2);
	TextDrawLetterSize(wColor[5], 0.300000, 1.000000);
	TextDrawColor(wColor[5], -1);
	TextDrawSetOutline(wColor[5], 0);
	TextDrawSetProportional(wColor[5], 1);
	TextDrawSetShadow(wColor[5], 0);
	TextDrawUseBox(wColor[5], 1);
	TextDrawBoxColor(wColor[5], 0);
	TextDrawTextSize(wColor[5], 180.000000, 10.000000);
	TextDrawSetSelectable(wColor[5], 0);

	wColor[6] = TextDrawCreate(87.000000, 275.000000, "gray_____________________");
	TextDrawBackgroundColor(wColor[6], 255);
	TextDrawFont(wColor[6], 2);
	TextDrawLetterSize(wColor[6], 0.300000, 1.000000);
	TextDrawColor(wColor[6], -1);
	TextDrawSetOutline(wColor[6], 0);
	TextDrawSetProportional(wColor[6], 1);
	TextDrawSetShadow(wColor[6], 0);
	TextDrawUseBox(wColor[6], 1);
	TextDrawBoxColor(wColor[6], 0);
	TextDrawTextSize(wColor[6], 229.000000, 10.000000);
	TextDrawSetSelectable(wColor[6], 0);

	wColor[7] = TextDrawCreate(87.000000, 293.000000, "Pink______________________");
	TextDrawBackgroundColor(wColor[7], 255);
	TextDrawFont(wColor[7], 2);
	TextDrawLetterSize(wColor[7], 0.300000, 1.000000);
	TextDrawColor(wColor[7], -1);
	TextDrawSetOutline(wColor[7], 0);
	TextDrawSetProportional(wColor[7], 1);
	TextDrawSetShadow(wColor[7], 0);
	TextDrawUseBox(wColor[7], 1);
	TextDrawBoxColor(wColor[7], 0);
	TextDrawTextSize(wColor[7], 170.000000, 10.000000);
	TextDrawSetSelectable(wColor[7], 0);

	wColor[8] = TextDrawCreate(87.000000, 312.000000, "Orange________________");
	TextDrawBackgroundColor(wColor[8], 255);
	TextDrawFont(wColor[8], 2);
	TextDrawLetterSize(wColor[8], 0.300000, 1.000000);
	TextDrawColor(wColor[8], -1);
	TextDrawSetOutline(wColor[8], 0);
	TextDrawSetProportional(wColor[8], 1);
	TextDrawSetShadow(wColor[8], 0);
	TextDrawUseBox(wColor[8], 1);
	TextDrawBoxColor(wColor[8], 0);
	TextDrawTextSize(wColor[8], 170.000000, 10.000000);
	TextDrawSetSelectable(wColor[8], 0);
	/*------------------------------------------------------------------------------

	• PaintJob • PaintJob • PaintJob • PaintJob • PaintJob • PaintJob • PaintJob

	------------------------------------------------------------------------------*/
	wPaintJob[0] = TextDrawCreate(88.000000, 149.000000, "PAINTJOB_1");
	TextDrawBackgroundColor(wPaintJob[0], 255);
	TextDrawFont(wPaintJob[0], 2);
	TextDrawLetterSize(wPaintJob[0], 0.300000, 1.000000);
	TextDrawColor(wPaintJob[0], -1);
	TextDrawSetOutline(wPaintJob[0], 0);
	TextDrawSetProportional(wPaintJob[0], 1);
	TextDrawSetShadow(wPaintJob[0], 0);
	TextDrawUseBox(wPaintJob[0], 1);
	TextDrawBoxColor(wPaintJob[0], 0);
	TextDrawTextSize(wPaintJob[0], 190.000000, 10.000000);
	TextDrawSetSelectable(wPaintJob[0], 0);

	wPaintJob[1] = TextDrawCreate(88.000000, 168.000000, "PaintJob_2");
	TextDrawBackgroundColor(wPaintJob[1], 255);
	TextDrawFont(wPaintJob[1], 2);
	TextDrawLetterSize(wPaintJob[1], 0.300000, 1.000000);
	TextDrawColor(wPaintJob[1], -1);
	TextDrawSetOutline(wPaintJob[1], 0);
	TextDrawSetProportional(wPaintJob[1], 1);
	TextDrawSetShadow(wPaintJob[1], 0);
	TextDrawUseBox(wPaintJob[1], 1);
	TextDrawBoxColor(wPaintJob[1], 0);
	TextDrawTextSize(wPaintJob[1], 170.000000, 10.000000);
	TextDrawSetSelectable(wPaintJob[1], 0);

	wPaintJob[2] = TextDrawCreate(88.000000, 190.000000, "PaintJob_3");
	TextDrawBackgroundColor(wPaintJob[2], 255);
	TextDrawFont(wPaintJob[2], 2);
	TextDrawLetterSize(wPaintJob[2], 0.300000, 1.000000);
	TextDrawColor(wPaintJob[2], -1);
	TextDrawSetOutline(wPaintJob[2], 0);
	TextDrawSetProportional(wPaintJob[2], 1);
	TextDrawSetShadow(wPaintJob[2], 0);
	TextDrawUseBox(wPaintJob[2], 1);
	TextDrawBoxColor(wPaintJob[2], 0);
	TextDrawTextSize(wPaintJob[2], 171.000000, 10.000000);
	TextDrawSetSelectable(wPaintJob[2], 0);


	/*------------------------------------------------------------------------------

	• NITRO • NITRO • NITRO • NITRO • NITRO • NITRO • NITRO • NITRO • NITRO • NITRO

	------------------------------------------------------------------------------*/
	wNitro[0] = TextDrawCreate(88.000000, 149.000000, "Nitro 2X");
	TextDrawBackgroundColor(wNitro[0], 255);
	TextDrawFont(wNitro[0], 2);
	TextDrawLetterSize(wNitro[0], 0.300000, 1.000000);
	TextDrawColor(wNitro[0], -1);
	TextDrawSetOutline(wNitro[0], 0);
	TextDrawSetProportional(wNitro[0], 1);
	TextDrawSetShadow(wNitro[0], 0);
	TextDrawUseBox(wNitro[0], 1);
	TextDrawBoxColor(wNitro[0], 0);
	TextDrawTextSize(wNitro[0], 190.000000, 10.000000);
	TextDrawSetSelectable(wNitro[0], 0);

	wNitro[1] = TextDrawCreate(88.000000, 169.000000, "NITRo 5x");
	TextDrawBackgroundColor(wNitro[1], 255);
	TextDrawFont(wNitro[1], 2);
	TextDrawLetterSize(wNitro[1], 0.300000, 1.000000);
	TextDrawColor(wNitro[1], -1);
	TextDrawSetOutline(wNitro[1], 0);
	TextDrawSetProportional(wNitro[1], 1);
	TextDrawSetShadow(wNitro[1], 0);
	TextDrawUseBox(wNitro[1], 1);
	TextDrawBoxColor(wNitro[1], 0);
	TextDrawTextSize(wNitro[1], 170.000000, 10.000000);
	TextDrawSetSelectable(wNitro[1], 0);

	wNitro[2] = TextDrawCreate(88.000000, 190.000000, "nitro 10x");
	TextDrawBackgroundColor(wNitro[2], 255);
	TextDrawFont(wNitro[2], 2);
	TextDrawLetterSize(wNitro[2], 0.300000, 1.000000);
	TextDrawColor(wNitro[2], -1);
	TextDrawSetOutline(wNitro[2], 0);
	TextDrawSetProportional(wNitro[2], 1);
	TextDrawSetShadow(wNitro[2], 0);
	TextDrawUseBox(wNitro[2], 1);
	TextDrawBoxColor(wNitro[2], 0);
	TextDrawTextSize(wNitro[2], 171.000000, 10.000000);

	/*------------------------------------------------------------------------------

	• NEON • NEON • NEON • NEON • NEON • NEON • NEON • NEON • NEON • NEON • NEON •

	------------------------------------------------------------------------------*/
	wNeon[0] = TextDrawCreate(88.000000, 149.000000, "Blue");
	TextDrawBackgroundColor(wNeon[0], 255);
	TextDrawFont(wNeon[0], 2);
	TextDrawLetterSize(wNeon[0], 0.300000, 1.000000);
	TextDrawColor(wNeon[0], -1);
	TextDrawSetOutline(wNeon[0], 0);
	TextDrawSetProportional(wNeon[0], 1);
	TextDrawSetShadow(wNeon[0], 0);
	TextDrawUseBox(wNeon[0], 1);
	TextDrawBoxColor(wNeon[0], 0);
	TextDrawTextSize(wNeon[0], 190.000000, 10.000000);
	TextDrawSetSelectable(wNeon[0], 0);

	wNeon[1] = TextDrawCreate(88.000000, 168.000000, "Yellow");
	TextDrawBackgroundColor(wNeon[1], 255);
	TextDrawFont(wNeon[1], 2);
	TextDrawLetterSize(wNeon[1], 0.300000, 1.000000);
	TextDrawColor(wNeon[1], -1);
	TextDrawSetOutline(wNeon[1], 0);
	TextDrawSetProportional(wNeon[1], 1);
	TextDrawSetShadow(wNeon[1], 0);
	TextDrawUseBox(wNeon[1], 1);
	TextDrawBoxColor(wNeon[1], 0);
	TextDrawTextSize(wNeon[1], 170.000000, 10.000000);
	TextDrawSetSelectable(wNeon[1], 0);

	wNeon[2] = TextDrawCreate(88.000000, 190.000000, "White");
	TextDrawBackgroundColor(wNeon[2], 255);
	TextDrawFont(wNeon[2], 2);
	TextDrawLetterSize(wNeon[2], 0.300000, 1.000000);
	TextDrawColor(wNeon[2], -1);
	TextDrawSetOutline(wNeon[2], 0);
	TextDrawSetProportional(wNeon[2], 1);
	TextDrawSetShadow(wNeon[2], 0);
	TextDrawUseBox(wNeon[2], 1);
	TextDrawBoxColor(wNeon[2], 0);
	TextDrawTextSize(wNeon[2], 171.000000, 10.000000);
	TextDrawSetSelectable(wNeon[2], 0);

	wNeon[3] = TextDrawCreate(88.000000, 213.000000, "Pink");
	TextDrawBackgroundColor(wNeon[3], 255);
	TextDrawFont(wNeon[3], 2);
	TextDrawLetterSize(wNeon[3], 0.300000, 1.000000);
	TextDrawColor(wNeon[3], -1);
	TextDrawSetOutline(wNeon[3], 0);
	TextDrawSetProportional(wNeon[3], 1);
	TextDrawSetShadow(wNeon[3], 0);
	TextDrawUseBox(wNeon[3], 1);
	TextDrawBoxColor(wNeon[3], 0);
	TextDrawTextSize(wNeon[3], 171.000000, 10.000000);
	TextDrawSetSelectable(wNeon[3], 0);

	wNeon[4] = TextDrawCreate(88.000000, 233.000000, "green");
	TextDrawBackgroundColor(wNeon[4], 255);
	TextDrawFont(wNeon[4], 2);
	TextDrawLetterSize(wNeon[4], 0.300000, 1.000000);
	TextDrawColor(wNeon[4], -1);
	TextDrawSetOutline(wNeon[4], 0);
	TextDrawSetProportional(wNeon[4], 1);
	TextDrawSetShadow(wNeon[4], 0);
	TextDrawUseBox(wNeon[4], 1);
	TextDrawBoxColor(wNeon[4], 0);
	TextDrawTextSize(wNeon[4], 170.000000, 10.000000);
	TextDrawSetSelectable(wNeon[4], 0);

	wNeon[5] = TextDrawCreate(88.000000, 252.000000, "remove_neon");
	TextDrawBackgroundColor(wNeon[5], 255);
	TextDrawFont(wNeon[5], 2);
	TextDrawLetterSize(wNeon[5], 0.300000, 1.000000);
	TextDrawColor(wNeon[5], -1);
	TextDrawSetOutline(wNeon[5], 0);
	TextDrawSetProportional(wNeon[5], 1);
	TextDrawSetShadow(wNeon[5], 0);
	TextDrawUseBox(wNeon[5], 1);
	TextDrawBoxColor(wNeon[5], 0);
	TextDrawTextSize(wNeon[5], 170.000000, 10.000000);
	TextDrawSetSelectable(wNeon[5], 0);


	for(new i = 7; i < sizeof(wTuning); i++) { TextDrawSetSelectable(Text:wTuning[i], true); }
	for(new i = 0; i < sizeof(wWheels); i++) { TextDrawSetSelectable(Text:wWheels[i], true); }
	for(new i = 0; i < sizeof(wColor); i++) { TextDrawSetSelectable(Text:wColor[i], true); }
	for(new i = 0; i < sizeof(wPaintJob); i++) { TextDrawSetSelectable(Text:wPaintJob[i], true); }
	for(new i = 0; i < sizeof(wNitro); i++) { TextDrawSetSelectable(Text:wNitro[i], true); }
	for(new i = 0; i < sizeof(wNeon); i++) { TextDrawSetSelectable(Text:wNeon[i], true); }

	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{

	TogglePlayerSpectating(playerid, true);
	InterpolateCameraPos(playerid, 355.597930, -1715.070434, 105.277404, 483.929016, -1476.202514, 97.490631, 30000);
	InterpolateCameraLookAt(playerid, 355.481750, -1710.357788, 103.610702, 479.389251, -1477.755615, 96.084091, 30000);
	GetPlayerName(playerid, DATA_INFO[playerid][nome], MAX_PLAYER_NAME);
	
	new ORM:orm_id = DATA_INFO[playerid][ORMID] = orm_create("contasp", mysql_c);
	orm_addvar_int(orm_id, DATA_INFO[playerid][id], "id");
	orm_addvar_string(orm_id, DATA_INFO[playerid][nome], MAX_PLAYER_NAME, "nome");
	orm_addvar_string(orm_id, DATA_INFO[playerid][senha], MAX_PLAYER_PASSWORD, "senha");
	orm_addvar_int(orm_id, DATA_INFO[playerid][skin], "skin");
	orm_addvar_int(orm_id, DATA_INFO[playerid][dinheiro], "dinheiro");
	orm_addvar_int(orm_id, DATA_INFO[playerid][level], "level");
	orm_addvar_int(orm_id, DATA_INFO[playerid][sexo], "sexo");
	orm_addvar_int(orm_id, DATA_INFO[playerid][admin], "admin");
	orm_addvar_int(orm_id, DATA_INFO[playerid][emprego], "emprego");


	orm_setkey(orm_id, "nome");
	orm_select(DATA_INFO[playerid][ORMID], "OnPlayerDataLoaded", "d", playerid);
	return 1;
}

forward OnPlayerDataLoaded(playerid);
public OnPlayerDataLoaded(playerid)
{
	orm_setkey(DATA_INFO[playerid][ORMID], "id");

	switch(orm_errno(DATA_INFO[playerid][ORMID]))
	{

		case ERROR_OK:
		{
			ContaExiste[playerid] = true;
		}
		case ERROR_NO_DATA:
		{

			ContaExiste[playerid] = false;
		}
	}



	SelectTextDraw(playerid,0x6666FFFF);
	PlayAudioStreamForPlayer(playerid, "http://api.ning.com/files/0GPHyB0EhQnN3LED0k6AWqXoM6HriIP7PX5lQyKmn*ajZBYxZk7VQS1jDM5pc7MzN1nQNuQXhlizz5Ah8cXZlxbeJOjITShT/lXpobJylpHyWe5R5mWlkeZlnqKO");

	for(new i = 0; i < 25; i++){ mensagem(playerid, -1, " "); }
	for(new i = 0; i < sizeof(registro_draw); i++) { TextDrawShowForPlayer(playerid, registro_draw[i]); }
	return 1;
}



public OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 1297, 813.3359, -1331.8828, 15.6406, 0.25);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SalvarPlayerEx(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Relogio[0]), TextDrawShowForPlayer(playerid, Relogio[1]);
	SetPlayerSkin(playerid, DATA_INFO[playerid][skin]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)
	{
		new Comand[128];
		format(Comand, sizeof(Comand), ""c_azul_hex"INFO"c_branco_hex" - O Comando "c_azul_hex"\"%s\""c_branco_hex", não existe.", cmdtext);
		mensagem(playerid, -1, Comand);
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	SetTimerEx("CarGod", 1000, true, "i", playerid);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

CMD:salvarcontas(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=2)
	{
		new cmd_s[128], ContaSalva;

		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if(IsPlayerConnected(i))
		    {
				SalvarPlayerEx(i);
				ContaSalva++;
			}
		}
		format(cmd_s, sizeof(cmd_s), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" Salvou todos os dados das contas online no total de %d. ", GetPlayerCargo(playerid), GetPlayerNameEx(playerid), ContaSalva);
		SendClientMessageToAll(-1, cmd_s);

	}
	return 1;
}

CMD:admins(playerid, params[])
{
	new admin_s[256], admin_d[256], admin_c;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{

		if(DATA_INFO[i][admin] > 0)
		{

			format(admin_s, sizeof(admin_s), ""c_branco_hex"Nome: %s - Cargo: %s\n", GetPlayerNameEx(i), GetPlayerCargo(i));
			strcat(admin_d, admin_s);
			admin_c++;
		}
	}
	format(admin_s, sizeof(admin_s), "%s", admin_c > 0 ? (""c_branco_hex"Existem administradores online.") : (""c_branco_hex"Não existe nenhum adminstrador online no momento."));
	strcat(admin_d, admin_s);

	ShowPlayerDialog(playerid, d_admins_on, DIALOG_STYLE_MSGBOX, ""c_branco_hex"-  Administração Online ", admin_d, "Concluir", "");
	return 1;
}

CMD:apdp(playerid, params[])
{
	if(DATA_INFO[playerid][emprego] == 1 || DATA_INFO[playerid][admin] >= 1 )
	{

		if(IsPlayerInRangeOfPoint(playerid, 10.0, 1548.65955, -1627.60107, 15.04578))
		{

			MoveObject(dp_portao, 1549.30554, -1638.05176, 15.04578, 3.0);
			mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Portão Departamento de Policia aberto.");
			SetTimerEx("fecha_gate", 10000, false, "i", dp_portao);

		}
	}
	return 1;
}


forward fecha_gate(gateid, playerid);
public fecha_gate(gateid, playerid)
{
	if(gateid == dp_portao)
	{

		MoveObject(dp_portao , 1548.65955, -1627.60107, 15.04578, 3.0);
		mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Portão Departamento de Policia fechado.");

	}
	return 1;
}

CMD:settimer(playerid , params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >= 2)
	{

		new set_timer;

		if(sscanf(params, "d", set_timer))
		return mensagem(playerid, -1, ""c_azul_hex"INFO"c_branco_hex" - Utilize: /settimer [hora].");

		SetWorldTime(set_timer);
	}
	return 1;
}

CMD:setadmin(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] == 3)
	{

		new a_recebe, a_cargo;
		if(sscanf(params,"dd", a_recebe, a_cargo))
		return mensagem(playerid, -1, ""c_azul_hex"INFO"c_branco_hex" - Utilize: /setadmin [playerid] [cargo].");

		if( a_cargo > 3 )
		return mensagem(playerid, -1, ""c_azul_hex"INFO"c_branco_hex" - Cargos de 1 a 3.");

		if(!IsPlayerConnected(a_recebe))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- player-id não conectado.");

		DATA_INFO[a_recebe][admin] = a_cargo;
		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O Desenvolvedor "c_azul_hex"%s"c_cinza_hex" setou o player "c_azul_hex"%s"c_cinza_hex" como "c_azul_hex"%s.",GetPlayerNameEx(playerid),GetPlayerNameEx(a_recebe), GetPlayerCargo(a_recebe));
		mensagem_all(-1 , a_cmd);
	}
	return 1;
}

CMD:cv(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=2)
	{

		new veiculo, modelo, c1, c2, Float:pcar[3], Float:A;


		if(sscanf(params, "ddd", modelo, c1, c2))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /cv [modelo] [cor1] [cor2].");


		if( modelo < 400 || modelo > 611 )
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Modelos de veiculos de 400 a 611.");


		GetPlayerPos(playerid, pcar[0], pcar[1], pcar[2]);
		GetPlayerFacingAngle(playerid, A);


		veiculo = CreateVehicle(modelo, pcar[0], pcar[1], pcar[2], A, c1, c2, 0);
		PutPlayerInVehicle(playerid, veiculo, 0);


		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"Você criou o veiculo %d com sucesso.", modelo);
		mensagem_all(-1 , a_cmd);
	}
	return 1;
}

CMD:turbo(playerid)
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1)
	{
	    if(Turbo[playerid] == true) Turbo[playerid] = false, mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Turbo desativado.");
	    else Turbo[playerid] = true, mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Turbo ativado.");
	}
	return 1;
}

CMD:tapa(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1)
	{

		new a_recebe, distancia,  Float:ptapa[3];

		if(sscanf(params,"dd", a_recebe, distancia))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /tapa [player-id] [distancia].");

		if(!IsPlayerConnected(a_recebe))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- player-id não conectado.");

		GetPlayerPos(a_recebe, ptapa[0], ptapa[1], ptapa[2]);
		SetPlayerPos(a_recebe, ptapa[0], ptapa[1], ptapa[2]+distancia);

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" deu tapa em você. ",  GetPlayerCargo(playerid), GetPlayerNameEx(playerid));
		mensagem(a_recebe ,-1, a_cmd);

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"Você deu tapa no jogador "c_azul_hex"%s  ", GetPlayerNameEx(a_recebe));
		mensagem(playerid ,-1, a_cmd);
	}
	return 1;
}

CMD:lc(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1 )
	for(new i = 0; i < 30; i++) mensagem_all(-1, "		 ");
	mensagem_all(-1, ""c_vermelho_hex"Chat Limpo!  ");
	return 1;
}

CMD:matar(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1 )
	{


		new a_recebe;
		if(sscanf(params,"d", a_recebe))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /matar [player-id].");

		if(!IsPlayerConnected(a_recebe))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- player-id não conectado.");

		SetPlayerHealth(a_recebe, 0);

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" matou você. ",  GetPlayerCargo(playerid), GetPlayerNameEx(playerid));
		mensagem(a_recebe ,-1, a_cmd);

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"Você matou o jogador "c_azul_hex"%s  ",  GetPlayerNameEx(a_recebe));
		mensagem(playerid ,-1, a_cmd);
	}
	return 1;
}

CMD:dardinheiro(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1 )
	{


		new a_recebe, a_dinheiro;
		if(sscanf(params,"dd", a_recebe, a_dinheiro))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /dardinheiro [player-id] [dinheiro].");

		if(!IsPlayerConnected(a_recebe))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- player-id não conectado.");

		GivePlayerMoney(a_recebe, a_dinheiro);

		DATA_INFO[a_recebe][dinheiro] =a_dinheiro;

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" deu %dR$ para você. ", GetPlayerCargo(playerid), GetPlayerNameEx(playerid), a_dinheiro);
		mensagem(a_recebe ,-1, a_cmd);

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"Você deu %dR$ para o  jogador "c_azul_hex"%s  ", dinheiro,  GetPlayerNameEx(a_recebe));
		mensagem(playerid ,-1, a_cmd);
	}
	return 1;
}

CMD:dararma(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=2)
    {
        new a_recebe, arma, bala;

		if(sscanf(params, "ddd", a_recebe, arma, bala))
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /dararma [player-id] [arma-id] [munição].");

		if( arma < 1 || arma > 46)
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- arma de 1 a 46.");

	    GivePlayerWeapon(a_recebe, arma, bala);

	    format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" deu a arma %s com %d munição para você. ", GetPlayerCargo(playerid), GetPlayerNameEx(playerid), get_name_arma(arma), bala);
		mensagem(a_recebe ,-1, a_cmd);

		format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"Você deu a arma %s com %d munição para o jogador "c_azul_hex"%s  ", get_name_arma(arma), bala, GetPlayerNameEx(a_recebe));
		mensagem(playerid ,-1, a_cmd);

    }
	return 1;
}


CMD:kitarma(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=2)
    {
        new arma ;

		if(sscanf(params, "d", arma))
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /kitarma [1 - 3].");

		switch(arma)
		{
			case 1:
			{
			    mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Kit Arma 1 setado.");
				GivePlayerWeapon (playerid,  42, 9999), GivePlayerWeapon (playerid,  16, 9999),
				GivePlayerWeapon (playerid,  37, 9999), GivePlayerWeapon (playerid,  34, 9999),
		        GivePlayerWeapon (playerid,  31, 9999), GivePlayerWeapon (playerid,  32, 9999),
		        GivePlayerWeapon (playerid,  26, 9999), GivePlayerWeapon (playerid,  24, 9999),
		        GivePlayerWeapon (playerid,  4,  9999);
		    }
		    case 2:
		    {
		        mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Kit Arma 2 setado.");
		        GivePlayerWeapon (playerid,   9, 9999), GivePlayerWeapon (playerid,  23, 9999),
		        GivePlayerWeapon (playerid,  27, 9999), GivePlayerWeapon (playerid,  29, 9999),
		        GivePlayerWeapon (playerid,  31, 9999), GivePlayerWeapon (playerid,  32, 9999),
		        GivePlayerWeapon (playerid,  36, 9999),	GivePlayerWeapon (playerid,  39, 9999),
		        GivePlayerWeapon (playerid,  44, 9999);
		    }
		    case 3:
		    {

		        mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Kit Arma 3 setado.");
		        GivePlayerWeapon (playerid,   1, 9999),	GivePlayerWeapon (playerid, 5,  999),
		        GivePlayerWeapon (playerid,  22, 9999),	GivePlayerWeapon (playerid, 25, 999),
		        GivePlayerWeapon (playerid,  28, 9999),	GivePlayerWeapon (playerid, 30, 999),
		        GivePlayerWeapon (playerid,  33, 9999),	GivePlayerWeapon (playerid, 35, 999),
		        GivePlayerWeapon (playerid,  41, 9999),	GivePlayerWeapon (playerid, 45, 999),
		        GivePlayerWeapon (playerid,  46, 9999);
		    }
		}
    }
	return 1;
}

CMD:kick(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1)
    {
        new a_recebe, motivo[128];

		if(sscanf(params, "ds[128]", a_recebe, motivo))
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /kick [player-id] [motivo]");

		if(!IsPlayerConnected(a_recebe))
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- playerid não conectado");

		Kick(a_recebe);

	    format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" kickou o jogador %s pelo motivo:%s. ", GetPlayerCargo(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(a_recebe), motivo);
		mensagem_all(-1, a_cmd);

    }
	return 1;
}

CMD:ban(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1)
    {
        new a_recebe, motivo[128];

		if(sscanf(params, "ds[128]", a_recebe, motivo))
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Utilize: /ban [player-id] [motivo]");

		if(!IsPlayerConnected(a_recebe))
  		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- playerid não conectado");

		Ban(a_recebe);

	    format(a_cmd, sizeof(a_cmd), ""c_cinza_hex"O "c_azul_hex"%s "c_azul_hex"%s"c_cinza_hex" baniu o jogador %s pelo motivo:%s. ", GetPlayerCargo(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(a_recebe), motivo);
		mensagem_all(-1, a_cmd);

    }
	return 1;
}

CMD:wtunar(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1)
	{

		new ModelVehicle = GetVehicleModel(GetPlayerVehicleID(playerid));

		if(!IsPlayerInAnyVehicle(playerid))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Você não esta em um veiculo.");

		if(GetModel(ModelVehicle))
		return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Veiculo não pode ser tunado.");

		wTuningDraw[playerid] = true;

		for(new i = 0; i < sizeof(wTuning); i++)	{TextDrawShowForPlayer(playerid, wTuning[i]);}
		for(new i = 0; i < sizeof(wWheels); i++) 	{ TextDrawShowForPlayer(playerid, wWheels[i]); }

		SelectTextDraw(playerid,0x708090FF);
		mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- wTuning Aberto.");

	}
	return 1;
}



CMD:cg(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || DATA_INFO[playerid][admin] >=1)
	{

		if(AtivarCarGod[playerid] == true)
		{
			AtivarCarGod[playerid] = false,
			mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- God Car desativado.");
		}
		else return mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- God Car Ativado.") ,

		AtivarCarGod[playerid] = true,
		SetPlayerHealth(playerid, 999);
	}
	return 1;
}


forward CarGod(playerid);
public CarGod(playerid)
{
	if(AtivarCarGod[playerid] == true)
	{
		SetVehicleHealth(GetPlayerVehicleID(playerid),999999);
		RepairVehicle(GetPlayerVehicleID(playerid));
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}


public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_FIRE)
	{

		if(Turbo[playerid] == true)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{

				new Vehicle = GetPlayerVehicleID(playerid);
				new Float:Velocity[3];
				GetVehicleVelocity(Vehicle, Velocity[0], Velocity[1], Velocity[2]);
				SetVehicleVelocity(Vehicle, Velocity[0]*2, Velocity[1]*2, Velocity[2]);
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{

		case d_login:
		{
			if (response)
			{

				if (strlen(inputtext) < 5 || strlen(inputtext) > 16 && !strlen(inputtext))
				{

					mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Senha incorreta digite sua senha novamente.");
					format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem Vindo ao AHS - Server "c_azul_hex"%s\n\n"c_branco_hex"Você ja tem uma conta registrada no servidor\ndigite sua senha para logar\nseu IP:"c_azul_hex"%s\n\n"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
					ShowPlayerDialog(playerid, d_login, DIALOG_STYLE_PASSWORD, ""c_branco_hex"•  Bem vindo ao AHS - Server  • ", s_dialog, "Logar", "Cancelar");
					return 1;
				}
				if(strcmp(inputtext, DATA_INFO[playerid][senha]) == 0)
				{
					orm_load(DATA_INFO[playerid][ORMID], "OnPlayerLoad", "d", playerid);
				}
				else
				{

					mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- Senha incorreta digite sua senha novamente.");
					format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem Vindo ao AHS - Server "c_azul_hex"%s\n\n"c_branco_hex"Você ja tem uma conta registrada no servidor\ndigite sua senha para logar\nseu IP:"c_azul_hex"%s\n\n"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
					ShowPlayerDialog(playerid, d_login, DIALOG_STYLE_PASSWORD, ""c_branco_hex"•  Bem vindo ao AHS - Server  • ", s_dialog, "Logar", "Cancelar");

					erro_senha[playerid]++;
					if (erro_senha[playerid] == 3)
					{


						format(s_dialog, sizeof(s_dialog), ""c_cinza_hex"O Jogador(a) %s foi Kickado do Servidor | Motivo: Limite de Erro |", GetPlayerNameEx(playerid));
						mensagem_all(-1, s_dialog);
						Kick(playerid);
						return 1;
					}
				}
			}
		}
		case d_registro:
		{

			if (response)
			{

				if (strlen(inputtext) < 5 || strlen(inputtext) > 16 && !strlen(inputtext))
				{

					mensagem(playerid, -1, ""c_azul_hex"INFO "c_branco_hex"- digite uma senha com no minimo 5 caracteres e no maximo 16 caracteres.");
					format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem vindo ao AHS-Server "c_azul_hex"%s "c_branco_hex"Você não tem uma conta no servidor\n\ndigite uma senha para de registrar, sua senha sera usada para logar na proxima vez.\n\nSeu IP:"c_azul_hex" %s"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
					ShowPlayerDialog(playerid, d_registro, DIALOG_STYLE_PASSWORD, ""c_branco_hex"»    Bem vindo ao AHS-Server   « ", s_dialog, "Registrar", "Cancelar");
					return 1;
				}
				format(DATA_INFO[playerid][senha], MAX_PLAYER_PASSWORD, inputtext);

				for(new i = 4; i < sizeof(registro_draw); i++) TextDrawHideForPlayer(playerid, registro_draw[i]);
				for(new i = 0; i < sizeof(sexo_draw); i++) TextDrawShowForPlayer(playerid, sexo_draw[i]);

				return 1;
			}
			else
			{

				format(s_dialog, sizeof(s_dialog), ""c_cinza_hex" O Jogador(a) %s foi Kickado do Servidor | Motivo: N/A Registrou |", GetPlayerNameEx(playerid));
				mensagem_all(-1, s_dialog);
				Kick(playerid);
			}

		}
	}
	return 1;
}

forward OnPlayerLoad(playerid);
public OnPlayerLoad(playerid)
{
    p_Logado[playerid] = true;
    CancelSelectTextDraw(playerid);
	for(new i = 0; i < sizeof(registro_draw); i++) TextDrawHideForPlayer(playerid, registro_draw[i]);
	for(new i = 0; i < sizeof(sexo_draw); i++) TextDrawHideForPlayer(playerid, sexo_draw[i]);

	SpawnPlayer(playerid);
	TogglePlayerSpectating(playerid, 0);

	SetPlayerSkin(playerid, DATA_INFO[playerid][skin]);
	SetPlayerScore(playerid, DATA_INFO[playerid][level]);
	GivePlayerMoney(playerid, DATA_INFO[playerid][dinheiro]);
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
    p_Logado[playerid] = true;
    CancelSelectTextDraw(playerid);
	for(new i = 0; i < sizeof(registro_draw); i++) TextDrawHideForPlayer(playerid, registro_draw[i]);
	for(new i = 0; i < sizeof(sexo_draw); i++) TextDrawHideForPlayer(playerid, sexo_draw[i]);
    TogglePlayerSpectating(playerid, 0);

	SpawnPlayer(playerid);
	SetPlayerSkin(playerid, DATA_INFO[playerid][skin]);
	SetPlayerScore(playerid, DATA_INFO[playerid][level]);
	GivePlayerMoney(playerid, DATA_INFO[playerid][dinheiro]);
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == registro_draw[23])
	{

		if(ContaExiste[playerid]==true)
		{

			format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem Vindo ao AHS - Server "c_azul_hex"%s\n\n"c_branco_hex"Você ja tem uma conta registrada no servidor\ndigite sua senha para logar\nseu IP:"c_azul_hex"%s\n\n"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
			ShowPlayerDialog(playerid, d_login, DIALOG_STYLE_PASSWORD, ""c_branco_hex"•  Bem vindo ao AHS - Server  • ", s_dialog, "Logar", "Cancelar");
		}
		else
		{
  			format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem vindo ao AHS - Server "c_azul_hex"%s\n"c_branco_hex"Você ainda não tem uma conta registrada no servidor\nclique em registrar para criar uma conta no servidor.\nseu IP:"c_azul_hex"%s\n\n"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
			ShowPlayerDialog(playerid, d_registro_aviso, DIALOG_STYLE_MSGBOX, ""c_branco_hex""c_branco_hex"Você ainda não tem um conta no servidor", s_dialog, "Continuar","");
		}
	}
	if(clickedid == registro_draw[24])
	{
		if(ContaExiste[playerid] == true)
		{

            format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem Vindo ao AHS - Server "c_azul_hex"%s\n\n"c_branco_hex"Você ja tem uma conta registrada no servidor "c_azul_hex"%s\n"c_branco_hex"clique em logar para logar em sua conta\nseu IP:"c_azul_hex"%s\n\n"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
			ShowPlayerDialog(playerid, d_registro_aviso, DIALOG_STYLE_MSGBOX, ""c_branco_hex"Você ja tem um conta registra", s_dialog, "Continuar","");
		}
		else
		{

			format(s_dialog, sizeof(s_dialog), ""c_branco_hex"Bem vindo ao AHS - Server "c_azul_hex"%s "c_branco_hex"Você não ainda não tem um conta registrada no servidor %s\n\ndigite uma senha para se registrar, sua senha sera usada para logar na proxima vez. \n\nSeu IP:"c_azul_hex"%s"c_branco_hex"Bom Game.", GetPlayerNameEx(playerid),p_player_ip(playerid));
			ShowPlayerDialog(playerid, d_registro, DIALOG_STYLE_PASSWORD, ""c_branco_hex"•  Bem vindo ao AHS - Server  • ", s_dialog, "Registrar", "Cancelar");
		}
	}
	if(clickedid == registro_draw[25])
	{

		format(s_dialog, sizeof(s_dialog), ""c_cinza_hex"O Jogador %s Resolveu sair do Servidor", GetPlayerNameEx(playerid));
		mensagem_all(-1, s_dialog);
		GameTextForPlayer(playerid, "~", 1000, 6);
	}
	if(clickedid == sexo_draw[13])
	{
        SendClientMessage(playerid, -1, ""c_cinza_hex"INFO"c_branco_hex" - Seu sexo é Masculino.");
		DATA_INFO[playerid][sexo] = p_masculino;
		DATA_INFO[playerid][skin] = s_masculino;
		orm_insert(DATA_INFO[playerid][ORMID], "OnPlayerRegister", "d", playerid);
	}
	if(clickedid == sexo_draw[14])
	{
        SendClientMessage(playerid, -1, ""c_cinza_hex"INFO"c_branco_hex" - Seu sexo é Feminino.");
		DATA_INFO[playerid][sexo] = p_feminino;
		DATA_INFO[playerid][skin] = s_feminino;
		orm_insert(DATA_INFO[playerid][ORMID], "OnPlayerRegister", "d", playerid);

	}

	new wVeiculo = GetPlayerVehicleID(playerid);
	if(clickedid == wTuning[6]) // X CLOSE
	{

		for(new i = 0; i < sizeof(wTuning); i++) 		{ TextDrawHideForPlayer(playerid, wTuning[i]); }
		for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawHideForPlayer(playerid, wWheels[i]); }
		for(new i = 0; i < sizeof(wColor); i++) 		{ TextDrawHideForPlayer(playerid, wColor[i]); }
		for(new i = 0; i < sizeof(wPaintJob); i++) 		{ TextDrawHideForPlayer(playerid, wPaintJob[i]);}
		for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawHideForPlayer(playerid, wNitro[i]); }
		for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawHideForPlayer(playerid, wNeon[i]); }

		wTuningDraw[playerid] = false;
		CancelSelectTextDraw(playerid);
	}

	if(clickedid == wTuning[7]) //WHEELS
	{

		for(new i = 0; i < sizeof(wColor); i++) 		{ TextDrawHideForPlayer(playerid, wColor[i]); }
		for(new i = 0; i < sizeof(wPaintJob); i++)		{ TextDrawHideForPlayer(playerid, wPaintJob[i]);}
		for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawHideForPlayer(playerid, wNitro[i]); }
		for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawHideForPlayer(playerid, wNeon[i]); }
		for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawShowForPlayer(playerid, wWheels[i]); }
	}
	if(clickedid == wTuning[8]) // COLOR
	{

		for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawHideForPlayer(playerid, wWheels[i]); }
		for(new i = 0; i < sizeof(wPaintJob); i++)		{ TextDrawHideForPlayer(playerid, wPaintJob[i]); }
		for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawHideForPlayer(playerid, wNitro[i]); }
		for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawHideForPlayer(playerid, wNeon[i]); }
		for(new i = 0; i < sizeof(wColor); i++) 		{ TextDrawShowForPlayer(playerid, wColor[i]); }

	}
	if(clickedid == wTuning[9]) // PAINTJOBS
	{

		for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawHideForPlayer(playerid, wWheels[i]); }
		for(new i = 0; i < sizeof(wColor); i++) 		{ TextDrawHideForPlayer(playerid, wColor[i]); }
		for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawHideForPlayer(playerid, wNitro[i]); }
		for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawHideForPlayer(playerid, wNeon[i]); }
		for(new i = 0; i < sizeof(wPaintJob); i++)		{ TextDrawShowForPlayer(playerid, wPaintJob[i]); }
	}
	if(clickedid == wTuning[10]) // NITRO
	{

		for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawHideForPlayer(playerid, wWheels[i]); }
		for(new i = 0; i < sizeof(wColor); i++) 		{ TextDrawHideForPlayer(playerid, wColor[i]); }
		for(new i = 0; i < sizeof(wPaintJob); i++)		{ TextDrawHideForPlayer(playerid, wPaintJob[i]); }
		for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawHideForPlayer(playerid, wNeon[i]); }
		for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawShowForPlayer(playerid, wNitro[i]); }
	}
	if(clickedid == wTuning[11]) // HYDRAULICS
	{
		AddVehicleComponent(wVeiculo,1087);
	}
	if(clickedid == wTuning[12]) //NEON
	{

		for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawHideForPlayer(playerid, wWheels[i]); }
		for(new i = 0; i < sizeof(wColor); i++)			{ TextDrawHideForPlayer(playerid, wColor[i]); }
		for(new i = 0; i < sizeof(wPaintJob); i++)		{ TextDrawHideForPlayer(playerid, wPaintJob[i]); }
		for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawHideForPlayer(playerid, wNitro[i]); }
		for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawShowForPlayer(playerid, wNeon[i]); }
	}
	if(clickedid == wTuning[13]) //AUTO TUNING
	{

		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 483)
		{

			AddVehicleComponent(wVeiculo,1027);
			ChangeVehiclePaintjob(wVeiculo, 0);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562)
		{

			AddVehicleComponent(wVeiculo,1046);
			AddVehicleComponent(wVeiculo,1171);
			AddVehicleComponent(wVeiculo,1149);
			AddVehicleComponent(wVeiculo,1035);
			AddVehicleComponent(wVeiculo,1147);
			AddVehicleComponent(wVeiculo,1036);
			AddVehicleComponent(wVeiculo,1040);
			ChangeVehiclePaintjob(wVeiculo, 2);
			ChangeVehicleColor(wVeiculo, 6, 6);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
		{

			AddVehicleComponent(wVeiculo,1028);
			AddVehicleComponent(wVeiculo,1169);
			AddVehicleComponent(wVeiculo,1141);
			AddVehicleComponent(wVeiculo,1032);
			AddVehicleComponent(wVeiculo,1138);
			AddVehicleComponent(wVeiculo,1026);
			AddVehicleComponent(wVeiculo,1027);
			ChangeVehiclePaintjob(wVeiculo, 2);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565)
		{


			AddVehicleComponent(wVeiculo,1046);
			AddVehicleComponent(wVeiculo,1153);
			AddVehicleComponent(wVeiculo,1150);
			AddVehicleComponent(wVeiculo,1054);
			AddVehicleComponent(wVeiculo,1049);
			AddVehicleComponent(wVeiculo,1047);
			AddVehicleComponent(wVeiculo,1051);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 2);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559)
		{

			AddVehicleComponent(wVeiculo,1065);
			AddVehicleComponent(wVeiculo,1160);
			AddVehicleComponent(wVeiculo,1159);
			AddVehicleComponent(wVeiculo,1067);
			AddVehicleComponent(wVeiculo,1162);
			AddVehicleComponent(wVeiculo,1069);
			AddVehicleComponent(wVeiculo,1071);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 1);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561)
		{

			AddVehicleComponent(wVeiculo,1064);
			AddVehicleComponent(wVeiculo,1155);
			AddVehicleComponent(wVeiculo,1154);
			AddVehicleComponent(wVeiculo,1055);
			AddVehicleComponent(wVeiculo,1158);
			AddVehicleComponent(wVeiculo,1056);
			AddVehicleComponent(wVeiculo,1062);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 2);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
		{

			AddVehicleComponent(wVeiculo,1089);
			AddVehicleComponent(wVeiculo,1166);
			AddVehicleComponent(wVeiculo,1168);
			AddVehicleComponent(wVeiculo,1088);
			AddVehicleComponent(wVeiculo,1164);
			AddVehicleComponent(wVeiculo,1090);
			AddVehicleComponent(wVeiculo,1094);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 2);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575)
		{

			AddVehicleComponent(wVeiculo,1044);
			AddVehicleComponent(wVeiculo,1174);
			AddVehicleComponent(wVeiculo,1176);
			AddVehicleComponent(wVeiculo,1042);
			AddVehicleComponent(wVeiculo,1099);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 0);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)
		{

			AddVehicleComponent(wVeiculo,1126);
			AddVehicleComponent(wVeiculo,1179);
			AddVehicleComponent(wVeiculo,1180);
			AddVehicleComponent(wVeiculo,1122);
			AddVehicleComponent(wVeiculo,1101);
			AddVehicleComponent(wVeiculo,1125);
			AddVehicleComponent(wVeiculo,1123);
			AddVehicleComponent(wVeiculo,1100);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 2);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536)
		{

			AddVehicleComponent(wVeiculo,1104);
			AddVehicleComponent(wVeiculo,1182);
			AddVehicleComponent(wVeiculo,1184);
			AddVehicleComponent(wVeiculo,1108);
			AddVehicleComponent(wVeiculo,1107);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 1);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)
		{

			AddVehicleComponent(wVeiculo,1129);
			AddVehicleComponent(wVeiculo,1189);
			AddVehicleComponent(wVeiculo,1187);
			AddVehicleComponent(wVeiculo,1102);
			AddVehicleComponent(wVeiculo,1133);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			ChangeVehiclePaintjob(wVeiculo, 2);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 420)
		{

			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1087);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1139);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 400)
		{

			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1087);
			AddVehicleComponent(wVeiculo,1018);
			AddVehicleComponent(wVeiculo,1013);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1086);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 401)
		{

			AddVehicleComponent(wVeiculo,1086);
			AddVehicleComponent(wVeiculo,1139);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1087);
			AddVehicleComponent(wVeiculo,1012);
			AddVehicleComponent(wVeiculo,1013);
			AddVehicleComponent(wVeiculo,1042);
			AddVehicleComponent(wVeiculo,1043);
			AddVehicleComponent(wVeiculo,1018);
			AddVehicleComponent(wVeiculo,1006);
			AddVehicleComponent(wVeiculo,1007);
			AddVehicleComponent(wVeiculo,1017);
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576)
		{
			ChangeVehiclePaintjob(wVeiculo,2);
			AddVehicleComponent(wVeiculo,1191);
			AddVehicleComponent(wVeiculo,1193);
			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1018);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
			AddVehicleComponent(wVeiculo,1134);
			AddVehicleComponent(wVeiculo,1137);
		}

		else
		{

			AddVehicleComponent(wVeiculo,1010);
			AddVehicleComponent(wVeiculo,1079);
			AddVehicleComponent(wVeiculo,1087);
		}
		return 1;
	}

	/*------------------------------------------------------------------------------

	• Wheels

	------------------------------------------------------------------------------*/
	if(clickedid == wWheels[0]) 	AddVehicleComponent(wVeiculo,1073); 		// SHADOW
	if(clickedid == wWheels[1]) 	AddVehicleComponent(wVeiculo, 1074); 		// MEGA
	if(clickedid == wWheels[2]) 	AddVehicleComponent(wVeiculo,1075); 		// RINSHIME
	if(clickedid == wWheels[3]) 	AddVehicleComponent(wVeiculo,1076); 		// WIRES
	if(clickedid == wWheels[4]) 	AddVehicleComponent(wVeiculo,1077); 		// CLASSIC
	if(clickedid == wWheels[5]) 	AddVehicleComponent(wVeiculo,1078); 		// TWIST
	if(clickedid == wWheels[6]) 	AddVehicleComponent(wVeiculo,1079); 		// CUTTER
	if(clickedid == wWheels[7]) 	AddVehicleComponent(wVeiculo,1083); 		// DOLLAR
	if(clickedid == wWheels[8]) 	AddVehicleComponent(wVeiculo,1085); 		// ATOMIC
	/*------------------------------------------------------------------------------

	• Colors

	------------------------------------------------------------------------------*/
	if(clickedid == wColor[0]) 		ChangeVehicleColor(wVeiculo, 0, 0); 		// BLACK
	if(clickedid == wColor[1]) 		ChangeVehicleColor(wVeiculo, 1, 1); 		// WHITE
	if(clickedid == wColor[2]) 		ChangeVehicleColor(wVeiculo, 128, 128); 	// GREEN
	if(clickedid == wColor[3]) 		ChangeVehicleColor(wVeiculo, 135, 135); 	// CYAN
	if(clickedid == wColor[4]) 		ChangeVehicleColor(wVeiculo, 152, 152); 	// BLUE
	if(clickedid == wColor[5]) 		ChangeVehicleColor(wVeiculo, 6, 6); 		// YELLOW
	if(clickedid == wColor[6]) 		ChangeVehicleColor(wVeiculo, 252, 252); 	// GRAY
	if(clickedid == wColor[7]) 		ChangeVehicleColor(wVeiculo, 146, 146); 	// PINK
	if(clickedid == wColor[8]) 		ChangeVehicleColor(wVeiculo, 219, 219); 	// ORANGE
	/*------------------------------------------------------------------------------

	• PaintJobs

	------------------------------------------------------------------------------*/
	if(clickedid == wPaintJob[0]) 	ChangeVehiclePaintjob(wVeiculo, 0); 		// PAINTJOBS 1
	if(clickedid == wPaintJob[1]) 	ChangeVehiclePaintjob(wVeiculo, 2); 		// PAINTJOBS 2
	if(clickedid == wPaintJob[2]) 	ChangeVehiclePaintjob(wVeiculo, 3); 		// PAINTJOBS 2
	/*------------------------------------------------------------------------------

	• Nitro

	------------------------------------------------------------------------------*/
	if(clickedid == wNitro[0]) 		AddVehicleComponent(wVeiculo,1009);  		// NITRO 1
	if(clickedid == wNitro[1]) 		AddVehicleComponent(wVeiculo,1008); 		// NITRO 2
	if(clickedid == wNitro[2]) 		AddVehicleComponent(wVeiculo,1010); 		// NITRO 3

	if(clickedid == wNeon[0])
	DestroyObject(NEON_P[wVeiculo]), DestroyObject(NEON_S[wVeiculo]),
	NEON_P[wVeiculo] = CreateObject(18648,0,0,0,0,0,0), NEON_S[wVeiculo] = CreateObject(18648,0,0,0,0,0,0),
	AttachObjectToVehicle(NEON_P[wVeiculo], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0),
	AttachObjectToVehicle(NEON_S[wVeiculo], GetPlayerVehicleID(playerid),  0.8, 0.0, -0.70, 0.0, 0.0, 0.0)
	;
	if(clickedid == wNeon[1])
	DestroyObject(NEON_P[wVeiculo]), DestroyObject(NEON_S[wVeiculo]),
	NEON_P[wVeiculo] = CreateObject(18650,0,0,0,0,0,0), NEON_S[wVeiculo] = CreateObject(18650,0,0,0,0,0,0),
	AttachObjectToVehicle(NEON_P[wVeiculo], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0),
	AttachObjectToVehicle(NEON_S[wVeiculo], GetPlayerVehicleID(playerid),  0.8, 0.0, -0.70, 0.0, 0.0, 0.0)
	;
	if(clickedid == wNeon[2])
	DestroyObject(NEON_P[wVeiculo]), DestroyObject(NEON_S[wVeiculo]),
	NEON_P[wVeiculo] = CreateObject(18652,0,0,0,0,0,0), NEON_S[wVeiculo] = CreateObject(18652,0,0,0,0,0,0),
	AttachObjectToVehicle(NEON_P[wVeiculo], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0),
	AttachObjectToVehicle(NEON_S[wVeiculo], GetPlayerVehicleID(playerid),  0.8, 0.0, -0.70, 0.0, 0.0, 0.0)
	;
	if(clickedid == wNeon[3])
	DestroyObject(NEON_P[wVeiculo]), DestroyObject(NEON_S[wVeiculo]),
	NEON_P[wVeiculo] = CreateObject(18651,0,0,0,0,0,0), NEON_S[wVeiculo] = CreateObject(18651,0,0,0,0,0,0),
	AttachObjectToVehicle(NEON_P[wVeiculo], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0),
	AttachObjectToVehicle(NEON_S[wVeiculo], GetPlayerVehicleID(playerid),  0.8, 0.0, -0.70, 0.0, 0.0, 0.0)
	;
	if(clickedid == wNeon[4])
	DestroyObject(NEON_P[wVeiculo]), DestroyObject(NEON_S[wVeiculo]),
	NEON_P[wVeiculo] = CreateObject(18649,0,0,0,0,0,0), NEON_S[wVeiculo] = CreateObject(18649,0,0,0,0,0,0),
	AttachObjectToVehicle(NEON_P[wVeiculo], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0),
	AttachObjectToVehicle(NEON_S[wVeiculo], GetPlayerVehicleID(playerid),  0.8, 0.0, -0.70, 0.0, 0.0, 0.0)
	;

	if(clickedid == wNeon[5]){
		DestroyObject(NEON_P[wVeiculo]), DestroyObject(NEON_S[wVeiculo]);
		return 1;
	}

	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(wTuningDraw[playerid] == true)
		{

			wTuningDraw[playerid] = false;
			for(new i = 0; i < sizeof(wTuning); i++) 		{ TextDrawHideForPlayer(playerid, wTuning[i]); }
			for(new i = 0; i < sizeof(wWheels); i++) 		{ TextDrawHideForPlayer(playerid, wWheels[i]); }
			for(new i = 0; i < sizeof(wColor); i++) 		{ TextDrawHideForPlayer(playerid, wColor[i]); }
			for(new i = 0; i < sizeof(wPaintJob); i++) 		{ TextDrawHideForPlayer(playerid, wPaintJob[i]);}
			for(new i = 0; i < sizeof(wNitro); i++) 		{ TextDrawHideForPlayer(playerid, wNitro[i]); }
			for(new i = 0; i < sizeof(wNeon); i++) 			{ TextDrawHideForPlayer(playerid, wNeon[i]); }
		}
		if(p_Logado[playerid] == false) return SelectTextDraw(playerid, 0x6666FFFF);
	}

	return 1;
}

forward GetModel(Model);
public GetModel(Model)
{
	switch(Model){
		case 417, 425, 430, 432, 446, 447, 448, 452, 453, 454, 460, 461, 462, 463, 464, 465, 468, 469, 471, 472, 473, 476, 481, 484, 487, 488, 493, 497, 501, 509, 510, 511, 512, 513, 521, 522, 523, 548:
		return true;
	}
	return false;
}


stock GetPlayerCargo(playerid)
{
	new a_cargo_name[14];
	switch(DATA_INFO[playerid][admin])
	{

		case 1: a_cargo_name = "Moderador";
		case 2: a_cargo_name = "Administrador";
		case 3: a_cargo_name = "Desenvolvedor";
	}
	return a_cargo_name;
}

stock get_name_arma(arma)
{
	new arma_name[30];

	switch(arma)
	{
	    case 1: arma_name = "Soco inglês";
	    case 2: arma_name =	"Taco de golf";
	    case 3: arma_name =	"Cacetete";
	    case 4: arma_name =	"Faca";
	    case 5: arma_name =	"Taco de Baseball";
	    case 6: arma_name =	"Pa";
	    case 7: arma_name =	"Taco sinuca";
	    case 8: arma_name =	"Katana";
	    case 9: arma_name =	"Serra";
	    case 10..13: arma_name =	"Dildo";
	    case 14: arma_name =	"Flor";
	    case 15: arma_name =	"Bengala";
	    case 16: arma_name =	"Granada";
	    case 17: arma_name =	"Granada Fumaça";
	    case 18: arma_name =	"Granada Fogo";
	    case 22: arma_name =	"9mm";
	    case 23: arma_name =	"Pistola com silenciador";
	    case 24: arma_name =	"Desert Eagle";
	    case 25: arma_name =	"12 Shotgun";
	    case 26: arma_name =	"12 Cano serrado";
	    case 27: arma_name =	"12 Automatica";
	    case 28: arma_name =	"Mac 10";
	    case 29: arma_name =	"Mp5";
	    case 30: arma_name =	"Ak47";
	    case 31: arma_name =	"M4A1";
	    case 32: arma_name =	"Tec 9";
	    case 33: arma_name =	"Espingarda";
	    case 34: arma_name =	"Sniper Rifle";
	    case 35: arma_name =	"Rpg Bazuca";
	    case 36: arma_name =	"Bazuca";
		case 37: arma_name =	"Taca Fogo";
		case 38: arma_name =	"Mini Gun";
		case 39: arma_name =	"Detonador";
		case 41: arma_name =	"Spray";
		case 42: arma_name =	"Extintor";
		case 43: arma_name =	"Camera";
		case 44: arma_name =	"NightVision1";
		case 45: arma_name =	"NightVision2";
		case 46: arma_name =	"Paraquedas";
	}
	return arma_name;
}


forward tempo_real();
public tempo_real()
{
	new t_hora, t_minuto, t_segundos ;

	gettime(t_hora, t_minuto, t_segundos);
	switch(t_hora)
	{

		case 0,1: SetWorldTime(1);
		case 2: SetWorldTime(2);
		case 3: SetWorldTime(3);
		case 4: SetWorldTime(4);
		case 5: SetWorldTime(5);
		case 6: SetWorldTime(6);
		case 7: SetWorldTime(7);
		case 8: SetWorldTime(8);
		case 9: SetWorldTime(9);
		case 10: SetWorldTime(10);
		case 11: SetWorldTime(11);
		case 12: SetWorldTime(12);
		case 13: SetWorldTime(13);
		case 14: SetWorldTime(14);
		case 15: SetWorldTime(15);
		case 16: SetWorldTime(16);
		case 17: SetWorldTime(17);
		case 18: SetWorldTime(20);
		case 19: SetWorldTime(21);
		case 20..23: SetWorldTime(0);
	}
	return 1;
}

forward p_relogio(playerid);
public p_relogio(playerid)
{
	new
	p_hora, p_minuto, p_segundos, p_ano, p_mes, p_dia ;
	new
	s_relogio[128], s_data[128], s_mes[12]	;

	gettime(p_hora, p_minuto, p_segundos);
	getdate(p_ano, p_mes, p_dia);
	switch(p_mes)
	{

		case 1:	s_mes = "Janeiro";
		case 2:	s_mes = "Fevereiro";
		case 3: s_mes = "Marco";
		case 4:	s_mes = "Abril";
		case 5:	s_mes = "Maio";
		case 6:	s_mes = "Junho";
		case 7:	s_mes = "Julho";
		case 8:	s_mes = "Agosto";
		case 9:	s_mes = "Setembro";
		case 10: s_mes = "Outubro";
		case 11: s_mes = "Novembro";
		case 12: s_mes = "Dezembro";

	}

	format(s_data, sizeof(s_data),"%02d de %s de %d", p_dia, s_mes, p_ano);
	format(s_relogio, sizeof(s_relogio),"%02d:%02d:%02d", p_hora, p_minuto, p_segundos);

	TextDrawSetString(Relogio[0], s_data);
	TextDrawSetString(Relogio[1], s_relogio);
	return 1;
}




stock GetPlayerNameEx(playerid)
{
	new name_player[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name_player, MAX_PLAYER_NAME);
	return name_player;
}


stock p_player_ip(playerid)
{
	new ip_player[18];
	GetPlayerIp(playerid, ip_player, 18);
	return ip_player;
}


stock SalvarPlayerEx(playerid)
{
	DATA_INFO[playerid][dinheiro] = GetPlayerMoney(playerid);
	DATA_INFO[playerid][level] = GetPlayerScore(playerid);

	orm_update(DATA_INFO[playerid][ORMID]);
	return 1;
}