/**
 * 
 */
function prepareDirectClaimPaymentContents(dcpObject){
	var properties = "";
	var payeeShrt = "";

	if(dcpObject.payee.length > 14){	
		payeeShrt = dcpObject.payee.substr(0,13) + "...";
	}else{
		payeeShrt = dcpObject.payee;
	}
	
	properties += "<label style='text-align: center; width: 9%;' title='" + dcpObject.transactionType + "'>" + dcpObject.transactionType + "</label>";
    properties += "<label style='text-align: center; width: 16%;' title='" + dcpObject.adviceNumber + "'>" + dcpObject.adviceNumber + "</label>";
    properties += "<label style='text-align: center; width: 15%;' title='" + dcpObject.payee + "'>" + payeeShrt + "</label>";
    properties += "<label style='text-align: center; width: 5%;' title='" + dcpObject.perilCode + "'>" + dcpObject.perilCode + "</label>";    		
    properties += "<label style='text-align: right;  width: 13.5%;'>" + formatCurrency(dcpObject.disbursementAmount) + "</label>";
    properties += "<label style='text-align: right;  width: 13.5%;'>" + formatCurrency(dcpObject.inputVatAmount) + "</label>";
    properties += "<label style='text-align: right;  width: 13.5%;'>" + formatCurrency(dcpObject.withholdingTaxAmount) + "</label>";
    properties += "<label style='text-align: right;  width: 13.5%;'>" + formatCurrency(dcpObject.netDisbursementAmount) + "</label>";
    
    // remove the ff later - for value reference only
    properties += "<input type='hidden' name='dcpTransactionType'	id='dcpTransactionType"	+ dcpObject.adviceNumber + "' value='" + dcpObject.transactionType 	+ "'/>";    		
	properties += "<input type='hidden' name='dcpClaimId'			id='dcpClaimId"			+ dcpObject.adviceNumber + "' value='" + dcpObject.claimId + "'/>";
	properties += "<input type='hidden' name='dcpClaimNumber'		id='dcpClaimNumber"		+ dcpObject.adviceNumber + "' value='" + dcpObject.claimNumber + "'/>";    		
	properties += "<input type='hidden' name='dcpAdviceLine'		id='dcpAdviceLine"		+ dcpObject.adviceNumber + "' value='" + dcpObject.lineCode + "'/>";
	properties += "<input type='hidden' name='dcpAdviceIssCd'		id='dcpAdviceIssCd"		+ dcpObject.adviceNumber + "' value='" + dcpObject.issueCode + "'/>";    		
	properties += "<input type='hidden' name='dcpAdviceYear'		id='dcpAdviceYear"		+ dcpObject.adviceNumber + "' value='" + dcpObject.adviceYear + "'/>";
	properties += "<input type='hidden' name='dcpAdviceSequenceNumber' id='dcpAdviceSequenceNumber"	+ dcpObject.adviceNumber  + "' value='" + dcpObject.adviceSequenceNumber + "'/>";
	properties += "<input type='hidden' name='dcpAdviceNumber'		id='dcpAdviceNumber"	+ dcpObject.adviceNumber + "' value='" + dcpObject.adviceNumber + "'/>";
	properties += "<input type='hidden' name='dcpPolicyNumber'		id='dcpPolicyNumber"	+ dcpObject.adviceNumber + "' value='" + dcpObject.policyNumber + "'/>";    		
	properties += "<input type='hidden' name='dcpPayeeClassValue'	id='dcpPayeeClassValue" + dcpObject.adviceNumber + "' value='" + dcpObject.payeeVal + "'/>";
	properties += "<input type='hidden' name='dcpPayeeClass'		id='dcpPayeeClass"		+ dcpObject.adviceNumber + "' value='" + dcpObject.payeeCode + "'/>";    		
	properties += "<input type='hidden' name='dcpPayee'				id='dcpPayee"			+ dcpObject.adviceNumber + "' value='" + dcpObject.payee + "'/>";
	properties += "<input type='hidden' name='dcpPeril'				id='dcpPeril"			+ dcpObject.adviceNumber + "' value='" + dcpObject.perilCode + "'/>";	
	properties += "<input type='hidden' name='dcpName'				id='dcpAssuredName"		+ dcpObject.adviceNumber  + "' value='" + dcpObject.assuredName + "'/>";
	properties += "<input type='hidden' name='dcpDisbursementAmount' id='dcpDisbursementAmount" + dcpObject.adviceNumber  + "' value='" + dcpObject.disbursementAmount + "'/>";    		
	properties += "<input type='hidden' name='dcpRemarks'			id='dcpRemarks"			+ dcpObject.adviceNumber + "' value='" + dcpObject.remarks + "'/>";
	properties += "<input type='hidden' name='dcpInputTax'			id='dcpInputTax"		+ dcpObject.adviceNumber + "' value='" + dcpObject.inputVatAmount + "'/>";    		
	properties += "<input type='hidden' name='dcpWithholdingTax'	id='dcpWithholdingTax"	+ dcpObject.adviceNumber + "' value='" + dcpObject.withholdingTaxAmount	+ "'/>";
	properties += "<input type='hidden' name='dcpNetDisbursement'	id='dcpNetDisbursement" + dcpObject.adviceNumber + "' value='" + dcpObject.netDisbursementAmount + "'/>";    		
	properties += "<input type='hidden' name='dcpClaimLossId'		id='dcpClaimLossId"		+ dcpObject.adviceNumber + "' value='" + dcpObject.claimLossId + "'/>";
	properties += "<input type='hidden' name='dcpPayeeType'			id='dcpPayeeType"		+ dcpObject.adviceNumber + "' value='" + dcpObject.payeeType + "'/>";
    
	return properties;
}