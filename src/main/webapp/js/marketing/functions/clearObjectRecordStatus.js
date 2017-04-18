/**
 * Reset record status properties for each object in object array
 * @param object array
 */
function clearObjectRecordStatus(obj){
	for(var i=0; i<obj.length; i++){
		if(obj[i].recordStatus == -1){
			obj.splice(i,1);
			i--;
		}else{
			obj[i].recordStatus = null;
		}
	}
}