/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.12.2011	mark jm			insert the objects copied from existing listing in deductibles based on their item no (tableGrid version) 
 * 								Parameter	: objArray - array of objects that holds all the records of a certain table
 * 											: itemNo - primary key for comparison
 * 											: nextItemNo - the next primary key
 * 											: dedLevel - deductible level
 */
function copyObjectDeductiblesTG(objArray, itemNo, nextItemNo, dedLevel){
	try{
		var objFilteredArr = [];
		
		if(objFormMiscVariables.miscCopyPeril == "Y"){
			objFilteredArr = objArray.filter(function(o){	return o.itemNo == itemNo && nvl(o.recordStatus, 0) != -1;	});
		}else{
			objFilteredArr = objArray.filter(function(o){	return o.itemNo == itemNo && nvl(o.recordStatus, 0) != -1 && nvl(o.perilCd, 0) == 0 && o.deductibleType != "T";	});
		}
		
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
					//addItemDeductibleInTableListing(copyObj);					
				//}
			}			
			delete copyObj;
		}		
	}catch(e){
		showErrorMessage("copyObjectDeductiblesTG", e);
	}
}