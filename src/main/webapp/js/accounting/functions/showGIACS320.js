function showGIACS320(){
	try{
		new Ajax.Request(contextPath + "/GIACTaxesController",{
			parameters: {
				action : "showGIACS320"
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
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIACS320", e);
	}
}