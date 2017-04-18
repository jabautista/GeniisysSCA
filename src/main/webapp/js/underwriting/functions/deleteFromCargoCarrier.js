/*	Created by	: mark jm 03.07.2011
 * 	Description	: delete records on gipiWCargoCarrier
 * 	Parameters	: itemNo - determines if selective or all records to be deleted
 */
function deleteFromCargoCarrier(itemNo){
	try{
		var objFilteredArr = objGIPIWCargoCarrier.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == itemNo;	});
		
		for(var i=0, length=objFilteredArr.length; i<length; i++){
			objFilteredArr[i].recordStatus = -1;
		}
	}catch(e){
		showErrorMessage("deleteFromCargoCarrier", e);
	}	
}