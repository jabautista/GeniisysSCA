function setDistRoadMap(param){
	if(param == "disable"){
		objRoadMapAvail.prelimDist = "INACCESSIBLE";
		objRoadMapAvail.setupGrp   = "INACCESSIBLE";
		objRoadMapAvail.perilDist  = "INACCESSIBLE";
		objRoadMapAvail.oneRiskDist = "INACCESSIBLE";
	}else if(param == "enable"){
		objRoadMapAvail.prelimDist = "AVAILABLE";
		objRoadMapAvail.setupGrp   = "AVAILABLE";
		objRoadMapAvail.perilDist  = "AVAILABLE";
		objRoadMapAvail.oneRiskDist = "AVAILABLE";
	}
}