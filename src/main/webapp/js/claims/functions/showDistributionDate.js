function showDistributionDate(){
	try{
		var contentDiv = new Element("div", {id : "modal_content_distDate"});
	    var contentHTML = '<div id="modal_content_distDate"></div>';
	    
	    lossExpHistWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_distDate',
							title: "Distribution Date",
							width: 300,
							height: 120,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_distDate", contextPath+"/GICLLossExpDsController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showDistributionDate",
				distDate: $("hidDfltDistDate").value
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
		showErrorMessage("showCancelledAdviceList", e);
	}
}