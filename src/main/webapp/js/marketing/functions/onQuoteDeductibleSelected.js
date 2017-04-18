function onQuoteDeductibleSelected(deductible, perilTsiAmount){
	var amount  = deductible.deductibleAmt;
	var rate 	= deductible.deductibleRate;
	
	$("txtDeductibleTitle").value = unescapeHTML2(deductible.deductibleTitle);
	$("txtDeductibleTitle").writeAttribute("deductibleCd", unescapeHTML2(deductible.deductibleCd));
	$("txtDeductibleTitle").writeAttribute("deductibleType", deductible.deductibleType);
	$("txtDeductibleTitle").writeAttribute("minAmt", deductible.minimumAmount);
	$("txtDeductibleTitle").writeAttribute("maxAmt", deductible.maximumAmount);
	$("txtDeductibleTitle").writeAttribute("rangeSw", deductible.rangeSw);
	$("txtDeductibleAmt").value = (amount == null  || amount == "" ? "" : formatCurrency(amount));
	$("txtDeductibleRate").value   = (rate == null || rate == "" ? "" : formatToNineDecimal(rate));
	$("txtDeductibleText").value   = unescapeHTML2(deductible.deductibleText);
	
	var tempType = deductible.deductibleType;
	
	if (tempType == "T"){
		var minAmt  = nvl(deductible.minimumAmount,""); //added by steven 1/3/2013 "nvl"
		var maxAmt  = nvl(deductible.maximumAmount,""); //added by steven 1/3/2013 "nvl"
		var rangeSw = deductible.rangeSw;
		var amount  = parseFloat(perilTsiAmount) * (parseFloat(rate)/100);
		
		if(rate != ""){
			if (minAmt != "" && maxAmt != ""){
				if (rangeSw == "H"){
					$("txtDeductibleAmt").value = formatCurrency(Math.min(Math.max(amount, minAmt), maxAmt));
				} else if (rangeSw == "L"){
					$("txtDeductibleAmt").value = formatCurrency(Math.min(Math.max(amount, minAmt), maxAmt));
				} else {
					$("txtDeductibleAmt").value = formatCurrency(maxAmt);
				}
			} else if (minAmt != ""){
				$("txtDeductibleAmt").value = formatCurrency(Math.max(amount, minAmt));	
			} else if (maxAmt != ""){
				$("txtDeductibleAmt").value = formatCurrency(Math.min(amount, maxAmt));
			} else{
				$("txtDeductibleAmt").value = formatCurrency(amount);
			}
		}else{
			if (minAmt != ""){
				$("txtDeductibleAmt").value = formatCurrency(minAmt);
			} else if (maxAmt != ""){
				$("txtDeductibleAmt").value = formatCurrency(maxAmt);
			}
		}
	}
}