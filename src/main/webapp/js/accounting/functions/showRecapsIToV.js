function showRecapsIToV(){
	try{
		new Ajax.Request(contextPath + "/GIACRecapDtlExtController",{
			parameters: {
				action : "showRecapsI-V"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
				$("acExit").show();
			}
		});
	}catch(e){
		showErrorMessage("showRecapsIToV", e);
	}
}