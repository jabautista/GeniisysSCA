/**
 * Check if objArray contains a single record.
 * @param objArray - contains the information
 * @return isSingleRecExists - true if a single record exists.
 */

function checkIfSingleRecExists(objArray){
	var isSingleRecExists = false;
	if(objArray.length == 1){
		isSingleRecExists = true;
	}
	return isSingleRecExists;
}