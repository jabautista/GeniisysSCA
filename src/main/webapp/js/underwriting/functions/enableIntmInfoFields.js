/* emman 05.04.10
 * enable intm info fields
 * /underwriting/invoiceCommission.jsp
 */
function enableIntmInfoFields() {
	$("inputPercentage").enable();
	$("lovTag").enable();
	$("inputIntermediaryNo").enable();
	$($("currentIntmListing").value).enable();
	enableButton("btnSaveIntm");
	if ($("btnSaveIntm").value == "Update") {
		enableButton("btnDeleteIntm");
	}	
}