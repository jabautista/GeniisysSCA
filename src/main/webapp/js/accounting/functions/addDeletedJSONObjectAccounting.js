/**
 * Add deleted JSON object to JSON array if records not newly added record.
 * (record status not equal to 0)
 * 
 * @author Jerome Orio 09.27.2010
 * @version 1.0
 * @param JSON
 *            array , JSON object to be deleted
 * @return
 */
function addDeletedJSONObjectAccounting(objArray, deletedObj) {
	var removed = false;
	for ( var i = 0; i < objArray.length; i++) {
		if (objArray[i].recordStatus != 0
				&& objArray[i].divCtrId == deletedObj.divCtrId) {
			objArray.splice(i, 1);
			removed = true;
		} else if (objArray[i].recordStatus == 0
				&& objArray[i].divCtrId == deletedObj.divCtrId) {
			objArray.splice(i, 1); // to remove the newly added record that not
			// exist in database
		}
	}
	if (removed) {
		deletedObj.recordStatus = -1;
		objArray.push(deletedObj);
	}
}