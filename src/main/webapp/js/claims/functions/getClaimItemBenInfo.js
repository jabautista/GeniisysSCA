//belle 02.01.2012 get beneficiary info 
function getClaimItemBenInfo(){
	try{
		if ($("groBenInfo").innerHTML == "Show" || nvl(objCLMItem.selItemIndex,null) == null) return false;
		new Ajax.Updater("benInfoDiv", contextPath+"/GICLAccidentDtlController",{
			parameters:{
				action: "getItemBeneficiaryDtl",
				claimId: objCLMGlobal.claimId,
				itemNo: $F("txtItemNo"),
				groupedItemNo: $F("txtGrpItemNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}
			}
		});
	}catch(e){
		showErrorMessage("getBenInfo", e);
	}
}