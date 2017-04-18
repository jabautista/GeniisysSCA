function showLossExpDeductibles(){
	try{
		var contentDiv = new Element("div", {id : "modal_content_deductibles"});
	    var contentHTML = '<div id="modal_content_deductibles"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_deductibles',
							title: "Deductibles",
							width: 910,
							height: 450,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_deductibles", contextPath+"/GICLLossExpDtlController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showLossExpDeductibles"
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
		showErrorMessage("showLossExpDeductibles", e);
	}
}