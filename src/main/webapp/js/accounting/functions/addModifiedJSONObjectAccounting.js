/**
 * Add updated JSON object to JSON array and replace the existing object
 * 
 * @author Jerome Orio 09.27.2010
 * @version 1.0
 * @param
 * @return
 */
function addModifiedJSONObjectAccounting(objArray, editedObj) {
	editedObj.recordStatus = editedObj.recordStatus == 0 ? 0 : 1; // if record
	// is newly
	// added(not
	// yet
	// saved)
	// the
	// status
	// will
	// remain 0
	// else 1
	for ( var i = 0; i < objArray.length; i++) {
		if (objArray[i].divCtrId == editedObj.divCtrId) {
			objArray.splice(i, 1);
		}
	}
	objArray.push(editedObj);
}