/**
 * Counts the items having the same  
 * group no with the parameter group no. 
 * @param objArray - contains the information
 * @param groupNo - group no to be compared with
 * @return ctr - number of items with the same group no.
 */

function countItemsPerGroup(objArray, groupNo){
	var ctr = 0;
	for(var i=0; i<objArray.length; i++){
		if(parseInt(objArray[i].distSeqNo) == parseInt(groupNo)){
			ctr++;
		}
	}
	return ctr++;
}