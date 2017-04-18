/**
 * Shows the Foreign Currency canvas in GICLS043
 * @author Veronica V. Raymundo
 * 
 */
function showForeignCurrencyCanvas(){
    var contentDiv = new Element("div", {id : "modal_content_fCurr"});
    var contentHTML = '<div id="modal_content_fCurr"></div>';
    
    winFCurr = Overlay.show(contentHTML, {
					id: 'modal_dialog_fCurr',
					title: "Foreign Currency",
					width: 360,
					height: 165,
					draggable: true
				});
    
    new Ajax.Updater("modal_content_fCurr", contextPath+"/GICLBatchCsrController?action=showForeignCurrAmts", {
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {			
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}