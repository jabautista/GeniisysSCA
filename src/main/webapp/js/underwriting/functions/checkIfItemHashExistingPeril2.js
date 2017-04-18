/*	Created by	: mark jm 09.15.2010
 * 	Modified by	: mark jm 03.01.2011
 * 	Description	: Check if item has existing peril records
 *  Parameter	: itemNo - itemNo to check if it exist in peril listing 
 */
function checkIfItemHashExistingPeril2(itemNo){
	
	var blnExist = false;
	/*
	$$("div#parItemPerilTable div[name='row2']").each(function(a){		
		if (a.down("input",0).value == itemNo){
			blnExist = true;
		}
	});
	*/
	
	if(objGIPIWItemPeril != null && (objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == itemNo;	})).length > 0){
		blnExist = true;
	}
	
	return blnExist;	
}