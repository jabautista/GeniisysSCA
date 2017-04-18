function showGiiss169(){
	try{ 
		new Ajax.Request(contextPath+"/GIISInspectorController", {
			method: "GET",
			parameters: {
				action : "showGiiss169"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Inspector Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss169",e);
	}
}