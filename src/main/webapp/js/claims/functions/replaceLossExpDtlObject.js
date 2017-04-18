function replaceLossExpDtlObject(newObj){
	for(var i=0; i<objGICLLossExpDtl.length; i++){
		var lossExpDtl = objGICLLossExpDtl[i];
		if(lossExpDtl.claimId == newObj.claimId &&
		   lossExpDtl.clmLossId == newObj.clmLossId &&
		   lossExpDtl.lossExpCd == newObj.lossExpCd){
			if(lossExpDtl.recordStatus == "0" && newObj.recordStatus == "-1"){
				objGICLLossExpDtl.splice(i,1);
			}else{
				objGICLLossExpDtl.splice(i,1,newObj);
			}
		}
	}
}