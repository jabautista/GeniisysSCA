function addModifiedEvalDeductible(prevObj, newObj){
	for(var i=0; i<objGICLEvalDeductiblesArr.length; i++){
		var ded = objGICLEvalDeductiblesArr[i];
		if(ded.evalId == prevObj.evalId && ded.dedCd == prevObj.dedCd &&
		   ded.dspExpDesc == prevObj.dspExpDesc && ded.sublineCd == prevObj.sublineCd &&
		   ded.noOfUnit == prevObj.noOfUnit && ded.dedBaseAmt == prevObj.dedBaseAmt &&
		   ded.dedAmt == prevObj.dedAmt && ded.dedRate == prevObj.dedRate &&
		   ded.payeeTypeCd == prevObj.payeeTypeCd && ded.payeeCd == prevObj.payeeCd){
			objGICLEvalDeductiblesArr.splice(i,1,newObj);
			break;
		}
	}
}