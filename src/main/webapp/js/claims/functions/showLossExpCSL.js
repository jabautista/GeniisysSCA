function showLossExpCSL(){
	try{
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}
		
		var contentDiv = new Element("div", {id : "modal_content_csl"});
	    var contentHTML = '<div id="modal_content_csl"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_csl',
							title: "Cash Settlement Confirmation",
							width: 800,
							height: 620,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_csl", contextPath+"/GICLClaimLossExpenseController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showLossExpCSLPage"
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
		showErrorMessage("showLossExpCSL", e);
	}
}