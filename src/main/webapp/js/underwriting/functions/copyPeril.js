/*	Created by	: mark jm 10.21.201
 * 	Description	: another version of copyObjectPerils (for par use only) 
 * 	Parameter	: objArray - array of objects that holds all the records of a certain table
 * 				: itemNo - primary key for comparison
 * 				: nextItemNo - the next primary key
 * 				: tableListing - name/id of the table where the new row will be added
 * 				: idList - space-separated string containing the columns that will compose the row'id
 * 				: subpageName - name of the subpage used for creating row details
 */
function copyPeril(objArray, itemNo, nextItemNo, tableListing, idList, subpageName){
	try{
		var objFilteredArr = objArray.filter(function(obj){	return obj.itemNo == itemNo && nvl(obj.recordStatus, 0) != -1;	});
		
		if(objFilteredArr.length > 0){
			var copyObj = new Object();
			var length 	= objFilteredArr.length;
			
			for(var i=0; i < length; i++){				
				copyObj = cloneObject(objFilteredArr[i]);				
				copyObj.itemNo = nextItemNo;
				copyObj.recordStatus = 2;				
				objArray.push(copyObj);
				
				var content = getSubpageContent(subpageName, copyObj);
				var table = $(tableListing);
				var newDiv = new Element("div");
				var idCombination = "" + nextItemNo;
				var idListing = $w(idList);
				
				for(var x=0, idLength=idListing.length; x < idLength; x++){
					idCombination += objFilteredArr[i][idListing[x]];
				}
				
				setItemPerilMotherDiv(copyObj.itemNo);
				addObjToPerilTable(copyObj);
			}
			
			delete copyObj;
		}
	}catch(e){
		showErrorMessage("copyPeril", e);		
	}
}