function showGIACS150(){
	try{
		new Ajax.Request(contextPath+"/GIACCreditAndCollectionUtilitiesController",{
			method: "POST",
			parameters : {action : "showGIACS150"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					hideAccountingMainMenus();
					$("acExit").show();
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showGIACS150", e);
	}
}