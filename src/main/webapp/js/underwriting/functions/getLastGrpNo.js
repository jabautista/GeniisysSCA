/**
 * Gets the last or maximum distSeqNo from the objArray. 
 * @param objArray - contains the information
 * @return lastGrpNo - the last or maximum distSeqNo
 */

function getLastGrpNo(objArray){
	var lastGrpNo = 0;
	
	for(var i=0; i<objArray.length; i++){
		if(parseInt(objArray[i].distSeqNo) > parseInt(lastGrpNo)){
			lastGrpNo = parseInt(objArray[i].distSeqNo);
		}
	}	
	return lastGrpNo;
}