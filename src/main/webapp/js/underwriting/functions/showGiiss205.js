/**
 * Shows Industry Group Maintenance Page
 * Module: GIISS205 - Industry Group Maintenance
 * @author J. Diago
 * */
function showGiiss205(){
	try{ 
		new Ajax.Request(contextPath+"/GIISIndustryGroupController", {
			method: "GET",
			parameters: {
				action : "showGiiss205"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Industry Group Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss205",e);
	}	
}