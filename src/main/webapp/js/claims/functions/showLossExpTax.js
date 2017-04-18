function showLossExpTax(){
	try{
		var contentDiv = new Element("div", {id : "modal_content_tax"});
	    var contentHTML = '<div id="modal_content_tax"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_tax',
							title: "Loss/Expense Tax",
							width: 900,
							height: 460,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_tax", contextPath+"/GICLLossExpTaxController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showLossExpTax",
				claimId: nvl(objCurrGICLClmLossExpense.claimId, 0),
				clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0),
				payeeClassCd: objCurrGICLLossExpPayees.payeeClassCd,
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (!checkErrorOnResponse(response)){
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	} catch(e){
		showErrorMessage("showLossExpTax", e);
	}
}