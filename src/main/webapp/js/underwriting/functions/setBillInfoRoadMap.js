function setBillInfoRoadMap(param){
	if(param == "disable"){
		objRoadMapAvail.billInfo = "INACCESSIBLE";
		objRoadMapAvail.discSur  = "INACCESSIBLE";
		objRoadMapAvail.grpItem  = "INACCESSIBLE";
		objRoadMapAvail.billPrem = "INACCESSIBLE";
		objRoadMapAvail.invComm  = "INACCESSIBLE";
	}else if(param == "enable"){
		objRoadMapAvail.billInfo = "AVAILABLE";
		objRoadMapAvail.discSur  = "AVAILABLE";
		objRoadMapAvail.grpItem  = "AVAILABLE";
		objRoadMapAvail.billPrem = "AVAILABLE";
	}
}