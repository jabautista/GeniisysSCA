function setCoInsuranceRoadMap(coInsuranceSw){
	if(coInsuranceSw == 2){
		objRoadMapAvail.coInsurance = "AVAILABLE";
		objRoadMapAvail.coInsurer   = "AVAILABLE";
		objRoadMapAvail.leadPol  	= "AVAILABLE";
	}else if(coInsuranceSw == 3){
		objRoadMapAvail.coInsurance = "AVAILABLE";
		objRoadMapAvail.coInsurer   = "AVAILABLE";
		objRoadMapAvail.leadPol  	= "INACCESSIBLE";
	}else{
		objRoadMapAvail.coInsurance = "INACCESSIBLE";
		objRoadMapAvail.coInsurer   = "INACCESSIBLE";
		objRoadMapAvail.leadPol  	= "INACCESSIBLE";
	}
}