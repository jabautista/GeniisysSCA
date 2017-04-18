/**
* Shows Commissions Due
* @author Gzelle
* @date 10.23.2013
* 
*/
function showCommissionsDue(){
	try{
		new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController",{
			method: "POST",
			parameters : {action : "showCommissionsDue"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading Commissions Due, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showCommissionsDue", e);
	}
}