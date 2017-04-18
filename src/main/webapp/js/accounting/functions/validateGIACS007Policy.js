function validateGIACS007Policy(paramBillCmNo, paramInstNo, issCd, tranType) {
	try {
		var recordValidated = new Object();
		new Ajax.Request(contextPath + "/GIACDirectPremCollnsController?action=validateRecord", {
			method: "GET",
			parameters: { issCd: 				issCd,
						  premSeqNo: 			paramBillCmNo,
						  instNo: 				paramInstNo,
						  tranType: 			tranType,
						  billPremiumOverdue: 	objAC.checkBillDueDate,
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
				
				var billNoValidationDtls = result[0].billNoValidationDtls;
				//var checkPremPaytForSpecialDtls = result[0].checkPremPaytForSpecialDtls;
				
				recordValidated = objAC.currentRecord;
				recordValidated.gaccTranId		= 	objACGlobal.gaccTranId;
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
				recordValidated.revGaccTranId   =   billNoValidationDtls.revGaccTranId;
				
				//if ("1,4".indexOf($F("tranType"),1)!=-1) {
				if ("1".indexOf($F("tranType"),1)!=-1) {
					recordValidated.premCollectionAmt	 = formatCurrency(result[0].collectionAmt);
					recordValidated.collAmt			 	 = formatCurrency(result[0].collectionAmt);
					recordValidated.origPremAmt			 = formatCurrency(result[0].premAmt);
					recordValidated.origTaxAmt			 = formatCurrency(result[0].taxAmt);
				} else {
					recordValidated.premCollectionAmt	 = formatCurrency(result[0].negCollectionAmt);
					recordValidated.collAmt			 	 = formatCurrency(result[0].negCollectionAmt);
					recordValidated.origPremAmt			 = formatCurrency(result[0].negPremAmt);
					recordValidated.origTaxAmt			 = formatCurrency(result[0].negTaxAmt);
				}
				
				if(tranType == 1 || tranType == 3) {
					 setPremTaxTranType(issCd, paramBillCmNo, tranType, 
							paramInstNo, recordValidated.origPremAmt, 
							function(res) {
								recordValidated.premVatable = res.premVatable;
								recordValidated.premVatExempt = res.premVatExempt;
								recordValidated.premZeroRated = res.premZeroRated;
								recordValidated.maxPremVatable = res.maxPremVatable;
							});	
				} else {
					recordValidated.premVatable = -1*recordValidated.premVatable;
					recordValidated.premVatExempt = -1*recordValidated.premVatExempt;
					recordValidated.premZeroRated = -1*recordValidated.premZeroRated;
					recordValidated.revGaccTranId = recordValidated.revGaccTranId;
				}
				
				recordValidated.premAmt = recordValidated.origPremAmt;
				recordValidated.paramPremAmt = recordValidated.paramPremAmt==null ? recordValidated.maxPremVatable 
						: objAC.currentRecord.paramPremAmt;
				recordValidated.prevPremAmt = unformatCurrencyValue(recordValidated.origPremAmt);
				recordValidated.prevTaxAmt = unformatCurrencyValue(recordValidated.origTaxAmt);
				
				
				recordValidated.selectedIndex = selectedIndex;
				if (objAC.taxAllocationFlag == "Y"){
					objAC.selectedFromInvoiceLOV=true;
					if(recordValidated.origTaxAmt == 0) {
						recordValidated.premAmt = recordValidated.premCollectionAmt;
						recordValidated.taxAmt = formatCurrency(0);
						
						if(recordValidated.premZeroRated == 0) {
							recordValidated.premVatExempt = unformatCurrencyValue(recordValidated.origPremAmt);
						} else {
							recordValidated.premZeroRated = unformatCurrencyValue(recordValidated.origPremAmt);
						}
					} else {
						getTaxType(($F("tranType")=="" ? recordValidated.tranType : $F("tranType")), 
								recordValidated, function(result) {
									recordValidated.collAmt = result.collnAmt;
									recordValidated.premAmt = result.premAmt;
									recordValidated.taxAmt = result.taxAmt;
									recordValidated.premVatExempt = result.premVatExempt;
									
									if(recordValidated.premZeroRated == 0) { //modified by robert 01.23.2013
										if(((recordValidated.premAmt) - (recordValidated.premVatExempt)) == 0) {
											recordValidated.premVatable = 0; 
										} else if(((recordValidated.premAmt) - (recordValidated.premVatExempt)) != 0) { //robert 01.23.2013
											recordValidated.premVatable = recordValidated.premAmt - recordValidated.premVatExempt;
										}
									} else {
										recordValidated.premZeroRated = unformatCurrencyValue(premAmt);
										recordValidated.premVatable = 0;
										recordValidated.premVatExempt = 0;
									}
									
							});
					}
					
				} 
				
				recordValidated.selectedIndex = objAC.currentRecord.selectedIndex2;
				recordValidated.forCurrAmt	= parseFloat(recordValidated.collAmt) / parseFloat(recordValidated.currRt);
				objAC.currentRecord = recordValidated;
				
				try {
					new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
						method: "GET",
						parameters: {
							action: "getIncTagForAdvPremPayts",
							tranId: objACGlobal.gaccTranId,
							premSeqNo: paramBillCmNo,
							issCd: issCd
						},
						asynchronous: false,
						evalScripts: true,
						onComplete: function(response) {
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								recordValidated.incTag = nvl(response.responseText, "N") == "Y" ? "Y" : "N";
							}
						}
					});
				} catch(e) {
					showErrorMessage("getIncTagForAdvPremPayts", e);
				}
					
				if (objAC.taxAllocationFlag == "Y") {
					recomputeAllocationLOV(unformatCurrencyValue(recordValidated.premAmt), 
							unformatCurrencyValue(recordValidated.taxAmt), tranType, recordValidated, result);
				} else {
					if(result.cancelledFlag) {
						processPaytFromCancelled(result, null);
					} else {
						contValidationCheckForClaim(result);
					}
				}
			}
		});
		//return recordValidated;
	} catch(e) {
		showErrorMessage("validateGIACS007Policy", e);
	}
}