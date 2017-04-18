/**
 * Shows Vessel Type Maintenance Page
 * Module: GIISS077 - Vessel Type Maintenance
 * @author J. Diago
 * */
function showGiiss077(){
	try{ 
		new Ajax.Request(contextPath+"/GIISVesTypeController", {
			method: "GET",
			parameters: {
				action : "showGiiss077"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Vessel Type Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss077",e);
	}	
}