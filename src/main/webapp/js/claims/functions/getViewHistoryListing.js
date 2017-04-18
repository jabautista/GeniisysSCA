function getViewHistoryListing(copySw){
	try{
		var contentDiv = new Element("div", {id : "modal_content_viewHist"});
	    var contentHTML = '<div id="modal_content_viewHist"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_viewHist',
							title: "View History",
							width:  920,
							height: 250,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_viewHist", contextPath+"/GICLClaimLossExpenseController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "getViewHistoryListing",
				ajax : "1",
				claimId: nvl(objCurrGICLLossExpPayees.claimId, 0),
				lineCd : objCLMGlobal.lineCd,
				payeeType : objCurrGICLLossExpPayees.payeeType,
				payeeClassCd : objCurrGICLLossExpPayees.payeeClassCd,
				payeeCd : objCurrGICLLossExpPayees.payeeCd,
				itemNo : objCurrGICLLossExpPayees.itemNo,
				perilCd : objCurrGICLLossExpPayees.perilCd,
				copySw: nvl(copySw, "N")
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
	} catch(e){
		showErrorMessage("getViewHistoryListing", e);
	}
}