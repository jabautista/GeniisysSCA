function getTotalLossExpDeductibleAmt(addedDedAmt){
	var totalDedAmt = 0;
	var lossExpCd = $("txtLossExpCd").getAttribute("lossExpCd");
	
	for(var i=0; i<objLossExpDeductibles.length; i++){
		if(objLossExpDeductibles[i].recordStatus != -1 && unescapeHTML2(lossExpCd) != unescapeHTML2(objLossExpDeductibles[i].lossExpCd)){
			totalDedAmt = parseFloat(nvl(totalDedAmt,0)) + parseFloat(nvl(objLossExpDeductibles[i].dtlAmt, 0));
		}
	}
	
	totalDedAmt = parseFloat(nvl(totalDedAmt,0)) + parseFloat(nvl(addedDedAmt, 0));
	return totalDedAmt;
}