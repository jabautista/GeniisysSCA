/**
* Shows Batch Checking
* @author Gzelle
* @date 10.08.2013
* 
*/
function showBatchChecking(){
	try{
		new Ajax.Request(contextPath+"/GIACBatchCheckController",{
			method: "POST",
			parameters : {action : "showBatchChecking"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading Batch Checking, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showBatchChecking", e);
	}
}