/**
 * Shows the overlay containing the list of records 
 * from GIPI_POLBASIC_POL_DIST_V1
 *
 */
function showPolbasicPolDistV1Listing(action){
	action = nvl(action, "showPolbasicPolDistV1Listing"); //added by Nok to reuse this function 08.11.2011
    var contentDiv = new Element("div", {id : "modal_content_polbasicDistV1"});
    var contentHTML = '<div id="modal_content_polbasicDistV1"></div>';
    
    winWorkflow = Overlay.show(contentHTML, {
						id: 'modal_dialog_polbasicDistV1',
						title: "",
						width: 940,
						height: 400,
						draggable: true
						//closable: true
					});
    
    new Ajax.Updater("modal_content_polbasicDistV1", contextPath+"/GIPIPolbasicPolDistV1Controller?action="+action, {
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting list, please wait...");
		},
		onComplete: function (response) {
			hideNotice();
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}