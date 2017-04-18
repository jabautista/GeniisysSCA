function showLossExpDeductibleDetails(){
	try{
		var contentDiv = new Element("div", {id : "modal_content_ded_dtl"});
	    var contentHTML = '<div id="modal_content_ded_dtl"></div>';
	    
	    lossExpHistWin2 = Overlay.show(contentHTML, {
							id: 'modal_dialog_ded_dtl',
							title: "Deductible Details",
							width: 630,
							height: 300,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_ded_dtl", contextPath+"/GICLLossExpDedDtlController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "getGiclLossExpDedDtlList",
				claimId: nvl(objCurrLossExpDeductibles.claimId, 0),
				clmLossId: nvl(objCurrLossExpDeductibles.clmLossId, 0),
				lossExpCd: nvl(objCurrLossExpDeductibles.lossExpCd, ""),
				payeeType : nvl(objCurrLossExpDeductibles.payeeType, ""),
				lineCd : objCLMGlobal.lineCd,
				sublineCd: nvl(objCurrLossExpDeductibles.sublineCd, ""),
				ajax : "1"
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function (response) {
				hideNotice();
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("showLossExpDeductibleDetails", e);
	}
}