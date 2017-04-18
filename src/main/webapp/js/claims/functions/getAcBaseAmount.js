//added by kenneth 1.29.2015 for AC base amount
//modified by kenneth SR20950 11.12.2015 :: add lineCd, itemNo, perilCd
function getAcBaseAmount(){
	try{
		new Ajax.Request(contextPath+"/GICLAccidentDtlController", {
			parameters:{
				action: "getAcBaseAmount",
				policyId : objCLMGlobal.policyId,
				lineCd : objCLMGlobal.lineCd,
				itemNo : objCurrGICLItemPeril.itemNo,
				perilCd : objCurrGICLItemPeril.perilCd
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("txtBaseAmt").value = formatCurrency(response.responseText);
					$("txtBaseAmt").setAttribute("lastValidValue", formatCurrency(response.responseText));
				}else{
					showMessageBox(response.responseText, "E");
					$("txtLoss").value = "";
					$("txtLoss").setAttribute("lossExpCd", "");
					$("txtBaseAmt").value = formatCurrency(0);
					$("txtBaseAmt").setAttribute("lastValidValue", formatCurrency(0));
				}
				computeLossAndNetAmounts();
			}
		});
	}catch(e){
		showErrorMessage("getAcBaseAmount", e);
	}
}