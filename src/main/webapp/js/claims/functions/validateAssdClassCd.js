function validateAssdClassCd(payeeClassCd){
	try{
		new Ajax.Request(contextPath+"/GICLLossExpPayeesController", {
			asynchronous: false,
			parameters:{
				action: "validateAssdClassCd",
				claimId: objCLMGlobal.claimId,
				assdNo: objCLMGlobal.assuredNo,
				itemNo: nvl(objCurrGICLItemPeril.itemNo, 0),
			    perilCd: nvl(objCurrGICLItemPeril.perilCd, 0),
			    payeeType : $("selPayeeType").value,
			    payeeClassCd: payeeClassCd
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "EMPTY") != "EMPTY"){
						showWaitingMessageBox(response.responseText, "I", function(){
							$("payee").value = "";
							$("payee").setAttribute("payeeNo", "");
							$("payeeClass").value = "";
							$("payeeClass").setAttribute("payeeClassCd", "");
						});
						return false;
					}else{
						$("payee").value = unescapeHTML2(nvl(objCLMGlobal.assuredName , ""));
						$("payee").setAttribute("payeeNo", nvl(objCLMGlobal.assuredNo, ""));
						$("payee").focus();
					}
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}
			}
		});
	}catch(e){
		showErrorMessage("validateAssdClassCd", e);
	}
}