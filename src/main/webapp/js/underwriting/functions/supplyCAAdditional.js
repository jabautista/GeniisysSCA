/*	Created by	: mark jm 01.28.2011
 * 	Description	: Fill-up fields with values in Casualty
 * 	Parameters	: obj - the object that contains the details
 */
function supplyCAAdditional(obj){
	try{		
		$("locationCd").value				= obj == null ? "" : obj.locationCd;
		$("txtLocation").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.location, ""));
		$("selSectionOrHazardCd").value 	= obj == null ? "" : obj.sectionOrHazardCd;
		$("selCapacityCd").value 			= obj == null ? "" : obj.capacityCd;
		$("txtLimitOfLiability").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.limitOfLiability, ""));
		$("txtLocation").value				= obj == null ? "" : unescapeHTML2(nvl(obj.location, ""));
		$("txtLimitOfLiability").value		= obj == null ? "" : unescapeHTML2(nvl(obj.limitOfLiability, ""));
		$("txtInterestOnPremises").value	= obj == null ? "" : unescapeHTML2(nvl(obj.interestOnPremises, ""));
		$("txtSectionOrHazardInfo").value	= obj == null ? "" : unescapeHTML2(nvl(obj.sectionOrHazardInfo, ""));
		$("txtConveyanceInfo").value		= obj == null ? "" : unescapeHTML2(nvl(obj.conveyanceInfo, ""));		
		$("selCapacityCd").value			= obj == null ? "" : obj.capacityCd;
		$("txtPropertyNo").value			= obj == null ? "" : unescapeHTML2(nvl(obj.propertyNo, ""));
		$("selPropertyNoType").value		= obj == null ? "" : obj.propertyNoType;		 
		
		if (obj != null && $F("globalParType") == "E"){ //Added by Jerome 12.01.2016 SR 5606
			var pflSublineCd = objFormParameters.paramSublineCd.split(",");
			
			for (var i=0; i<objPolbasics.length; i++){
				for(var j=0; j<objPolbasics[i].gipiItems.length; j++){
					if(objPolbasics[i].gipiItems[j].itemNo == $F("itemNo")){
						for (var k=0; k<pflSublineCd.length;k++){
						var pflSublineCd2 = pflSublineCd[k];
						
							if ($F("globalSublineCd") == ltrim(pflSublineCd2)){
								if (obj.locationCd == null) {
									$("locationCd").value = "";
									$("locationCd").removeClassName("required");
								} else {
									$("rowLocationCd").show();
									$("locationCd").removeClassName("required");
								}
							    break;
							}
						}
						break;
					} else {
						for (var k=0; k<pflSublineCd.length;k++){
							var pflSublineCd2 = pflSublineCd[k];
							
							if ($F("globalSublineCd") == ltrim(pflSublineCd2)){
								$("rowLocationCd").show();
								$("locationCd").addClassName("required");
								break;
							} else {
								$("btnUpdPropertyFloater").hide();
								$("btnMaintainLocation").hide();
								$("rowLocationCd").hide();
								$("locationCd").removeClassName("required");
							}
						}
					}
				}
			}
		}
		setGroupedItemsForm(null);
		setCasualtyPersonnelForm(null);		
	}catch(e){
		showMessageBox("supplyCAAdditional : " + e.message);
	}
}