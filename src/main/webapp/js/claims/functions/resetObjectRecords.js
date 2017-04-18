/**
 * Reset object record status and remove records that 
 * are recently added but not yet saved in the database.
 * @param obj
 */

function resetObjectRecords(obj){
	for(var i = 0; i<obj.length; i++){
		if(obj[i].recordStatus == "0"){
			obj.splice(i,1);
			i--;
		} else {
			obj[i].recordStatus = null;
		}
	}
}