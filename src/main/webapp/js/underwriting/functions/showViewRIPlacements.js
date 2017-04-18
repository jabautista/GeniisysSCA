function showViewRIPlacements(){
	try{
		new Ajax.Request(contextPath+"/GIRIBinderController",{
			parameters: {
				action: "showViewRIPlacements"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showViewRIPlacements", e);
	}
}