function deleteEvalDeductible(obj){
	for(var i=0; i<objGICLEvalDeductiblesArr.length; i++){
		var ded = objGICLEvalDeductiblesArr[i];
		if(ded.evalId == obj.evalId && ded.dedCd == obj.dedCd &&
		   ded.dspExpDesc == obj.dspExpDesc && ded.sublineCd == obj.sublineCd &&
		   ded.noOfUnit == obj.noOfUnit && ded.dedBaseAmt == obj.dedBaseAmt &&
		   ded.dedAmt == obj.dedAmt && ded.dedRate == obj.dedRate &&
		   ded.payeeTypeCd == obj.payeeTypeCd && ded.payeeCd == obj.payeeCd){
			if(obj.recordStatus == "0"){
				objGICLEvalDeductiblesArr.splice(i,1);
			}else{
				obj.recordStatus = -1;
				objGICLEvalDeductiblesArr.splice(i,1,obj);
			}
			break;
		}
	}
}