/**
 * Counts the items having the same  
 * group no with the parameter group no. regardless of page 
 * @param tableGrid - the tablegrid which contains the information
 * @param groupNo - group no to be compared with
 * @return cntTotalItm - number of items with the same group no. for all pages
 */

//added by jhing 12.05.2014 ( for FULLWEB SIT batch checkin for soln to SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871 )
function countItemsPerGroup2(tableGrid, groupNo){

	var ctr = 0;
	var oldCnt = 0 ; 
	var cntOldCurPage = 0 ; 
	var objArray = tableGrid.geniisysRows;
	var cntTotalItm = 0 ; 
	
	for(var i=0; i<objArray.length; i++){
		if(parseInt(objArray[i].distSeqNo) == parseInt(groupNo) && (objArray[i].distSeqNo == objArray[i].origDistSeqNo)){
			oldCnt = parseInt(objArray[i].cntPerDistGrp);
			break;
		}
	}	

	for(var i=0; i<objArray.length; i++){
		if(parseInt(objArray[i].origDistSeqNo) == parseInt(groupNo)){
			cntOldCurPage++;
		}
	}

	for(var i=0; i<objArray.length; i++){
		if(parseInt(objArray[i].distSeqNo) == parseInt(groupNo)){
			ctr++;
		}
	}
	
	cntTotalItm = (oldCnt - cntOldCurPage ) + ctr ; 
	return cntTotalItm++;
}