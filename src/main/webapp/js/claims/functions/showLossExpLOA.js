function showLossExpLOA(){
	try{
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}
		
		var contentDiv = new Element("div", {id : "modal_content_loa"});
	    var contentHTML = '<div id="modal_content_loa"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_loa',
							title: "Letter of Authority",
							width: 800,
							height: 550,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_loa", contextPath+"/GICLClaimLossExpenseController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showLossExpLOAPage"
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
		showErrorMessage("showLossExpLOA", e);
	}
}