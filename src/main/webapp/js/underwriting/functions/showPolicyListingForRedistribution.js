/**
 * Shows the overlay containing the list of records 
 * from GIPI_POLBASIC_POL_DIST_V1 for GIUWS012 (Distribution by Peril)
 * Emman 07.19.2011
 */
function showPolicyListingForRedistribution(){
    var contentDiv = new Element("div", {id : "modal_content_polbasicDistV1"});
    var contentHTML = '<div id="modal_content_polbasic"></div>';
    
    winWorkflow = Overlay.show(contentHTML, {
						id: 'modal_dialog_polbasic',
						title: "",
						width: 940,
						height: 400,
						draggable: true
						//closable: true
					});
    
    new Ajax.Updater("modal_content_polbasic", contextPath+"/GIPIPolbasicController?action=showPolicyListingForRedistribution", {
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {			
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}