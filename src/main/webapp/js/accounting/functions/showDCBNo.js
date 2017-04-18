function showDCBNo() {
	var v_dcbNo;
	if ($F("existingDCBNo") != 0) {
		v_dcbNo = $F("existingDCBNo");
	} else if ($F("newDCBNo") != 0) {
		v_dcbNo = $F("newDCBNo");
	} else if ($F("newDCBNo") == 0) {
		v_dcbNo = parseInt($F("newDCBNo")) + 1;
	}
	$("dcbNo").value = v_dcbNo;
	$("cashierCd").value = $F("cashierCode");
	$("existingDCBNo").value = v_dcbNo;
	if (objACGlobal.commSlip == 1) {
		showCommSlip();
		objACGlobal.commSlip = 0;
	}
}