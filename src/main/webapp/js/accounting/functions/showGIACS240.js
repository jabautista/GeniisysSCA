function showGIACS240(){
	try{
		new Ajax.Request(contextPath+"/GIACInquiryController",{
			method: "POST",
			parameters : {action : "showGIACS240"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					hideAccountingMainMenus();
					//$("acExit").show();
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showGIACS240", e);
	}
}