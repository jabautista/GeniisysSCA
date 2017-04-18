function computeTotalDeductibleAmt(){
	var totalDeductibleAmt = 0;
	for(var i=0; i<objLossExpDeductibles.length; i++){
		if(objLossExpDeductibles[i].recordStatus != -1){
			totalDeductibleAmt = parseFloat(nvl(totalDeductibleAmt,0)) + parseFloat(nvl(objLossExpDeductibles[i].dtlAmt, 0));
		}
	}
	
	$("totalDedAmt").value    = formatCurrency(totalDeductibleAmt);
}