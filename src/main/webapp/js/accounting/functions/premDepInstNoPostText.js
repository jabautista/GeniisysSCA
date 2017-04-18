/** of GIACS026 functions */

/*
 * Executes POST-TEXT-ITEM trigger of INST_NO in GIACS026 Emman Sept 15, 2010
 */
function premDepInstNoPostText() {
	if (isNaN($F("txtInstNo"))) {
		$("txtInstNo").value = $F("lastInstNo");
		showMessageBox("Invalid installment no. Value must be from 1 to 99",
				imgMessage.ERROR);// emsy 4.4.2012 ~ edited error message
		return false;
	} else if (parseInt($F("txtInstNo").replace(/,/g, "")) > 99
			|| parseInt($F("txtInstNo").replace(/,/g, "")) < 1) {
		$("txtInstNo").value = $F("lastInstNo");
		showMessageBox("Invalid installment no. Value must be from 1 to 99",
				imgMessage.ERROR);
	} else if (getDecimalLength($F("txtInstNo")) > 0) {
		showMessageBox("Invalid installment no. Value must be from 1 to 99",
				imgMessage.ERROR);
		$("txtInstNo").value = $F("lastInstNo");
		$("txtInstNo").focus();
		return false;
	} else {
		$("txtInstNo").value = $F("txtInstNo").blank() ? "" : parseInt(
				$F("txtInstNo"), 10).toPaddedString(2);
		$("lastInstNo").value = $F("txtInstNo");
		if ($F("txtB140IssCd").blank() || $F("txtB140PremSeqNo").blank()
				|| $F("txtInstNo").blank()) {
			return false;
		} else {
			if ($F("txtB140IssCd") == "RI") {
				if (validateRiCd()) {
					clearItemsAssociatedWithForeignKey();
					if ($F("currentRowNo") == -1) {
						if (validateTranType1()) {
							getParSeqNo2();
						}
					}
				}
			} else {
				clearItemsAssociatedWithForeignKey();
				if ($F("currentRowNo") == -1) {
					if (validateTranType1()) {
						getParSeqNo2();
					}
				}
			}
		}
	}
}