/*	Created by	: mark jm 03.07.2011
 * 	Description	: delete records on gipiWItmPeril
 * 	Parameters	: itemNo - determines if selective or all records to be deleted
 */
function deleteFromItemPeril(itemNo){
	try{
		if(itemNo == 0){
			for(var i=0, length=objGIPIWItemPeril.length; i<length; i++){
				objGIPIWItemPeril[i].recordStatus = -1;
				for(var j = 0; j < objDeductibles.length; j++){ //added by robert SR 21693 03.02.16
					if(objDeductibles[j].parId == objGIPIWItemPeril[i].parId && objDeductibles[j].itemNo == objGIPIWItemPeril[i].itemNo && objDeductibles[j].perilCd == objGIPIWItemPeril[i].perilCd){
						objDeductibles[j].recordStatus = -1;
					}
				}
			}
			tbgItemPeril = null; //added by robert SR 21693 03.02.2016
		}else{
			var objFilteredArr = objGIPIWItemPeril.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == itemNo;	});
			for(var i=0, length=objFilteredArr.length; i<length; i++){
				objFilteredArr[i].recordStatus = -1;
				for(var j = 0; j < objDeductibles.length; j++){ //added by gab SR 21693 04.14.2016
					if(objDeductibles[j].parId == objGIPIWItemPeril[i].parId && objDeductibles[j].itemNo == itemNo && objDeductibles[j].deductibleType == 'T'){
						objDeductibles[j].recordStatus = -1;
					}
					if(objDeductibles[j].parId == objGIPIWItemPeril[i].parId && objDeductibles[j].itemNo == 0 && objDeductibles[j].deductibleType == 'T'){
						objDeductibles[j].recordStatus = -1;
					}
					if(objDeductibles[j].parId == objGIPIWItemPeril[i].parId && objDeductibles[j].itemNo == itemNo && objDeductibles[j].perilCd == objGIPIWItemPeril[i].perilCd){
						objDeductibles[j].recordStatus = -1;
					}
				}
			}
			tbgItemPeril = null; //added by gab SR 21693 04.14.2016
		}
	}catch(e){
		showErrorMessage("deletefromItemPeril", e);
	}	
}