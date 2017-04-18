function updateParParameters(param){
	try {
		new Ajax.Request(contextPath+"/GIPIPARListController", {
			method: "POST",
			asynchronous: false,
			parameters: {action:"setParParameters",
			globalParId: (param == null ? (objUWGlobal.packParId != null && objCurrPackPar != null ? objCurrPackPar.parId : $F("globalParId")) : param)}, //july 8, 2011 modified by tonio added param for defined parId// andrew - 07.07.2011 - added condition for package par
			onComplete: function(response) {
							 if(checkErrorOnResponse(response)){
								 $("uwParParametersDiv").update(response.responseText);							 
							 } else {
								showMessageBox(response.responseText, imgMessage.ERROR);
							 }
						}
		});
	} catch (e){
		showErrorMessage("updateParParameters", e);
	}
}