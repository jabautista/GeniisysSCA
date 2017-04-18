/**
 * Shows the Detailed Accounting Entries in GICLS043
 * @author Veronica V. Raymundo
 * 
 */
function showBatchCsrAcctEntries(){
	var contentDiv = new Element("div", {id : "modal_content_acctEntries"});
    var contentHTML = '<div id="modal_content_acctEntries"></div>';
    
    winFCurr = Overlay.show(contentHTML, {
					id: 'modal_dialog_acctEntries',
					title: "Detailed Accounting Entries",
					width: 675,
					height: 415,
					draggable: true,
					closable: true
				});
    
    new Ajax.Updater("modal_content_acctEntries", contextPath+"/GICLBatchCsrController?action=getGiclAcctEntriesTableGrid&ajax=1&adviceId="+nvl($F("hidCurrAdviceId"), 0)+"&claimId="+nvl($F("hidCurrClaimId"), 0) + "&refId="+nvl(objBatchCsr.referenceId, ''), {
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {			
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}