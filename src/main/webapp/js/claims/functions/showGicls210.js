// Kris 11.13.2013: GICLS210 - Private Adjuster Maintenance 
function showGicls210(){
	new Ajax.Request(contextPath + "/GIISAdjusterController", {
		method : "POST",
		parameters : {action 	: "showGicls210"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}