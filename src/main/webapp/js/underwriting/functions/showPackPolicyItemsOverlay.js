function showPackPolicyItemsOverlay(){
    var contentDiv = new Element("div", {id : "modal_content_polItems"});
    var contentHTML = '<div id="modal_content_polItems"></div>';
    
    window = Overlay.show(contentHTML, {
						id: 'modal_dialog_polItems',
						title: "List of Policy Items",
						width: 640,
						height: 410,
						draggable: true,
						closable: true
					});
    
    new Ajax.Updater("modal_content_polItems", contextPath+"/GIPIWItemController", {
		evalScripts: true,
		asynchronous: false,
		parameters: {
    		action : "getPackPolicyItemsList",
    		lineCd : objUWGlobal.lineCd,
    		issCd  : objGIPIWPolbas.issCd,
    		sublineCd : objGIPIWPolbas.sublineCd,
    		issueYy  : objGIPIWPolbas.issueYy,
    		polSeqNo : objGIPIWPolbas.polSeqNo,
    		renewNo  : objGIPIWPolbas.renewNo,
    		effDate  : objGIPIWPolbas.effDate,
    		expiryDate : objGIPIWPolbas.expiryDate
    	},
		onComplete: function (response) {			
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}