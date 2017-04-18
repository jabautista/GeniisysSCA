/*	Created by 	: mark jm 09.06.2010
 * 	Description	: Show only options not existing in table row
 * 				: Used in item information page when selecting item and showing related mortgagee
 * 				: Doesn't reload the LOV
 * 	Parameters	: lovName - name of select list
 * 				: rowName - name of table row
 * 				: rowNo - row no value
 * 				: currentCd - code of selected option
 * 				: attr - name of attribute to compare against pkValue  
 */
function filterLOV2(lovName, rowName, currentCd, attr, pkValue, cdAttr){
	$$("div[name='"+rowName+"']").each(function(row){
		if (row.getAttribute(attr) == pkValue){
			var cd = row.getAttribute(cdAttr);
			for(var i = 1; i < $(lovName).options.length; i++){ 
				if (cd == $(lovName).options[i].value){
					$(lovName).options[i].hide();
					$(lovName).options[i].disabled = true;					
				}
			}
		}
	});
	
	if (currentCd != ""){
		for(var i = 1; i < $(lovName).options.length; i++){ 
			if (currentCd == $(lovName).options[i].value){
				$(lovName).options[i].show();
				$(lovName).options[i].disabled = false;
			}
		}
	}	
}