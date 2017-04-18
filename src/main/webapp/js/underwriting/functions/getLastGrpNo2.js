//belle 09062011 
function getLastGrpNo2(objArray){
	var lastDistSeqNoArr = 0;
	var maxDistSeqNo = 0;
	var lastGrpNo = 0;
	
	for(var i=0; i<objArray.length; i++){
		maxDistSeqNo = objArray[i].maxDistSeqNo;
		if(parseInt(objArray[i].distSeqNo) > parseInt(lastDistSeqNoArr)){
			lastDistSeqNoArr = parseInt(objArray[i].distSeqNo);
		}
	}	
	
	if (maxDistSeqNo > lastDistSeqNoArr){
		lastGrpNo = maxDistSeqNo;
	}else {
		lastGrpNo = lastDistSeqNoArr;
	}
	
	return lastGrpNo;
}