function populateGDCPForm(obj) {
	try {
		if(obj != null) {
			$("selTransactionType").value = obj.transactionType;  
			$("txtClaimNumber").value = obj.claimNumber;
			
			$("txtLineCd").value = obj.lineCode;	
			$("txtIssCd").value = obj.issueCode;
			$("txtAdviceYear").value = obj.adviceYear;
			$("txtAdvSeqNo").value = obj.adviceSequence;
			
			$("txtPolicyNumber").value = obj.policyNumber;
			var payeeType = obj.payeeType;
			if(payeeType == "L"){
				payeeType = "Loss";
			}else if(payeeType == "E"){
				payeeType = "Expense";
			}
			
			$("txtPayee").value					= obj.payee;
			$("txtPeril").value					= obj.perilCode;
			$("txtAssuredName").value 			= obj.assuredName;
			$("txtDisbursementAmount").value	= formatCurrency(obj.disbursementAmount);
			$("txtRemarks").value 				= obj.remarks;
			$("txtInputTax").value 				= formatCurrency(obj.inputVatAmount);
			$("txtWithholdingTax").value		= formatCurrency(obj.withholdingTaxAmount);
			$("txtNetDisbursement").value		= formatCurrency(obj.netDisbursementAmount);
			onSelectPayee(obj);
			
			disableButton("btnAddDirectClaimPayment");
			enableButton("btnRemoveDirectClaimPayment");
			enableButton("btnClaimAdvice");
			enableButton("btnBatchClaim");
		} else {
			$("txtLineCd").value 			= "";	
			$("txtIssCd").value 			= "";
			$("txtAdviceYear").value 		= "";
			$("txtAdvSeqNo").value 			= "";
			
			$("selTransactionType").value	= "";
			$("txtClaimNumber").value		= "";
			$("txtAdviceSequence").value	= "";
			$("txtPolicyNumber").value 		= "";
			$("txtPayee").value				= "";
			$("selPayeeClass2").value		= "";
			$("txtPeril").value				= "";
			$("txtAssuredName").value 		= "";
			$("txtDisbursementAmount").value= "";
			$("txtRemarks").value 			= "";
			$("txtInputTax").value			= "";
			$("txtWithholdingTax").value	= "";
			$("txtNetDisbursement").value	= "";	
			onSelectPayee(null);
			disableButton("btnRemoveDirectClaimPayment");
			enableButton("btnAddDirectClaimPayment");
			$("btnAddDirectClaimPayment").value = "Add";
			disableButton("btnClaimAdvice");
			disableButton("btnBatchClaim");
		}
	} catch(e) {
		showErrorMessage("populateGDCPForm", e);
	}
}