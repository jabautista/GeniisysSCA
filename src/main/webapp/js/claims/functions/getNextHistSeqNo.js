function getNextHistSeqNo(){
	var max = 0;
	max = giclClmLossExpenseTableGrid.pager.total; //Added by Jerome Bautista 11.12.2015 SR 20648
	for(var i=0; i<objGICLClmLossExpense.length; i++){
		var clmLossExp = objGICLClmLossExpense[i];
		if(clmLossExp.recordStatus != -1){
			if(parseInt(nvl(clmLossExp.historySequenceNumber, 0)) > parseInt(max)){
				max = clmLossExp.historySequenceNumber;
			}
		}
	}
	return parseInt(max) + 1;
}