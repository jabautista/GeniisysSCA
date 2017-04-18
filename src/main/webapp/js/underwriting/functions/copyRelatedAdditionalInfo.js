/*	Created by	: mark jm 10.18.2010
 * 	Description	: insert the objects copied from existing listing based on their item no
 * 				: creates hidden row for display
 * 	Parameter	: objArray - array of objects that holds all the records of a certain table
 * 				: itemNo - primary key for comparison
 * 				: nextItemNo - the next primary key
 * 				: tableListing - name/id of the table where the new row will be added
 * 				: rowName - name of the div/row that will be added
 * 				: idList - space-separated string containing the columns that will compose the row'id
 * 				: subpageName - name of the subpage used for creating row details
 */			
function copyRelatedAdditionalInfo(objArray, itemNo, nextItemNo, tableListing, rowName, idList, subpageName){
	try{
		var objFilteredArr = objArray.filter(function(obj){	return obj.itemNo == itemNo && nvl(obj.recordStatus, 0) != -1;	});
		
		if(objFilteredArr.length > 0){
			var copyObj = new Object();
			var length = objFilteredArr.length;
			
			for(var i=0; i < length; i++){
				//if(objArray[i].itemNo == itemNo && objArray[i].recordStatus != -1){
				copyObj = cloneObject(objFilteredArr[i]);
				copyObj.itemNo = nextItemNo;
				copyObj.recordStatus = 2;
				objArray.push(copyObj);

				var content = getSubpageContent(subpageName, copyObj);
				var table = $(tableListing);
				var newDiv = new Element("div");
				var idCombination = nextItemNo + "_";
				var idListing = $w(idList);

				for(var x=0, idLength=idListing.length; x < idLength; x++ ){
					idCombination += objFilteredArr[i][idListing[x]].trim() + "_"; //andrew - 11.18.2010 - added trim
					newDiv.setAttribute(idListing[x], objFilteredArr[i][idListing[x]].trim());
				}
				
				idCombination = idCombination.substr(0, idCombination.length - 1);
				
				newDiv.setAttribute("id", rowName + idCombination);
				newDiv.setAttribute("name", rowName);
				newDiv.setAttribute("item", copyObj.itemNo);
				newDiv.setStyle("display : none");
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				table.insert({bottom : newDiv});					
				
				loadRowMouseOverMouseOutObserver(newDiv);
				setClickObserverForNewRow(newDiv, objFilteredArr, tableListing, rowName);
				//}
			}

			delete copyObj;
		}		
	}catch(e){
		showErrorMessage("copyRelatedAdditionalInfo", e);
		//showMessageBox("copyRelatedAdditionalInfo : " + e.message);
	}
}