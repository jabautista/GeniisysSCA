/*	Created by	: belle bebing 04072011
 * 	Description	: another version of copyPeril (for copyPeril button) 
 * 	Parameter	: objArray - array of objects that holds all the records of a certain table
 * 				: itemNo - primary key for comparison
 * 				: nextItemNo - the next primary key
 * 				: tableListing - name/id of the table where the new row will be added
 * 				: idList - space-separated string containing the columns that will compose the row'id
 * 				: subpageName - name of the subpage used for creating row details
 */
function copyPeril1(objArray, itemNo, nextItemNo, tableListing, idList, subpageName){
	try{
		var objFilteredArr = objArray.filter(function(obj){	return obj.itemNo == itemNo && nvl(obj.recordStatus, 0) != -1;	});
		var objItemPeril = new Array();
		if(objFilteredArr.length > 0){
			var copyObj = new Object();
			var length 	= objFilteredArr.length;
			for(var i=0; i < length; i++){				
				copyObj = cloneObject(objFilteredArr[i]);				
				copyObj.itemNo = nextItemNo;
				copyObj.recordStatus = 0;				
				objArray.push(copyObj);
				objItemPeril.push(copyObj);
				//remove by steven 10/24/2012
//				var content = getSubpageContent(subpageName, copyObj);
//				var table = $(tableListing);
//				var newDiv = new Element("div");
//				var idCombination = "" + nextItemNo;
//				var idListing = $w(idList);
//				
//				for(var x=0, idLength=idListing.length; x < idLength; x++){
//					idCombination += objFilteredArr[i][idListing[x]];
//				}
//				setItemPerilMotherDiv(copyObj.itemNo);
//				addObjToPerilTable(copyObj);
				
			}
			saveCopiedPeril(getAddedAndModifiedJSONObjects(objItemPeril));
			delete copyObj;
		}
	}catch(e){
		showErrorMessage("copyPeril1", e);		
	}
}