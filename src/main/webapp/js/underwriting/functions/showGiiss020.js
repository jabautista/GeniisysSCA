function showGiiss020(){
	try{ 
		new Ajax.Request(contextPath+"/GIISSectionOrHazardController", {
			method: "GET",
			parameters: {
				action : "showGiiss020",
				moduleId : "GIISS020",
				fromMenu : "Y"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					hideNotice("");
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss020",e);
	}	
}