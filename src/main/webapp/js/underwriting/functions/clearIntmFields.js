/* emman 05.04.10
 * clear intm fields
 * /underwriting/invoiceCommission.jsp
 */
function clearIntmFields() {
	$("inputIntermediaryNo").value = "";
	$("inputIntermediaryName").value = "";
	$("inputParentIntermediaryNo").value = "";
	$("inputParentIntermediaryName").value = "";
	$("inputPercentage").value = 0;
	$("inputPremium").value = "0.00";
	$("inputTotalCommission").value = "0.00";
	$("inputNetCommission").value = "0.00";
	$("inputTotalWithholdingTax").value = 0;

	$("inputIntermediaryName").style.display = "none";
	$($("currentIntmListing").value).value = "";
	$($("currentIntmListing").value).style.display = "inline";				
	$("prevSharePercentage").value = 0;
	$("btnSaveIntm").value = "Add";
	disableButton("btnDeleteIntm");
}