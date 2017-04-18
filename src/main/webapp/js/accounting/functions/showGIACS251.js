function showGIACS251(){
	try{
		new Ajax.Request(contextPath + "/GIACCommissionVoucherController",{
			parameters: {
				action : "showBatchCommVoucherPrinting"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					hideAccountingMainMenus();
					$("mainNav").hide();
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIACS251", e);
	}
}