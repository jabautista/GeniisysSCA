/*	Created by	: mark jm 02.17.2011
 * 	Description	: another version of clearObjectRecordStatus
 * 	Parameters	: obj - record list
 */
function clearObjectRecordStatus2(obj){
	try{
		var objArr = obj.filter(function(myObj){	return myObj.recordStatus != -1;	});
		
		obj = null;
		obj = objArr;
		
		for(var i=0, length=obj.length; i<length; i++){
			obj[i].recordStatus = null;
		}
	}catch(e){
		showErrorMessage("clearObjectRecordStatus2", e);		
	}
}