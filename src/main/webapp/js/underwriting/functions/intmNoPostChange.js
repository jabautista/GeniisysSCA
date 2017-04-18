/* emman 05.04.10
 * after intm no change, update intm no, name, parent intm no and parent intm name
 * /underwriting/invoiceCommission.jsp
 */
function intmNoPostChange() {
	for (i = 1; i < $($("currentIntmListing").value).length; i++) {
		if ($("inputIntermediaryNo").value == $($("currentIntmListing").value).options[i].readAttribute("intmNo")) {
			$("inputParentIntermediaryNo").value = $($("currentIntmListing").value).options[i].readAttribute("parentIntmNo");
			$("inputParentIntermediaryName").value = $($("currentIntmListing").value).options[i].readAttribute("parentIntmName");
			$($("currentIntmListing").value).selectedIndex = i;
			break;
		}
	}
}