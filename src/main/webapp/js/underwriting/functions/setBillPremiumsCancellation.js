//Added by Apollo Cruz 12.22.2014
function setBillPremiumsCancellation(showMessage,allowUpdateTaxEndtCancellation){		//Gzelle 07272015 SR4819
	
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;//Gzelle 07272015 SR4819
	var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));//Gzelle 07272015 SR4819
	if(objUW.cancelType == null || objUW.cancelType == "")
		return;
	
	if (polFlag == "4" && nvl(allowUpdateTaxEndtCancellation,"N") == "N" && parType == "E"){	//start - Gzelle 07272015 SR4819
		if(showMessage)
			showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.WARNING);
		
		$$("div#billPremiumsMainDiv input[type='text'], textarea").each(function(obj){
			obj.readOnly = true;
		});
		
		$$("div#billPremiumsMainDiv input[type='button']").each(function(obj){		
			if(obj.id != "btnCancel" && obj.id != "btnSave")
				disableButton(obj.id);
		});
		
		$$("div#billPremiumsMainDiv select, input[type='checkbox']").each(function(obj){
			obj.disable();
		});
		
		disableDate("hrefDueDate");
		disableDate("hrefDueDate2");
	}	//end - Gzelle 07272015 SR4819
}