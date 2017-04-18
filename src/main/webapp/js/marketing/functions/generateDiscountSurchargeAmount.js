function generateDiscountSurchargeAmount(discSurgParam, premAmtField){
	var discSurgAmt = 0;
	discSurgAmt = Math.round(((parseFloat($(premAmtField).value.replace(/,/g, "")) * parseFloat($(discSurgParam).value)) / 100)*10000)/10000;
	if (isNaN(discSurgAmt) || discSurgAmt < 0 || discSurgAmt == 'Infinity'){
		discSurgAmt = 0;
	}
	return formatCurrency(discSurgAmt);
}