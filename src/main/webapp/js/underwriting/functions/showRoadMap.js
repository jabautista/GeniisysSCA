function showRoadMap(){
    var contentDiv = new Element("div", {id : "modal_content_roadMap"});
    var contentHTML = '<div id="modal_content_roadMap"></div>';
    
    winRoadMap = Overlay.show(contentHTML, {
					id: 'modal_dialog_roadMap',
					title: "Underwriting Transaction Road Map",
					width: 480,
					height: 520,
					draggable: true,
					closable: true
				});
    
    new Ajax.Updater("modal_content_roadMap", contextPath+"/GIPIParInformationController?action=showRoadMap&parId="+$F("globalParId"), {
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {			
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}