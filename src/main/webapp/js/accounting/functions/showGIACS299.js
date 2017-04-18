function showGIACS299(){
	try{
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
			method: "POST",
			parameters : {action : "showGIACS299"},
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
		showErrorMessage("showGIACS299", e);
	}
}