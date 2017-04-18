/**modified by irwin Loss Reserve cannot be less than the lo
 * added validation for total expense
 * 6.25.2012
 * */
function recomputeTotalReserve(v1, v2, sumElement, param){ 
	var totalExpense = nvl(unformatCurrencyValue(v1) + unformatCurrencyValue(v2),0);
	if(nvl(param, "N") == "Y"){
		// copied from function checkUWDistGICLS024
		
		new Ajax.Request(contextPath + "/GICLClaimReserveController",
		{
			method : "GET",
			parameters : {
				action : "checkUWDist",
				claimId : objGICLClaims.claimId,
				lineCd : objGICLClaims.lineCd,
				sublineCd : objGICLClaims.sublineCd,
				polIssCd : objGICLClaims.polIssCd,
				issueYy : objGICLClaims.issueYy,
				polSeqNo : objGICLClaims.polSeqNo,
				renewNo : objGICLClaims.renewNo,
				polEffDate : objGICLClaims.polEffDate,
				expiryDate : objGICLClaims.expiryDate,
				dspLossDate : objGICLClaims.dspLossDate,
				perilCd : objCurrGICLItemPeril.dspPerilCd,
				itemNo : objCurrGICLItemPeril.itemNo
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (response.responseText == "SUCCESS") {
					var annTsiAmt = nvl(unformatCurrencyValue(objCurrGICLItemPeril.allowTsiAmt, objCurrGICLItemPeril.annTsiAmt));
					//if(annTsiAmt < totalExpense){ commented out and changed by reymon 11152013
					if(annTsiAmt < nvl(unformatCurrencyValue($F("txtLossReserve")),0)){
						$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
						$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
						showWaitingMessageBox("Loss Reserve Amount cannot exceed "+formatCurrency(annTsiAmt), "I");
						return false;
					}
					sumElement.value = formatCurrency(totalExpense);
				} else {
					$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
					$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
					changeTag = 0;
					showMessageBox(response.responseText,
							imgMessage.ERROR);
					//checkPerilStatusGICLS024();
				}
			}
		});
		
	}else{
		sumElement.value = formatCurrency(totalExpense);
	}
	 
}