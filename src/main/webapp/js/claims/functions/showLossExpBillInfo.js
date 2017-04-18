function showLossExpBillInfo(){
	try{
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees == null){
			showMessageBox("Please select a payee first.", "I");
			return false;
		}else if(objCurrGICLClmLossExpense == null){
			showMessageBox("Please select a history record first.", "I");
			return false;
		}
		
		var contentDiv = new Element("div", {id : "modal_content_bill"});
	    var contentHTML = '<div id="modal_content_bill"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_bill',
							title: "Bill Information",
							width: 900,
							height: 440,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_bill", contextPath+"/GICLLossExpBillController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showLossExpBillInfo",
				claimId: nvl(objCurrGICLClmLossExpense.claimId, 0),
				clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0)
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
		showErrorMessage("showLossExpBillInfo", e);
	}
}