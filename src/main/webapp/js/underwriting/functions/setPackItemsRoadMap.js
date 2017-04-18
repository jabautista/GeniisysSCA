function setPackItemsRoadMap(wLineSublineList){
	objRoadMapAvail.itemInfo = "AVAILABLE";
	for(var i=0; i<wLineSublineList.length; i++){
		var lineCd = wLineSublineList[i].packLineCd;
		
		if(lineCd == objLineCds.MC){
			objRoadMapAvail.itemMC = "AVAILABLE";
		}else if(lineCd == objLineCds.FI){
			objRoadMapAvail.itemFI = "AVAILABLE";
		}else if(lineCd == objLineCds.AV){
			objRoadMapAvail.itemAV = "AVAILABLE";
		}else if(lineCd == objLineCds.MN){
			objRoadMapAvail.itemMN = "AVAILABLE";
			objRoadMapAvail.cargoLiab = "AVAILABLE";
			objRoadMapAvail.carrierInfo = "AVAILABLE";
		}else if(lineCd == objLineCds.MH){
			objRoadMapAvail.itemMH = "AVAILABLE";
		}else if(lineCd == objLineCds.CA){
			objRoadMapAvail.itemCA = "AVAILABLE";
			if(paramBBI = wLineSublineList[i].packSublineCd){
				objRoadMapAvail.bankColl = "AVAILABLE";
			}
		}else if(lineCd == objLineCds.AC){
			objRoadMapAvail.itemAC = "AVAILABLE";
		}else if(lineCd == objLineCds.EN){
			objRoadMapAvail.itemEN = "AVAILABLE";
			objRoadMapAvail.engInfo = "AVAILABLE";
		}else if(lineCd == objLineCds.SU){
			objRoadMapAvail.itemSU = "AVAILABLE";
			objRoadMapAvail.bondBasicInfo = "AVAILABLE";
			objRoadMapAvail.collTrans = "AVAILABLE";
		}else if(lineCd == objLineCds.OT){
			objRoadMapAvail.itemOthers = "AVAILABLE";
		};
	};
}