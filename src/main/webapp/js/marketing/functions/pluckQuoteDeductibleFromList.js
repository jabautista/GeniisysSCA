function pluckQuoteDeductibleFromList(itemNo, perilCd, deductibleCd){
	var deductibleObj = null;
	for(var i=0; i<objGIPIQuoteDeductiblesSummaryList.length; i++){
		if(//objGIPIQuoteDeductiblesSummaryList[i].recordStatus == -1 && commented by: nica 05.09.2011
				
				objGIPIQuoteDeductiblesSummaryList[i].itemNo == itemNo &&
				objGIPIQuoteDeductiblesSummaryList[i].perilCd == perilCd && 
				objGIPIQuoteDeductiblesSummaryList[i].dedDeductibleCd == deductibleCd){
			deductibleObj = objGIPIQuoteDeductiblesSummaryList[i];
			i = objGIPIQuoteDeductiblesSummaryList.length;
		}
	}
	return deductibleObj;
}