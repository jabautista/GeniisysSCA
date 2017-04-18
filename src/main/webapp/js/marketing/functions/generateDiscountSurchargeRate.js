function generateDiscountSurchargeRate(discSurgParam, premAmtField){
	var discSurgRate = 0;
	//added unformatCurrency by robert 11.14.2013
	discSurgRate = Math.round(((/*parseFloat($(discSurgParam).value)*/ parseFloat(unformatCurrency(discSurgParam)) / parseFloat($(premAmtField).value.replace(/,/g, ""))) * 100)*10000)/10000;
	if (isNaN(discSurgRate) || discSurgRate < 0 || discSurgRate == 'Infinity'){
		discSurgRate = 0;
	}
	return formatRate(discSurgRate);
}