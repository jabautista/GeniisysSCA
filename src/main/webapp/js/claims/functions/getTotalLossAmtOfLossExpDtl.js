function getTotalLossAmtOfLossExpDtl(addedDtlAmt){
	var totalLossAmt = 0;
	var lossExpCd = $("txtLoss").getAttribute("lossExpCd");
	
	for(var i=0; i<objGICLLossExpDtl.length; i++){
		if(objGICLLossExpDtl[i].recordStatus != -1 && unescapeHTML2(lossExpCd) != unescapeHTML2(objGICLLossExpDtl[i].lossExpCd)){
			totalLossAmt = parseFloat(nvl(totalLossAmt,0)) + parseFloat(nvl(objGICLLossExpDtl[i].dtlAmt, 0));
		}
	}
	
	totalLossAmt = parseFloat(nvl(totalLossAmt,0)) + parseFloat(nvl(addedDtlAmt, 0));
	return totalLossAmt;
}