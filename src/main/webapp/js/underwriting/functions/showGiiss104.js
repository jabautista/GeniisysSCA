/**
 * Shows Endorsement Text Maintenance Page
 * Module: GIISS104 - Endorsement Text Maintenance
 * @author J. Diago
 * */
function showGiiss104(){
	try{ 
		new Ajax.Request(contextPath+"/GIISEndtTextController", {
			method: "GET",
			parameters: {
				action : "showGiiss104"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Endorsement Text Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss104",e);
	}	
}