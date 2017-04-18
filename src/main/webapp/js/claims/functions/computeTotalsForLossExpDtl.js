function computeTotalsForLossExpDtl(){
	var totalLossAmt = 0;
	var totalAmtLessDed = 0;
	for(var i=0; i<objGICLLossExpDtl.length; i++){
		if(objGICLLossExpDtl[i].recordStatus != -1){
			totalAmtLessDed = parseFloat(nvl(totalAmtLessDed,0)) + parseFloat(nvl(objGICLLossExpDtl[i].nbtNetAmt,0));
			totalLossAmt = parseFloat(nvl(totalLossAmt,0)) + parseFloat(nvl(objGICLLossExpDtl[i].dtlAmt, 0));
		}
	}
	
	$("totalLossAmt").value    = formatCurrency(totalLossAmt);
	$("totalAmtLessDed").value = formatCurrency(totalAmtLessDed);
}