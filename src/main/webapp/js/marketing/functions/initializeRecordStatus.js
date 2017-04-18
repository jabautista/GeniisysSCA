/**
 * In case object.java has no recordStatus field of its own (only the inherited
 * recordStatus from Entity.java)
 * @param objArray
 * @return
 */
function initializeRecordStatus(jsonObjArray){
	for(var i=0; i<jsonObjArray.length; i++){
		jsonObjArray[i].recordStatus = 0;
	}
}