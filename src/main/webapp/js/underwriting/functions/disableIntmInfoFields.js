/* emman 05.04.10
 * disable intm info fields
 * /underwriting/invoiceCommission.jsp
 */
function disableIntmInfoFields() {
	$("inputPercentage").disable();
	$("lovTag").disable();
	$("inputIntermediaryNo").disable();
	$($("currentIntmListing").value).disable();
	disableButton("btnSaveIntm");
	if ($("btnSaveIntm").value == "Update") {
		disableButton("btnDeleteIntm");
	}
}