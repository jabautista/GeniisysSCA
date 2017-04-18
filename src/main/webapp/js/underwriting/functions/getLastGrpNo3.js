function getLastGrpNo3(tableGrid){
	var lastDistSeqNoArr = 0;
	var maxDistSeqNo = 0;
	var lastGrpNo = 0;
	var objArray = tableGrid.geniisysRows;
	var cntMax = 0 ; 
	var maxInCurrPage ; 


	for(var i=0; i<objArray.length; i++){
		maxDistSeqNo = objArray[i].maxDistSeqNo;
		if(parseInt(objArray[i].distSeqNo) > parseInt(lastDistSeqNoArr)){
			lastDistSeqNoArr = parseInt(objArray[i].distSeqNo);
		}
	}		
	cntMax = countItemsPerGroup2(tableGrid, maxDistSeqNo) ; 

	maxInCurrPage = false;
	for(var i=0; i<objArray.length; i++){		
		if ( (parseInt(objArray[i].distSeqNo) == parseInt(maxDistSeqNo)) || (parseInt(objArray[i].origDistSeqNo) == parseInt(maxDistSeqNo))){
			maxInCurrPage = true;
			break;
		}
	}		
	
	if ( (maxDistSeqNo > lastDistSeqNoArr) && (cntMax > 0  || maxInCurrPage == false ) ) {
		lastGrpNo = maxDistSeqNo;
	}else {
		lastGrpNo = lastDistSeqNoArr;
	}
	
	
	return lastGrpNo;
}