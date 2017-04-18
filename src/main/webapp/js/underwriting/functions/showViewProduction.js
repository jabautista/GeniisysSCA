//Fons 10.01.2013	View Production
function showViewProduction(){
	new Ajax.Request(contextPath + "/GIPIPolbasicController", {
	    parameters : {action : "getProductionList"},
	    onCreate: showNotice("Loading View Production,  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showViewProduction - onComplete : ", e);
			}								
		} 
	});
}