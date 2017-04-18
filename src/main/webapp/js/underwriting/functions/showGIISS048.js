//john dolon 10.22.2013
function showGIISS048(){
	try{ 
		new Ajax.Request(contextPath+"/GIISAirTypeController", {
			method: "GET",
			parameters: {
				action : "showGIISS048"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Aircraft Type Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				$("acExit").show();
			}
		});		
	}catch(e){
		showErrorMessage("showGIISS048",e);
	}	
}