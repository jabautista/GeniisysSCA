function getTowAmount(giclItemPeril){
	try{
		new Ajax.Request(contextPath+"/GICLMotorCarDtlController", {
			parameters:{
				action: "getTowAmount",
				claimId: giclItemPeril.claimId,
				itemNo : giclItemPeril.itemNo
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
		showErrorMessage("getTowAmount", e);
	}
}