function showGicls181(){
	var reportId = "";
	var reportNo = 0;
	var div = "dynamicDiv";
	if(objCLMGlobal.callingForm == "GICLS180"){
		reportId = unescapeHTML2(objCLMGlobal.gicls180ReportId);
		reportNo = unescapeHTML2(objCLMGlobal.gicls180ReportNo);
		div = "repSignatoryDiv";
	}
	
	new Ajax.Request(contextPath + "/GICLRepSignatoryController", {
	    parameters : {action : "showGicls181",
	    			  moduleId : "GICLS181",
	    			  reportId : reportId,
	    			  reportNo : reportNo },
	    onCreate: showNotice("Loading page, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$(div).update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGicls181 - onComplete : ", e);
			}								
		} 
	});
}