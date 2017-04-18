/**
 * Shows Inward Treaty Maintenance Page
 * Module: GIISS032 - Inward Treaty Maintenance
 * @author J. Diago
 * */
function showGiiss032(){
	try{ 
		new Ajax.Request(contextPath+"/GIISIntreatyController", {
			method: "GET",
			parameters: {
				action : "showGiiss032"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Inward Treaty Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss032",e);
	}	
}