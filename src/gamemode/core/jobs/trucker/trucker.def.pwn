enum TruckerGoodsType{
	tNone,
	tLegalGoods,
	tIllegalGoods,
	tLegalFood,
	tLegalClothing,
	tLegal24_7Items,
	tLegalMat,
	tIllegalWeapons,
	tIllegalDrugs,
	tIllegalMaterials
}
enum pTruckDepotInfo
{
	TruckerGoodsType:pGoodType,
	pBizID,
	pTrailerID,
	Float:pTDPosX,
	Float:pTDPosY,
	Float:pTDPosZ,
	pTDName[128],
	pTDLevel
}
new truckerVehicles[30];
new truckersGoods[30][pTruckDepotInfo];
new truckerTrailers[9];

