function checkIfLossExpBillAlreadyExist(newObj){
	var exist = false;
	for(var i=0; i<objGICLLossExpBill.length; i++){
		var bill = objGICLLossExpBill[i];
		if(parseInt(newObj.claimId) == parseInt(bill.claimId) && parseInt(newObj.claimLossId) == parseInt(bill.claimLossId) && parseInt(newObj.payeeClassCd) == parseInt(bill.payeeClassCd) && 
		   parseInt(newObj.payeeCd) == parseInt(bill.payeeCd) && newObj.docType == bill.docType && newObj.docNumber == bill.docNumber){
			exist = true;
			break;
		}
	}
	return exist;
}