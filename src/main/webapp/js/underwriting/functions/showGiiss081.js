function showGiiss081(){
	try{ 
		new Ajax.Request(contextPath+"/GIISModuleController", {
			method: "GET",
			parameters: {
				action : "showGiiss081"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Geniisys Modules Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss081",e);
	}	
}