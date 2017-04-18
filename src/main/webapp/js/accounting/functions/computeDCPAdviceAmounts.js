function computeDCPAdviceAmounts(row) {
	try {
		if(!$F("selPayeeClass2").blank() && row != null){
			$("txtDisbursementAmount").value = formatCurrency(row.netAmount);
			$("txtPayee").value = row.payee;
			$("txtPeril").value = row.perilSname;

			// this section prevents unique key constraint exception
			var tranId 		= objACGlobal.gaccTranId;
			var claimLossId = row.claimLossId; // #currentTask
			var claimId		= $F("claimIdAC017");
			var proceed = true;
			for(var index = 0; index < dcpJsonObjectList.length; index++){
				if(dcpJsonObjectList[index].gaccTranId 	 == tranId  && 
					dcpJsonObjectList[index].claimId 	 == claimId	&&
					dcpJsonObjectList[index].claimLossId == claimLossId	){
					proceed = false;
				}
			}
			
			// compute inputVat, withholding, netDisbursement
			if(!proceed){
				showMessageBox("Claim Loss has already been used.", imgMessage.ERROR);
			}else{
				new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController?action=computeAdviceAmounts", {
					method:			"GET",
					evalScripts:	true,
					asynchronous:	true,
					parameters:	{
						vCheck: 				"0",
						transactionType: 		$F("selTransactionType"),
						gaccTranId: 			objACGlobal.gaccTranId,
						claimId: 				$F("claimIdAC017"),
						claimLossId: 			claimLossId, 
						adviceId: 				$F("adviceIdAC017"),
						inputVatAmount: 		$F("hidInputVatAmount"),
						withholdingTaxAmount: 	$F("hidWithholdingTaxAmount"),
						netDisbursementAmount: 	$F("hidNetDisbursementAmount"),
						toObject:				"Y"
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							var res = JSON.parse(response.responseText);
							$("hidInputVatAmount").value = res.inputVatAmount;
							$("hidWithholdingTaxAmount").value = res.withholdingTaxAmount;
							$("hidNetDisbursementAmount").value = res.netDisbursementAmount;
							
							$("txtInputTax").value 			= formatCurrency($F("hidInputVatAmount"));
							$("txtWithholdingTax").value 	= formatCurrency($F("hidWithholdingTaxAmount"));
							$("txtNetDisbursement").value 	= formatCurrency($F("hidNetDisbursementAmount"));
							
							$("totalNetDisbursementAmount").value = res.totalNetDisbursementAmount;
							$("totalInputVatAmount").value = res.sumInputVatAmount;
							$("totalWithholdingTaxAmount").value = res.totalWithholdingTaxAmount;
						}
					} 
				});
			}
		}else{
			$("txtPayee").value	= "";
			$("txtPeril").value	= "";
			$("txtDisbursementAmount").value= formatCurrency(0);
		}
	} catch(e) {
		showErrorMessage("computeAdviceAmounts", e);
	}
}