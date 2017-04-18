//kenneth L. 11.05.2013
function showGIISS213(){
	try{ 
		new Ajax.Request(contextPath+"/GIISPerilGroupController", {
			method: "GET",
			parameters: {
				action : "showGIISS213"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading Peril Group Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
			}
		});		
	}catch(e){
		showErrorMessage("showGIISS074",e);
	}	
}