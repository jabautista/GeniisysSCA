//belle 09062011
function getNextGrpNo2(objArray) {
	var lastGrpNo = getLastGrpNo2(objArray);
	var nextGrpNo = (parseInt(lastGrpNo))+1;
	
	return (nextGrpNo);
}