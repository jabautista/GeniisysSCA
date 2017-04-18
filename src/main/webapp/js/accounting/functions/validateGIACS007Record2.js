function validateGIACS007Record2(paramBillCmNo, paramInstNo, revGaccTranId, issCd, tranType, recordValidated, selectedIndex) {
	try {
		new Ajax.Request(contextPath + "/GIACDirectPremCollnsController?action=validateRecord", {
			method: "GET",
			parameters: { issCd: 				issCd,
						  premSeqNo: 			paramBillCmNo,
						  instNo: 				paramInstNo,
						  tranType: 			tranType,
						  billPremiumOverdue: 	objAC.checkBillDueDate,
						  revGaccTranId: 		revGaccTranId,
						  tranDate:				$F("tranDate")},
	  		evalScripts: true,
	  		asynchronous: false,
	  		onCreate: function() {
						  		
			},
			onComplete: function(response) {
				var result = eval(response.responseText);
				result.cancelledFlag = false;
				if (result[0].errorEncountered!=undefined) {
					if( result[0].errorMessage == "This is a cancelled policy.") {
						result.cancelledFlag = true;
					} else {
						showMessageBox(result[0].errorMessage, imgMessage.ERROR);
						searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), 
								searchTableGrid.getCurrentPosition()[1]);
					}				
				}
				if(result[0].checkPreviousInst == "N"){ //robert
					showMessageBox("Payments of installments should be sequential. Settle the previous installment first.", "I");
					searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), 
							searchTableGrid.getCurrentPosition()[1]);
				}
				var billNoValidationDtls = result[0].billNoValidationDtls;
				//var checkInstNoDtls = result[0].checkInstNoDtls;
				//var checkPremPaytForSpecialDtls = result[0].checkPremPaytForSpecialDtls;
				if(recordValidated != null) {
					recordValidated.billCmNo		= 	paramBillCmNo;
					recordValidated.instNo			=	paramInstNo;
					recordValidated.policyNo		= 	billNoValidationDtls.policyNo;
					recordValidated.policyId		=	billNoValidationDtls.policyId;
					recordValidated.lineCd			=	billNoValidationDtls.lineCd;
					recordValidated.sublineCd		=	billNoValidationDtls.sublineCd;
					recordValidated.issCd			=	billNoValidationDtls.issCd;
					recordValidated.issueYear		=	billNoValidationDtls.issueYear;
					recordValidated.polSeqNo		=	billNoValidationDtls.polSeqNo;
					recordValidated.endtSeqNo		=	billNoValidationDtls.endSeqNo;
					recordValidated.endtType		=	billNoValidationDtls.endtType;
					recordValidated.polFlag			=	billNoValidationDtls.polFlag;
					recordValidated.assdNo			=	billNoValidationDtls.assdNo;
					recordValidated.assdName		=	billNoValidationDtls.assdName;
					recordValidated.currCd			=	billNoValidationDtls.currCd == null ? objAC.defCurrency : billNoValidationDtls.currCd;
					recordValidated.currRt			=	billNoValidationDtls.currRt == null ? objAC.defCurrRat : billNoValidationDtls.currRt;
					recordValidated.currShortName	=	billNoValidationDtls.currShortName;
					recordValidated.currDesc		=	billNoValidationDtls.currDesc;
					recordValidated.tranType		=	tranType; //robert 01.24.2013
					
					if (billNoValidationDtls.currCd == '1') {
						disableButton("btnForeignCurrency");
						//enableButton("btnForeignCurrency");
					} else {
						enableButton("btnForeignCurrency");
						//disableButton("btnForeignCurrency");
					}
		
					//var checkInstNoDtls = result[0].checkInstNoDtls;
					
					//if ("1,4".indexOf($F("tranType"),1)!=-1) {
					if ("1".indexOf($F("tranType"),1)!=-1) {	
						recordValidated.premCollectionAmt	 = formatCurrency(result[0].collectionAmt);
						recordValidated.origCollAmt			 = formatCurrency(result[0].collectionAmt);
						recordValidated.origPremAmt			 = formatCurrency(result[0].premAmt);
						recordValidated.origTaxAmt			 = formatCurrency(result[0].taxAmt);
					} else {
						recordValidated.premCollectionAmt	 = formatCurrency(result[0].negCollectionAmt);
						recordValidated.origCollAmt			 = formatCurrency(result[0].negCollectionAmt);
						recordValidated.origPremAmt			 = formatCurrency(result[0].negPremAmt);
						recordValidated.origTaxAmt			 = formatCurrency(result[0].negTaxAmt);
					}
					
					//recordValidated.prevPremAmt = recordValidated.origPremAmt;
					searchTableGrid.setValueAt(recordValidated.origPremAmt, searchTableGrid.getColumnIndex("prevPremAmt"),selectedIndex);
					
					if(tranType == 1 || tranType == 3) {
						setPremTaxTranType(issCd, paramBillCmNo, tranType, 
								paramInstNo, recordValidated.origPremAmt, 
								function(res) {
									recordValidated.premVatable = res.premVatable;
									recordValidated.premVatExempt = res.premVatExempt;
									recordValidated.premZeroRated = res.premZeroRated;
									recordValidated.maxPremVatable = res.maxPremVatable;
									
									searchTableGrid.setValueAt(res.premVatable, searchTableGrid.getColumnIndex("premVatable"),selectedIndex);
									searchTableGrid.setValueAt(res.premVatExempt, searchTableGrid.getColumnIndex("premVatExempt"),selectedIndex);
									searchTableGrid.setValueAt(res.premZeroRated, searchTableGrid.getColumnIndex("premZeroRated"),selectedIndex);
								});
					} else {
						recordValidated.premVatable = -1*recordValidated.premVatable;
						recordValidated.premVatExempt = -1*recordValidated.premVatExempt;
						recordValidated.premZeroRated = parseFloat(nvl(recordValidated.premZeroRated, 0)) <= 0 ? recordValidated.premZeroRated : (-1*recordValidated.premZeroRated);
						recordValidated.revGaccTranId = recordValidated.revGaccTranId;
						
						searchTableGrid.setValueAt(recordValidated.premVatable, searchTableGrid.getColumnIndex("premVatable"),selectedIndex);
						searchTableGrid.setValueAt(recordValidated.premVatExempt, searchTableGrid.getColumnIndex("premVatExempt"),selectedIndex);
						searchTableGrid.setValueAt(recordValidated.premZeroRated, searchTableGrid.getColumnIndex("premZeroRated"),selectedIndex);
					}
					
					recordValidated.selectedIndex = selectedIndex;
					if (objAC.taxAllocationFlag == "Y"){
						objAC.selectedFromInvoiceLOV=true;
						/*getTaxType(($F("tranType")=="" ? recordValidated.tranType : $F("tranType")), 
								recordValidated);*/
						if(objAC.giacs7TG) {
							withTaxAllocationLOVTG(($F("tranType")=="" ? recordValidated.tranType : $F("tranType")), 
									recordValidated);
						} else {
							withTaxAllocation2(($F("tranType")=="" ? recordValidated.tranType : $F("tranType")), 
									recordValidated);
						}
					} else {
						noTaxAllocation2(($F("tranType")=="" ? recordValidated.tranType : $F("tranType")), 
								recordValidated);
					}
				}

				if (objAC.taxAllocationFlag == "Y") {
					objAC.recomputeTag = "Y";
					recomputeAllocationLOV(unformatCurrencyValue(recordValidated.origPremAmt), 
							unformatCurrencyValue(recordValidated.origTaxAmt), tranType, recordValidated, result);
				} else {
					/*if (checkPremPaytForSpecialDtls.msgAlert=="This is a Special Policy.") {  //nilipat na to sa validateGIACS007PremSeqNo
						showWaitingMessageBox(checkPremPaytForSpecialDtls.msgAlert, imgMessage.INFO, 
							function(){
								if (result[0].hasClaim != "FALSE") {
									contValidationCheckForClaim(result);
								}
							}
						);
					} else*/ 
					if(result.cancelledFlag) {
						processPaytFromCancelled(result, null);
						/*showWaitingMessageBox(result[0].errorMessage, imgMessage.INFO, 
								function(){
									if (result[0].hasClaim != "FALSE") {
										contValidationCheckForClaim(result);
									}
								}
							);*/
					} else{
						contValidationCheckForClaim(result);
					}
				}
				
			}
			
		});
		
		
	} catch(e) {
		showErrorMessage("validateGIACS007Record2", e);
	}
	return recordValidated;
}