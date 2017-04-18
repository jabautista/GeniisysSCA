/**
 * Shows Policy Type Maintenance Page
 * Module: GIISS091 - Policy Type Maintenance
 * @author J. Diago
 * */
function showGiiss091(){
	try{ 
		new Ajax.Request(contextPath+"/GIISPolicyTypeController", {
			method: "GET",
			parameters: {
				action : "showGiiss091"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Policy Type Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss091",e);
	}	
}