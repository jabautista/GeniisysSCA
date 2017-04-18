// newly added functions for new giacs017

function computeSelectedAdvAmt(row) {
	try {
		if(!$F("selPayeeClass2").blank() && row != null){
			$("txtDisbursementAmount").value = formatCurrency(row.netAmount);
			$("txtPayee").value = unescapeHTML2(row.payee); //added escapeHTML2 reymon 04242013
			$("txtPeril").value = row.perilSname;

			// this section prevents unique key constraint exception
			var tranId 		= objACGlobal.gaccTranId;
			var claimLossId = row.claimLossId; // #currentTask
			var claimId		= $F("claimIdAC017");
			var proceed = true;
			/*for(var index = 0; index < dcpJsonObjectList.length; index++){
				if(dcpJsonObjectList[index].gaccTranId 	 == tranId  && 
					dcpJsonObjectList[index].claimId 	 == claimId	&&
					dcpJsonObjectList[index].claimLossId == claimLossId	){
					proceed = false;
				}
			}
			*/
			if(!proceed){
				showMessageBox("Claim Loss has already been used.", imgMessage.ERROR);
			}else{
				new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController?action=computeAdviceAmounts", {
					method:			"GET",
					evalScripts:	true,
					asynchronous:	false,
					parameters:	{
						vCheck: 				"0",
						transactionType: 		$F("selTransactionType"),
						gaccTranId: 			objACGlobal.gaccTranId,
						claimId: 				$F("claimIdAC017"),
						claimLossId: 			claimLossId, 
						adviceId: 				$F("adviceIdAC017"),
						inputVatAmount: 		nvl($F("hidInputVatAmount"), 0),
						withholdingTaxAmount: 	nvl($F("hidWithholdingTaxAmount"), 0),
						netDisbursementAmount: 	nvl($F("hidNetDisbursementAmount"), 0),
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
							
							$("dcpForeignCurrencyAmt").value = formatCurrency(row.netAmount/parseFloat($F("dcpConvertRate")));//change to division reymon 04242013
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