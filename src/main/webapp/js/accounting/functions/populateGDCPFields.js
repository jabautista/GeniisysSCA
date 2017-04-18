// populate fields in gics017(table grid)
function populateGDCPFields(row, editAdv) {
	try {
		//$("selTransactionType").selectedIndex = row==null ? 0 : row.transactionType;
		if(editAdv) {
			
		} else {
			$("selTransactionType").value = row==null ? "" : row.transactionType;
			$("txtLineCd").value = row==null ? "" : row.dspLineCd;
			$("txtIssCd").value = row==null ? "" : row.dspIssCd;
			$("txtAdviceYear").value = row==null ? "" : row.dspAdviceYear;
		}
		
		if(row != null && nvl(row.claimNumber, null) == null) {
			$("txtClaimNumber").value = row.dspLineCd2+" - "+row.dspSublineCd+" - "+row.dspIssCd2+" - "
				+row.dspClmYy+" - "+parseInt(row.dspClmSeqNo).toPaddedString(5);
		} else if(row != null) {
			$("txtClaimNumber").value = row.claimNumber;
		} else {
			$("txtClaimNumber").value = "";
		}
		
		$("txtAdvSeqNo").value = row==null ? "" : row.dspAdviceSeqNo;
		if(row != null && nvl(row.policyNumber, null) == null) {
			$("txtPolicyNumber").value = row.dspLineCd2+" - "
					+row.dspSublineCd+" - "+row.dspIssCd3+" - "+row.dspIssueYy
					+" - "+parseInt(row.dspPolSeqNo).toPaddedString(7)+
					" - "+parseInt(row.dspRenewNo).toPaddedString(2);
		} else if(row != null){
			$("txtPolicyNumber").value = row.policyNumber;
		} else {
			$("txtPolicyNumber").value = "";
		}
		
		$("selPayeeClass2").value = row==null ? "" : row.dspPayeeDesc;
		$("txtPayee").value = row==null ? "" : unescapeHTML2(row.dspPayeeName);//added unescapehtml2 reymon 04242013
		$("txtPeril").value = row==null ? "" : row.dspPerilName;
		$("txtAssuredName").value = row==null ? "" : unescapeHTML2(row.dspAssuredName);//added unescapehtml2 reymon 04242013
		$("txtDisbursementAmount").value = row==null ? "" : formatCurrency(row.disbursementAmount);
		$("txtInputTax").value = row==null ? "" : formatCurrency(row.inputVatAmount);
		$("txtWithholdingTax").value = row==null ? "" : formatCurrency(row.withholdingTaxAmount);
		$("txtNetDisbursement").value = row==null ? "" : formatCurrency(row.netDisbursementAmount);
		$("txtRemarks").value = row==null ? "" : unescapeHTML2(row.remarks);
		/* if(row == null) {
			$("selCurrency").selectedIndex = 0;
		} else {
			var currency = $("selCurrency");
			for(var i=0; i<currency.length; i++) {
				if(currency.value == row.currencyCode) {
					$("selCurrency").selectedIndex = i;
				}
			}
		} */
		$("adviceIdAC017").value = row==null ? "" : row.adviceId;
		$("claimIdAC017").value = row==null ? "" : row.claimId;
		$("claimLossId").value = row==null ? "" : row.claimLossId;
		$("payeeClassCd").value = row==null ? "" : row.payeeClassCd;
		$("payeeCode").value = row==null ? "" : row.payeeCd;
		$("payeeType").value = row==null ? "" : row.payeeType;
		$("batchCsrId").value = row==null ? "" : row.batchCsrId;//added by reymon 04262013
		
		$("selCurrency").value = row==null ? "" : row.currencyCode;
		$("dcpConvertRate").value = row==null ? "" : row.convertRate;
		$("dcpCurrencyDesc").value = row==null ? "" : row.currencyDesc;
		$("dcpForeignCurrencyAmt").value = row==null ? "" : (row.foreignCurrencyAmount==null ? "0.00" : formatCurrency(row.foreignCurrencyAmount));
		if(row==null) {
			$("btnAddDCP").value = "Add";
		} else {
			$("btnAddDCP").value = "Update";
		}
		//enableDisableGDCPInputs();
	} catch(e) {
		showErrorMessage("populateGDCPFields", e);
	}
}