function getDefaultReinsurer(){
	try{
		new Ajax.Request(contextPath+"/GIISReinsurerController", {
			asynchronous: false,
			parameters:{
				action: "getReinsurerByRiCd",
				riCd : nvl(objCLMGlobal.riCd, "")
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("payee").value = unescapeHTML2(nvl(obj.riName, ""));
					$("payee").setAttribute("payeeNo", nvl(obj.riCd, ""));
					$("payee").focus();
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}
			}
		});
	}catch(e){
		showErrorMessage("getDefaultReinsurer", e);
	}
}