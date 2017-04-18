/**
 * Shows Policy Type Maintenance Page
 * Module: GIISS084 - Co-Intermediary Type Commission Rate Maintenance
 * @author J. Diago
 * */
function showGiiss084(){
	try{ 
		new Ajax.Request(contextPath+"/GIISIntmTypeComrtController", {
			method: "GET",
			parameters: {
				action : "showGiiss084"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Co-Intermediary Type Commission Rate Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss084",e);
	}	
}