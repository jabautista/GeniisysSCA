/**
 * Executed when deductible row is clicked
 * @author andrew
 * @date 05.16.2011
 * @param row
 */
function clickDeductibleRow(row, dedLevel){
	if (row.hasClassName("selectedRow")) {			
		setDeductibleForm(row, dedLevel);
		
		for(var i=0; i<objDeductibles.length; i++) {
			if (dedLevel == 1){
				if (nvl(objDeductibles[i].itemNo, 0) == 0 && nvl(objDeductibles[i].perilCd, 0) == 0 && objDeductibles[i].dedDeductibleCd == $F("txtDeductibleCd"+dedLevel)) {
					objCurrDeductible = objDeductibles[i];
					break;
				}
			} else if(dedLevel == 2){
				if (objDeductibles[i].itemNo == parseInt($F("itemNo").trim()) && nvl(objDeductibles[i].perilCd, 0) == 0 && objDeductibles[i].dedDeductibleCd == $F("txtDeductibleCd"+dedLevel)) {
					objCurrDeductible = objDeductibles[i];
					break;
				}	
			} else if (dedLevel == 3){
				if (objDeductibles[i].itemNo == parseInt($F("itemNo").trim()) && objDeductibles[i].perilCd == $F("perilCd") && objDeductibles[i].dedDeductibleCd == $F("txtDeductibleCd"+dedLevel)) {
					objCurrDeductible = objDeductibles[i];
					break;
				}	
			}
		}		
	} else {
		setDeductibleForm(null, dedLevel);
	}
}