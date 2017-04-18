function setMCItemObject(newObj){
	try{
		var gipiWVehicle = new Object();
		
		gipiWVehicle.assignee 			= escapeHTML2($F("assignee"));
		gipiWVehicle.acquiredFrom		= escapeHTML2($F("acquiredFrom"));
		gipiWVehicle.motorNo			= escapeHTML2($F("motorNo"));
		gipiWVehicle.origin				= escapeHTML2($F("origin"));
		gipiWVehicle.destination		= escapeHTML2($F("destination"));
		gipiWVehicle.typeOfBodyCd		= nvl($F("typeOfBody"), null);
		gipiWVehicle.plateNo			= escapeHTML2(nvl($F("plateNo").trim(), null)); //added by steven 05.10.2013: escapeHTML2
		gipiWVehicle.modelYear			= nvl($F("modelYear"), null);
		gipiWVehicle.carCompanyCd		= nvl($F("carCompanyCd"), null);
		gipiWVehicle.mvFileNo			= escapeHTML2(nvl($F("mvFileNo"), null));
		gipiWVehicle.noOfPass			= nvl($F("noOfPass"), null);
		gipiWVehicle.makeCd				= nvl($F("makeCd"), null);
		gipiWVehicle.basicColorCd		= nvl($F("basicColorCd"), null);
		gipiWVehicle.colorCd			= nvl($F("colorCd"), null);
		gipiWVehicle.seriesCd			= nvl($F("seriesCd"), null);
		gipiWVehicle.motType			= nvl($F("motorType"), null);
		gipiWVehicle.unladenWt			= escapeHTML2(nvl($F("unladenWt"), null));
		gipiWVehicle.towing				= nvl($F("towLimit"), null);
		gipiWVehicle.serialNo			= nvl(escapeHTML2($F("serialNo")), null); //added by steven 07.06.2012: escapeHTML2
		gipiWVehicle.sublineTypeCd		= nvl($F("sublineType"), null);
		gipiWVehicle.deductibleAmount	= nvl($F("deductibleAmount"), null);
		gipiWVehicle.cocType			= nvl($F("cocType"), null);
		gipiWVehicle.cocSerialNo		= nvl($F("cocSerialNo"), null);
		gipiWVehicle.cocYy				= nvl($F("cocYy"), null);
		gipiWVehicle.ctvTag				= $("ctv").checked ? 'Y' : 'N';
		gipiWVehicle.repairLim			= nvl($F("repairLimit"), null);
		gipiWVehicle.motorCoverage		= nvl($F("motorCoverage"), null);
		gipiWVehicle.sublineCd			= nvl((objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")), null);
		gipiWVehicle.cocSerialSw		= $("cocSerialSw").checked ? "Y" : "N";			
		gipiWVehicle.estValue			= 0;
		gipiWVehicle.tariffZone			= null;
		gipiWVehicle.cocIssueDate		= null;
		gipiWVehicle.cocSeqNo			= null;
		gipiWVehicle.cocAtcn			= null;
		gipiWVehicle.carCompany			= escapeHTML2($F("carCompany"));
		gipiWVehicle.make				= escapeHTML2($F("make"));//$("makeCd").options[$("makeCd").selectedIndex].text;
		gipiWVehicle.engineSeries		= escapeHTML2($F("engineSeries"));
		gipiWVehicle.color				= escapeHTML2($F("color"));//$F("colorCd");//$("colorCd").options[$("colorCd").selectedIndex].text;	//Gzelle 05282015 added escapeHTML2 SR4302
		
		if(objUWParList != null && objUWParList.parType != 'E') {
			gipiWVehicle.regType			= escapeHTML2($F("regType"));
			gipiWVehicle.mvType				= escapeHTML2($F("mvType"));
			gipiWVehicle.mvTypeDesc			= escapeHTML2($F("mvTypeDesc"));
			gipiWVehicle.mvPremType			= escapeHTML2($F("mvPremType"));
			gipiWVehicle.mvPremTypeDesc		= escapeHTML2($F("mvPremTypeDesc"));
		}
		
		newObj.gipiWVehicle = gipiWVehicle;
		
		return newObj;
	}catch(e){
		showErrorMessage("setMCItemObject", e);		
	}
}