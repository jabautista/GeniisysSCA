function onDeductibleSelected(deductible, dedLevel) {
	var amount = deductible.deductibleAmt;
	var rate = deductible.deductibleRate;

	$("txtDeductibleCd" + dedLevel).value = deductible.deductibleCd;
	$("txtDeductibleCd" + dedLevel).writeAttribute("deductibleType",
			deductible.deductibleType);
	$("txtDeductibleCd" + dedLevel).writeAttribute("minAmt",
			deductible.minimumAmount);
	$("txtDeductibleCd" + dedLevel).writeAttribute("maxAmt",
			deductible.maximumAmount);
	$("txtDeductibleCd" + dedLevel).writeAttribute("rangeSw",
			deductible.rangeSw);
	$("txtDeductibleDesc" + dedLevel).value = unescapeHTML2(deductible.deductibleTitle);
	$("inputDeductibleAmount" + dedLevel).value = (amount == null
			|| amount == "" ? "" : formatCurrency(amount));
	$("deductibleRate" + dedLevel).value = (rate == null || rate == "" ? ""
			: formatToNineDecimal(rate));
	$("deductibleText" + dedLevel).value = (unescapeHTML2(deductible.deductibleText)
			.replace(/\\n/g, "\n"));

	if (deductible.deductibleType == "T") {
		var itemNum = 1 < dedLevel ? $F("itemNo") : 0;
		// var rate =
		// $("inputDeductible"+dedLevel).options[index].getAttribute("dRate");
		var minAmt = deductible.minimumAmount;
		var maxAmt = deductible.maximumAmount;
		var rangeSw = deductible.rangeSw;
		var amount = parseFloat(getAmount(dedLevel, itemNum))
				* (parseFloat(rate) / 100);

		if (rate != null) {
			if (minAmt != null && maxAmt != null) {
				if (rangeSw == "H") {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
							.min(Math.max(amount, minAmt), maxAmt));
				} else if (rangeSw == "L") {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
							.min(Math.max(amount, minAmt), maxAmt));
				} else {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(maxAmt);
				}
			} else if (minAmt != null) {
				$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
						.max(amount, minAmt));
			} else if (maxAmt != null) {
				$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
						.min(amount, maxAmt));
			} else {
				$("inputDeductibleAmount" + dedLevel).value = formatCurrency(amount);
			}
		} else {
			if (minAmt != null) {
				$("inputDeductibleAmount" + dedLevel).value = formatCurrency(minAmt);
			} else if (maxAmt != null) {
				$("inputDeductibleAmount" + dedLevel).value = formatCurrency(maxAmt);
			}
		}
	}
}