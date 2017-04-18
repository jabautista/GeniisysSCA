/*
 * Created By	: Bryan Joseph G. Abuluyan
 * Date			: November 22, 2010
 * Description	: updates current peril in the JSON array
 * Parameters	: objArray - the JSON array for perils
 * 				  editedObj - the updated peril object
 */
function updateObjPeril(objArray, editedObj) {
	editedObj.recordStatus = 1;
	for (var i=0; i<objArray.length; i++) {
		if((objArray[i].itemNo == editedObj.itemNo) && (objArray[i].perilCd == editedObj.perilCd)){
			objArray.splice(i, 1);
			objArray.push(editedObj);
			//prepareItemPerilforDelete(2); //remove this when JSON is fully-implemented
		}
	}		
}