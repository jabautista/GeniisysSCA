//Kenneth - 07.31.2013 - Assign Extracted Expiry Record to a New User
function showAssignExtractedExpiryRecord(){
	try{
		new Ajax.Request(contextPath + "/GIEXExpiriesVController",{
			parameters : {action : "showAssignExtractedExpiryRecord"},
			onCreate: function(){
				showNotice("Loading Assign Extracted Expiry Record to a New User, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showTrialBalanceAsOf", e);
	}
}