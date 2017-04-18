function showUpdateInwardRIComm(){
	try{
		new Ajax.Request(contextPath + "/GIPIPolbasicController",{
			parameters : {action : "showUpdateInwardRIComm"},
			onCreate: function(){
				showNotice("Loading page, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUpdateInwardRIComm", e);
	}

}
