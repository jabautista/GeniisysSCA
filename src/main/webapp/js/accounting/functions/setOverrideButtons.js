function setOverrideButtons() {
	if (objAC.overideOk) {
		if ($F("btnAdd") == "Add") {
			if ($F("amount") != "" && !isNaN(unformatCurrency("amount"))) {
				if (objAC.overrideDef == 'Y') {
					disableButton("overrideDefBtn");
					enableButton("revertBtn");
				} else {
					enableButton("overrideDefBtn");
					disableButton("revertBtn");
				}
			} else {
				disableButton("overrideDefBtn");
				disableButton("revertBtn");
			}
		} else {
			if ($F("amount") != "" && !isNaN(unformatCurrency("amount"))) {
				if (objAC.overrideDef == 'Y') {
					disableButton("overrideDefBtn");
					enableButton("revertBtn");
				} else {
					enableButton("overrideDefBtn");
					disableButton("revertBtn");
				}
			} else {
				disableButton("overrideDefBtn");
				disableButton("revertBtn");
			}

			if ($F("hiddenRecStatus") == "") {
				disableButton("overrideDefBtn");
				disableButton("revertBtn");
			}
		}
	} else {
		disableButton("overrideDefBtn");
		disableButton("revertBtn");
	}
}