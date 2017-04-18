function showBrokerOutstandingAccts(){
	try {
		new Ajax.Request(contextPath + "/GIRIBinderController", {
			parameters : {
				action : "getOutwardRiList"
			},
			onCreate : function(){
				showNotice("Loading Outwar RI / Broker Outstanding Accounts, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showBrokerOutstandingAccts: ", e);
	}
}