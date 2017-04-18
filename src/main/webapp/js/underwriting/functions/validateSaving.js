//belle 09082011
function validateSaving(refresh) {
	var perilChanges = getAddedAndModifiedJSONObjects(objGIPIWItemPeril);
	var lineCd = getLineCd(objUWGlobal.lineCd);		//moved here by Gzelle 05252015 SR4347
	
	if (lineCd == 'FI' && $("zoneDiv").hasAttribute("zoned")) {	//Gzelle 05252015 SR4347
		customShowMessageBox(objCommonMessage.REQUIRED, "I","eqZoneDesc");
		return false;
	}
	
	if(checkPendingRecordChanges ()){
		if (objDefaultPerilAmts.deleteWitemPerilTariff) {	//added by Gzelle 12022014
			deleteWitemPerilTariff($F("itemNo"),"item");
		}else if (objDefaultPerilAmts.updateWithTariffSw) {
			updateWithTariffSw();
		}
		if($$("div#addItemPerilContainerDiv [changed=changed]").length > 0){
			return false;			
		} else if (/*perilChanges != null*/ perilChanges.length > 0) { // condition modified by: Nica 05.16.2012
			var paramOra2010Sw = nvl(objFormParameters.paramOra2010Sw, "N"); // added another object which holds the value of the ORA2010SW parameter
			var ora2010Sw = $("ora2010Sw") != null ? $("ora2010Sw").value : "N";
			if(paramOra2010Sw == "Y" || ora2010Sw == "Y"){
				updateMinPremFlag = "Y";
				validatePremiumAmount(refresh);
			}else{
				updateMinPremFlag = "N";
				checkIfBinderExists(refresh);
			}
		}else{ // Nica 05.16.2012
			//var lineCd = getLineCd(objUWGlobal.lineCd);	Gzelle 05252015 SR4347
			if (lineCd == 'AV'){
				saveAviationItems(refresh);
			}else if (lineCd == 'CA') {
				saveCasualtyItems(refresh);
			}else if (lineCd == 'EN') {
				saveENItems(refresh);
			}else if (lineCd == 'FI'){
				saveFireItems(refresh);
			}else if (lineCd == 'MC'){
				saveVehicleItems(refresh);
			}else if (lineCd == 'MH'){
				saveMHItems(refresh);
			}else if (lineCd == 'MN'){
				saveMarineCargoItems(refresh);
			}else if (lineCd == 'AC'){
				saveAHItem(refresh);
			}
		}
	}
}