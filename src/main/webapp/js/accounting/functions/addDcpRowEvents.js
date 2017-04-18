function addDcpRowEvents(newRow){
	newRow.observe("mouseover", function ()	{
		newRow.addClassName("lightblue");
	});

	newRow.observe("mouseout", function ()	{
		newRow.removeClassName("lightblue");
	});

	newRow.observe("click", function ()	{
		newRow.toggleClassName("selectedRow");
		if(newRow.hasClassName("selectedRow")){
			$$("div[name='dcpRow']").each(function(anotherRow){
				if(newRow.id != anotherRow.id){
					anotherRow.removeClassName("selectedRow");
				}else{
					var postFix = newRow.id.substr(6);
					var found = false;
					var obj = null;
					for(var i = 0 ; i < dcpJsonObjectList.length; i++){
						if(dcpJsonObjectList[i].id == postFix){
							found = true;
							obj = dcpJsonObjectList[i];
							$break;
						}
					}
					if(found){
						$("selTransactionType").value = obj.transactionType;  
						$("txtClaimNumber").value = obj.claimNumber;
						$("txtAdviceSequence").value = obj.adviceNumber;
						$("txtPolicyNumber").value = obj.policyNumber;
						var payeeType = obj.payeeType;
						if(payeeType == "L"){
							payeeType = "Loss";
						}else if(payeeType == "E"){
							payeeType = "Expense";
						}
						$("selPayeeClass").update("<option value='" + obj.payeeType +"'>" + payeeType + "</option>");
						$("selPayeeClass").selectedIndex	= 0;
						$("selPayeeClass").value			= obj.payeeType;
						$("txtPayee").value					= obj.payee;
						$("txtPeril").value					= obj.perilCode;
						$("txtAssuredName").value 			= obj.assuredName;
						$("txtDisbursementAmount").value	= formatCurrency(obj.disbursementAmount);
						$("txtRemarks").value 				= obj.remarks;
						$("txtInputTax").value 				= formatCurrency(obj.inputVatAmount);
						$("txtWithholdingTax").value		= formatCurrency(obj.withholdingTaxAmount);
						$("txtNetDisbursement").value		= formatCurrency(obj.netDisbursementAmount);
					}
				}
			});
			//$("btnAddDirectClaimPayment").value = "Update";
			disableButton("btnAddDirectClaimPayment");
			enableButton("btnRemoveDirectClaimPayment");
			enableButton("btnClaimAdvice");
			enableButton("btnBatchClaim");
		}else{
			$("selTransactionType").value	= "";	$("txtClaimNumber").value 		= "";
			$("txtAdviceSequence").value	= "";	$("txtPolicyNumber").value 		= "";
			$("txtPayee").value 			= "";	$("selPayeeClass").update("<option></option>");
			$("txtPeril").value 			= "";	$("txtAssuredName").value 		= "";
			$("txtDisbursementAmount").value = "";	$("txtRemarks").value 			= "";
			$("txtInputTax").value 			= "";	$("txtWithholdingTax").value 	= "";
			$("txtNetDisbursement").value 	= "";	//disableButton("btnRemoveDirectClaimPayment");
			
			enableButton("btnAddDirectClaimPayment");
			disableButton("btnRemoveDirectClaimPayment");
			$("btnAddDirectClaimPayment").value = "Add";
			disableButton("btnClaimAdvice");
			disableButton("btnBatchClaim");
		}
	});
}