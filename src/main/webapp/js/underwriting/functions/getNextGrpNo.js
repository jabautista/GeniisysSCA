/**
 * Gets the next distSeqNo from the objArray. 
 * @param objArray - contains the information
 * @return nextGrpNo - the next distSeqNo
 */

function getNextGrpNo(objArray){

	var lastGrpNo = getLastGrpNo(objArray);
    var nextGrpNo =(parseInt(lastGrpNo))+1;
    
    return (nextGrpNo);
}