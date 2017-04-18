function replaceClmLossExpObject(newObj){
	for(var i=0; i<objGICLClmLossExpense.length; i++){
		var clmLossExp = objGICLClmLossExpense[i];
		if(clmLossExp.claimId == newObj.claimId && 
		   clmLossExp.claimLossId == newObj.claimLossId){
			if(clmLossExp.recordStatus == "0" && newObj.recordStatus == "-1"){
				objGICLClmLossExpense.splice(i,1);
			}else{
				objGICLClmLossExpense.splice(i,1,newObj);
			}
		}
	}
}