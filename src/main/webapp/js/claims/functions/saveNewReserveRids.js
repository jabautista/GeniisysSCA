function saveNewReserveRids(){
	try{
		new Ajax.Request(contextPath + "/GICLClaimReserveController?action=saveReserveRids", {
			method: "POST",
			parameters:{
				claimId: objCLMGlobal.claimId,
				lineCd: objCLMGlobal.lineCd,
				clmResHistId: objCurrGICLClmResHist.clmResHistId,
				clmDistNo: "1", 
				grpSeqNo: "1",
				distYear: $F("distYearTxt"), 
				perilCd: objCurrGICLClmResHist.perilCd, 
				histSeqNo: objCurrGICLClmResHist.histSeqNo, 
				shareType: "1",
				shrPct: $F("shrPctTxt"), 
				shrLossResAmt: $F("shrLossResAmtTxt"), 
				shrExpResAmt: $F("shrExpResAmtTxt"), 
				cpiRecNo: "1",	
				groupedItemNo: nvl(objCurrGICLClmResHist.groupedItemNo, 0),
				cpiBranchCd: "1"	
			}, 
			asynchronous: false,
			evalJS: true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("saveReserveDs", e);
	}
}