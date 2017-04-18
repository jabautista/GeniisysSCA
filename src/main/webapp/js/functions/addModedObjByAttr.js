/*	Created by	: mark jm 10.13.2010
 * 	Description	: replace existing object to modified object
 * 	Parameters	: objArray - object array that holds object listing
 * 				: editedObj - object that will replace the modified one
 * 				: attributeList - space-separated string used for checking before replacing an object
 */
function addModedObjByAttr(objArray, editedObj, attributeList){
	editedObj.recordStatus = 1;
	for(var i=0; i<objArray.length; i++){
		if(objArray[i].itemNo == editedObj.itemNo){
			var attList = $w(attributeList);
			var apply = false;
			
			for(var x=0; x < attList.length; x++){				
				if(objArray[i][attList[x]] == editedObj[attList[x]]){
					apply = true;
				}else{
					apply = false; 
				}
			}
			
			if(apply){
				objArray.splice(i, 1);
				objArray.push(editedObj);
			}
		}
	}
}