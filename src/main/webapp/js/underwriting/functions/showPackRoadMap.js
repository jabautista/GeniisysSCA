function showPackRoadMap(){
	try{
	    var contentDiv = new Element("div", {id : "modal_content_roadMap"});
	    var contentHTML = '<div id="modal_content_roadMap"></div>';
	    var packParId = nvl(objUWGlobal.packParId, nvl(objUWParList.packParId, $F("globalPackParId"))); 
	    
	    winRoadMap = Overlay.show(contentHTML, {
						id: 'modal_dialog_roadMap',
						title: "Underwriting Transaction Road Map",
						width: 500,
						height: 530,
						draggable: true,
						closable: true
					});
	    
	    new Ajax.Updater("modal_content_roadMap", contextPath+"/GIPIPackParInformationController?action=showPackRoadMap&packParId="+packParId, {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("showPackRoadMap", e);
	}
}