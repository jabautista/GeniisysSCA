/**
 * Clears the Direct Claim Payment form - GIACS017
 * @author rencela
 */
function clearDcpForm(){	
	$("selTransactionType").selectedIndex 	= 0;
	$("txtAdviceSequence").value			= "";
	$("selPayeeClass").update("<option></option>");
	$("txtClaimNumber").value			= "";
	$("txtPolicyNumber").value			= "";
	$("txtPayee").value					= "";
	$("txtAssuredName").value			= "";
	$("txtRemarks").value				= "";
	$("txtPeril").value					= "";
	$("txtDisbursementAmount").value	= "";
	$("txtInputTax").value				= "";
	$("txtWithholdingTax").value		= "";
	$("txtNetDisbursement").value		= "";
	$("dcpCurrencyCode").value			= "";
	$("dcpConvertRate").value			= "";
	$("dcpCurrencyDesc").value			= "";
	$("dcpForeignCurrencyAmt").value	= "";
}