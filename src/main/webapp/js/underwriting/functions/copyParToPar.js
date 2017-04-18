function copyParToPar(parId){
    new Ajax.Request(contextPath+"/CopyUtilitiesController?action=copyParToPar",{
		parameters: {
			issCd     : $("issueCd").value,
			parId     : parId,
			varLineCd : $("varLineCd").value
		},
		method: "POST",
		onCreate:
			 showNotice("Working...please wait..."),
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				showMessageBox(response.responseText, imgMessage.SUCCESS);
				clear();
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
			
		}
	});
}