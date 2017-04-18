/*	Created by	: mark jm 03.07.2011
 * 	Description	: delete records on gipiWVesAccumulation
 * 	Parameters	: itemNo - determines if selective or all records to be deleted
 */
function deleteFromVesAccumulation(itemNo){
	try{
		var objFilteredArr = objGIPIWVesAccumulation.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == itemNo;	});
		
		for(var i=0, length=objFilteredArr.length; i<length; i++){
			objFilteredArr[i].recordStatus = -1;
		}
	}catch(e){
		showErrorMessage("deleteFromVesAccumulation", e);
	}	
}