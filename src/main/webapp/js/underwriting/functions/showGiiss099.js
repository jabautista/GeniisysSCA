//Gzelle 10.22.2013 Bond Clause Type Maintenance
function showGiiss099(){
	new Ajax.Request(contextPath + "/GIISBondClassClauseController", {
	    parameters : {action : "showGiiss099"},
	    onCreate: showNotice("Retrieving Bond Clause Type Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGiiss099 - onComplete : ", e);
			}								
		} 
	});
}