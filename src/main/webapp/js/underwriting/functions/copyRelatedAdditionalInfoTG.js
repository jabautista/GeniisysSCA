/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.12.2011	mark jm			insert the objects copied from existing listing based on their item no (tableGrid version) 
 * 								Parameter	: objArray - array of objects that holds all the records of a certain table
 * 											: itemNo - primary key for comparison
 * 											: nextItemNo - the next primary key
 */
function copyRelatedAdditionalInfoTG(objArray, itemNo, nextItemNo){
	try{
		var objFilteredArr = objArray.filter(function(obj){	return obj.itemNo == itemNo && nvl(obj.recordStatus, 0) != -1;	});
		
		if(objFilteredArr.length > 0){
			var copyObj = new Object();
			var length = objFilteredArr.length;
			
			for(var i=0; i < length; i++){				
				copyObj = cloneObject(objFilteredArr[i]);
				copyObj.itemNo = nextItemNo;
				copyObj.recordStatus = 2;				
				objArray.push(copyObj);				
			}

			delete copyObj;
		}		
	}catch(e){
		showErrorMessage("copyRelatedAdditionalInfoTG", e);
	}
}