/**
 * Check if theres an existing changes on Object Array
 * 
 * @author Jerome Orio 09.28.2010
 * @version 1.0
 * @param object
 *            array
 * @return true if exist, false if not
 */
function checkObjectIfChangesExist(objArray) {
	var exist = false;
	for ( var a = 0; a < objArray.length; a++) {
		if (objArray[a].recordStatus != null) {
			exist = true;
		}
	}
	return exist;
}