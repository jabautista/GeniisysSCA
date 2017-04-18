function makeGIACDirectClaimPaymentRow(dcpObject){
	var dcpRow = new Element("div");
	
	var dcpSequence = "";
	
	if($F("txtAdviceSequence") == "" || $F("txtAdviceSequence") == null){
		dcpSequence = dcpObject.adviceSequenceNumber;
	}else{
		dcpSequence = $F("txtAdviceSequence");
	}
	
	// check the source of function call if it's from load or from create
	// if from load, use object, else use textField
	
	dcpRow.setAttribute("id", 	"dcpRow" + dcpSequence);
	dcpRow.setAttribute("name", "dcpRow");
	dcpRow.setAttribute("class", "tableRow");
	
	var payeeShrt = "";
	
	if(dcpObject.payeeType == "L"){
		payeeShrt = "Loss";
	}else if(dcpObject.payeeType == "E"){
		payeeShrt = "Expense";
	}
	
	var ashortName = dcpObject.assuredName.substr(0,9);
	
	dcpRow.update(
			'<label style="text-align: center; width: 9%;" title="' + dcpObject.transactionType + '">' + dcpObject.transactionType + '</label>' +
			'<label style="text-align: center; width: 16%;" title="' + dcpObject.adviceNumber + '">' + dcpSequence + '</label>' + 
		    '<label style="text-align: center; width: 15%;" title="' + dcpObject.payee + '">' + payeeShrt + '</label>' +
		    '<label style="text-align: center; width: 5%;" title="' + dcpObject.assuredName + '">' + ashortName + '</label>' +
		    //'<label style="text-align: center; width: 5%;" title="' + dcpObject.perilCode + '">' + dcpObject.assuredName + '</label>' +
		    '<label style="text-align: right;  width: 13.5%;">' + formatCurrency(dcpObject.disbursementAmount) + '</label>' +
		    '<label style="text-align: right;  width: 13.5%;">' + formatCurrency(dcpObject.inputVatAmount) + '</label>' + 
		    '<label style="text-align: right;  width: 13.5%;">' + formatCurrency(dcpObject.withholdingTaxAmount) + '</label>' + 
		    '<label style="text-align: right;  width: 13.5%;">' + formatCurrency(dcpObject.netDisbursementAmount) + '</label>');
	
	loadRowMouseOverMouseOutObserver(dcpRow);

	dcpRow.observe("click", function(){
		dcpRow.toggleClassName("selectedRow");
		if(dcpRow.hasClassName("selectedRow")){
			$$("div[name='dcpRow']").each(function(anotherRow){
				if(dcpRow.id != anotherRow.id){
					anotherRow.removeClassName("selectedRow");
				}else{
					var postFix = dcpRow.id.substr(6);
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
			$("selTransactionType").value	= "";
			$("txtClaimNumber").value		= "";
			$("txtAdviceSequence").value	= "";
			$("txtPolicyNumber").value 		= "";
			$("txtPayee").value				= "";
			$("selPayeeClass").update("<option></option>");
			$("txtPeril").value				= "";
			$("txtAssuredName").value 		= "";
			$("txtDisbursementAmount").value= "";
			$("txtRemarks").value 			= "";
			$("txtInputTax").value			= "";
			$("txtWithholdingTax").value	= "";
			$("txtNetDisbursement").value	= "";	
			disableButton("btnRemoveDirectClaimPayment");
			enableButton("btnAddDirectClaimPayment");
			$("btnAddDirectClaimPayment").value = "Add";
			disableButton("btnClaimAdvice");
			disableButton("btnBatchClaim");
		}
	});
	return dcpRow;
}