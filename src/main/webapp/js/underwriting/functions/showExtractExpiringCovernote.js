function showExtractExpiringCovernote(){
	try {
		new Ajax.Request(contextPath + "/ExtractExpiringCovernoteController",{
			method: "POST",
			parameters: {
				action : "showExtractExpiringCovernote"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading Extract Expiring Covernote, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e){
		showErrorMessage("showExtractExpiringCovernote",e);
	}
}