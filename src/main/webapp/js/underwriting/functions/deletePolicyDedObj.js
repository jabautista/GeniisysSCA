/*	Created by	: BJGA 12.14.2010
 * 	Description	: delete policy level deductibles based on %TSI
 */
function deletePolicyDedObj(){
	// policy deductibles
	for(var i=0; i<objDeductibles.length; i++){
		if (objDeductibles[i].deductibleType == "T"
				&& nvl(objDeductibles[i].itemNo, "0") == "0"
				&& objDeductibles[i].recordStatus != -1){
			addDeletedJSONObject(objDeductibles, objDeductibles[i]);
		}
	}
}