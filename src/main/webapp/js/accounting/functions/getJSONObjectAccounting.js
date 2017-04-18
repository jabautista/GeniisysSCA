/**
 * Retrieves the json object having :objId id property from :objArray - generic
 * function
 * 
 * @return
 */
function getJSONObjectAccounting(objArray, objId) {
	for ( var i = 0; i < objArray.length; i++) {
		if (objArray[i].id == objId) {
			return objArray[i];
		}
	}
	return null; // if not found
}