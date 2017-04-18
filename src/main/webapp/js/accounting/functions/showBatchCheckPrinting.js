function showBatchCheckPrinting(){
	try{
		new Ajax.Request(contextPath+"/GIACChkDisbursementController",{
			parameters: {
				action : "showCheckBatchPrinting"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					hideAccountingMainMenus();
					$("mainNav").hide();
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showBatchCheckPrinting", e);
	}
}
