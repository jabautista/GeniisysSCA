function replaceLossExpPayeeObject(newObj){
	for(var i=0; i<objGICLLossExpPayees.length; i++){
		var payee = objGICLLossExpPayees[i];
		if(payee.claimId == newObj.claimId && payee.itemNo  == newObj.itemNo &&
		   payee.perilCd == newObj.perilCd && payee.payeeType == newObj.payeeType &&
		   payee.payeeClassCd == newObj.payeeClassCd && payee.payeeCd == payee.payeeCd){
		   if(payee.recordStatus == "0" && newObj.recordStatus == "-1"){
			   objGICLLossExpPayees.splice(i,1);
		   }else{
			   objGICLLossExpPayees.splice(i,1,newObj);
		   }
		}
	}
}