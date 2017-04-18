//john dolon 10.31.2013
function showGIISS117(){
	try{ 
		new Ajax.Request(contextPath+"/GIISTypeOfBodyController", {
			method: "GET",
			parameters: {
				action : "showGIISS117"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Car Type of Body Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
			}
		});		
	}catch(e){
		showErrorMessage("showGIISS117",e);
	}	
}