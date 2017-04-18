// validate default amount if valid -- nica 12.29.2010
function validateDefaultAmount(amt, gaccTranId) {
	var inputAmt = ($("amount").value).replace(/,/g, '');
	$("hidDefaultAmt").value = amt;

	if ($("amount").value == null || $("amount").value == "") {
		$("amount").value = formatCurrency(amt);
		$("hidGaccTranId").value = gaccTranId;
	} else if (Math.abs(inputAmt) > Math.abs(amt)) {
		showMessageBox("Amount should not exceed "
				+ formatCurrency(Math.abs(amt) * -1) + ".", imgMessage.ERROR);
		$("amount").value = "";
	}
}