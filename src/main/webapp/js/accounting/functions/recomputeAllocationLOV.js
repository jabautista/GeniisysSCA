function recomputeAllocationLOV(recompPrem, recompTax, taxType, recordValidated, result) {
	try {
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
			method: "GET",
			parameters: {
				tranId: 		objACGlobal.gaccTranId,	
				tranType: 		taxType,
				tranSource: 	$F("tranSource") == "" ? recordValidated.issCd : $F("tranSource"),
				premSeqNo: 		recordValidated.billCmNo ? recordValidated.billCmNo : $F("billCmNo"),
				instNo: 		recordValidated.instNo 	 ? recordValidated.instNo 	: $F("instNo"),
				fundCd: 		objACGlobal.fundCd,
				taxAmt: 		(recompTax),
				//paramPremAmt: 	unformatCurrencyValue(recordValidated.origPremAmt),
				paramPremAmt: 	recordValidated.premVatable, //mikel 09.03.2015; UCPBGEN SR 20211
				premAmt: 		(recompPrem),
				collnAmt: 		unformatCurrencyValue(recordValidated.premCollectionAmt),
				premVatExempt:  recordValidated.premVatExempt,		
				revTranId:	    recordValidated.revGaccTranId,			
				taxType: 		taxType
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var res = response.responseText.toQueryParams();
					
					var recomputedPrem = res.premAmt;
					var recomputedTax = res.taxAmt;
					if(recomputedPrem != recompPrem || recomputedTax != recompTax) {
						if(objAC.recomputeTag == "Y"){
							objAC.recomputeTag = "N";
							recomputeAllocationLOV(unformatCurrencyValue(recomputedPrem), 
									unformatCurrencyValue(recomputedTax), taxType, recordValidated, result);
						}else{
							showMessageBox("There is an overpayment on premium/tax found. Kindly delete and re-enter the record.");
							if(objAC.usedAddButton == "P") {
								 objAC.policyInvoices.splice(objAC.currentRecord.selectedIndex2, 1);
							 	 displayInvoicesToRows();
							} else {
								 searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), searchTableGrid.getCurrentPosition()[1]);
							}
						}
					} else {
						if(result.cancelledFlag) {
					    	processPaytFromCancelled(result, null);
						} else {
							contValidationCheckForClaim(result);
						}
					}
					
				}
			}
		});
	} catch(e) {
		 showErrorMessage("recomputeAllocationLOV", e);
	}
}