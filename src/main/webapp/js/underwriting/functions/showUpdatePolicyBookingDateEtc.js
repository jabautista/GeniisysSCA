function showUpdatePolicyBookingDateEtc(){
	try{
		new Ajax.Request(contextPath + "/UpdateUtilitiesController",{
			parameters : {action : "showUpdatePolicyBookingDateEtc"},
			onCreate: function(){
				showNotice("Loading page, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUpdatePolicyBookingDateEtc", e);
	}

}