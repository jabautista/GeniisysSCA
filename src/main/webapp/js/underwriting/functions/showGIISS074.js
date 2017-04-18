//john dolon 11.05.2013
function showGIISS074(){
	try{ 
		new Ajax.Request(contextPath+"/GIISRiTypeDocsController", {
			method: "GET",
			parameters: {
				action : "showGIISS074"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Reinsurance Document Type Maintenance, please wait...");
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