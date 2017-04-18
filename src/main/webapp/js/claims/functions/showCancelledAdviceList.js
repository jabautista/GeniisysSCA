function showCancelledAdviceList(){
	try{
		var contentDiv = new Element("div", {id : "modal_content_cancelledAdvice"});
	    var contentHTML = '<div id="modal_content_cancelledAdvice"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_cancelledAdvice',
							title: "List of Cancelled Advice",
							width: 535,
							height: 250,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_cancelledAdvice", contextPath+"/GICLAdviceController?action=getCancelledAdviceList&ajax=1&claimId="+nvl(objCLMGlobal.claimId, 0), {
			evalScripts: true,
			asynchronous: false,
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
		showErrorMessage("showCancelledAdviceList", e);
	}
}