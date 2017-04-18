/*	Created by	: mark jm 02.04.2011
 * 	Description	: set default values for fire additional form
 */
function setFIAddlFormDefault(){
	try{		
		if(objFormMiscVariables.miscDisplayRisk == "Y"){
			$("riskCell1").show();
			$("riskCell2").show();
		}
		
		$("riskNo").value		= "1";
		$("riskItemNo").value 	= getNextRiskItemNoFromObj($F("riskNo"));
		
		$("locRisk1").value	= unescapeHTML2(nvl(objFormMiscVariables.miscLocRisk1, ""));
		$("locRisk2").value	= unescapeHTML2(nvl(objFormMiscVariables.miscLocRisk2, ""));
		$("locRisk3").value	= unescapeHTML2(nvl(objFormMiscVariables.miscLocRisk3, ""));		
		
		$("risk").addClassName(objFormParameters.paramParam1 == "Y" ? "required" : "");
		$("construction").addClassName(objFormParameters.paramParam2 == "Y" ? "required" : "");
		$("occupancy").addClassName(objFormParameters.paramParam3 == "Y" ? "required" : "");
		$("riskNo").addClassName(objFormParameters.paramParam4 == "Y" ? "required" : "");
		$("frItemType").addClassName(objFormParameters.paramParam5 == "Y" ? "required" : "");
		
		if($("risk").hasClassName("required")){
			($("risk").up("div", 0)).addClassName("required");
		}
		
		if($("occupancy").hasClassName("required")){
			($("occupancy").up("div", 0)).addClassName("required");
		}
		
		//Gzelle 05252015 SR4347
		$("eqZoneDesc").removeClassName("required");
		$("eqZoneDesc").up("div", 0).removeClassName("required");
		$("typhoonZoneDesc").removeClassName("required");
		$("typhoonZoneDesc").up("div", 0).removeClassName("required");
		$("floodZoneDesc").removeClassName("required");
		$("floodZoneDesc").up("div", 0).removeClassName("required");
		//end
	}catch(e){
		showErrorMessage("setFIAddlFormDefault", e);
		//showMessageBox("setFIForm : " + e.message);
	}
}