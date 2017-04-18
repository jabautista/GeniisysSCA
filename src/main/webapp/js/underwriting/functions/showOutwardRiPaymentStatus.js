function showOutwardRiPaymentStatus(){ //pol cruz
	try{
		new Ajax.Request(contextPath + "/GIRIInpolbasController", {
			parameters : {action : "showOutwardRiPaymentStatus"},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showOutwardRiPaymentStatus",e);
	}
}