/* emman 05.04.10
 * clear intm no, parent intm no, and names
 * /underwriting/invoiceCommission.jsp
 */
function clearIntmNo() {
	$("intmListing").selectedIndex = 0;
	$("inputIntermediaryNo").value = "";
	$("inputParentIntermediaryNo").value = "";
	$("inputParentIntermediaryName").value = "";
}