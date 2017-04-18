/*	Created by	: mark jm 10.21.201
 * 	Description	: insert the objects copied from existing listing in deductibles based on their item no
 * 				: creates hidden row for display
 * 	Parameter	: objArray - array of objects that holds all the records of a certain table
 * 				: itemNo - primary key for comparison
 * 				: nextItemNo - the next primary key
 * 				: tableListing - name/id of the table where the new row will be added
 * 				: rowName - name of the div/row that will be added
 * 				: idList - space-separated string containing the columns that will compose the row'id
 * 				: subpageName - name of the subpage used for creating row details
 * 				: labelName - name of the label used in row details
 * 				: dedLevel - deductible level
 */
function copyObjectDeductibles(objArray, itemNo, nextItemNo, tableListing, rowName, idList, subpageName, labelName, dedLevel){
	try{
		var objFilteredArr = objArray.filter(function(obj){	return obj.itemNo == itemNo && nvl(obj.recordStatus, 0) != -1 && nvl(obj.perilCd, 0) == 0;	});
		
		if(objFilteredArr.length > 0){
			var copyObj = new Object();
			var length	= objFilteredArr.length;
			
			for(var i=0; i < length; i++){
				//if(objArray[i].itemNo == itemNo && objArray[i].recordStatus != -1 && (nvl(objArray[i].perilCd, 0) == 0)){
					copyObj = cloneObject(objFilteredArr[i]);
					copyObj.itemNo = nextItemNo;
					copyObj.recordStatus = 2;
					copyObj.dedLevel = dedLevel;
					objArray.push(copyObj);
					
					addItemDeductibleInTableListing(copyObj);					
				//}
			}			
			delete copyObj;
		}		
	}catch(e){
		showErrorMessage("copyObjectDeductibles", e);
	}
}