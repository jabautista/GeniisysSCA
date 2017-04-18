function showInwardRiPaymentStatus(){ // J. Diago 09.09.2013
	try{
		new Ajax.Request(contextPath + "/GIRIInpolbasController", {
			parameters : {action : "viewInwardRiPaymentStatus"},
			onCreate : showNotice("Loading View Inward RI Payment Status, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showInwardRiPaymentStatus",e);
	}
}