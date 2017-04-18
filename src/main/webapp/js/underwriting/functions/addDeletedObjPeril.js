/*
 * Created By	: Bryan Joseph G. Abuluyan
 * Date			: November 22, 2010
 * Description	: deletes current peril from the JSON array
 * Parameters	: objArray - the JSON array for perils
 * 				  deletedObj - object deleted
 */
function addDeletedObjPeril(objArray, deletedObj) {
	try{
		deletedObj.recordStatus = -1;		
		for (var i=0; i<objArray.length; i++) {		
			if(objArray[i].itemNo == deletedObj.itemNo && objArray[i].perilCd == deletedObj.perilCd){				
				objArray.splice(i, 1);
				objArray.push(deletedObj);
			}
		}
	}catch(e){
		showErrorMessage("addDeletedObjPeril", e);
	}	
}