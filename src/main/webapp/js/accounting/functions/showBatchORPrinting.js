function showBatchORPrinting(){
	try{
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController",{
			parameters: {
				action : "showBatchORPrinting"
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
		showErrorMessage("showBatchORPrinting", e);
	}
}