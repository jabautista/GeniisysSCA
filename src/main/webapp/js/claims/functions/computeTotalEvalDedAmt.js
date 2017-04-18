function computeTotalEvalDedAmt(){
	var totalDeductibleAmt = 0;
	for(var i=0; i<objGICLEvalDeductiblesArr.length; i++){
		if(objGICLEvalDeductiblesArr[i].recordStatus != -1){
			totalDeductibleAmt = parseFloat(nvl(totalDeductibleAmt,0)) + parseFloat(nvl(objGICLEvalDeductiblesArr[i].dedAmt, 0));
		}
	}
	
	$("totalEvalDedAmt").value    = formatCurrency(totalDeductibleAmt);
}