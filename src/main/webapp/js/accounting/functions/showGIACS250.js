function showGIACS250(){
	try{
		new Ajax.Request(contextPath + "/GIACCommSlipExtController",{
			parameters: {
				action : "showGIACS250"
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
		showErrorMessage("showGIACS250", e);
	}
}