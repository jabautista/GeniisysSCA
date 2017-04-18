/**
 * Shows Policy Type Maintenance Page
 * Module: GIISS113 - Coverage Maintenance
 * @author J. Diago
 * */
function showGiiss113(){
	try{ 
		new Ajax.Request(contextPath+"/GIISCoverageController", {
			method: "GET",
			parameters: {
				action : "showGiiss113"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Coverage Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss113",e);
	}	
}