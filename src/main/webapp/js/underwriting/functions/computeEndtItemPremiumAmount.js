/*
* Created by	: andrew robes
* Date			: 07.08.2010
* Description	: Returns the total item premium amount of the current perils of the endt par.
* Parameters	: itemNo - item number of perils to be included in the computation
* 				  objPolPerils - array of objects containing the endt par perils
*/
function computeEndtItemPremiumAmount(itemNo, objEndtPerils){
	try {
		var tempNum = 0;
		if(objEndtPerils != null) {
			for(var i=0; i<objEndtPerils.length; i++){
				if(objEndtPerils[i].itemNo == itemNo && objEndtPerils[i].recordStatus != -1){
					tempNum += parseFloat(objEndtPerils[i].premAmt);
				}
			}
		} else {
			$$("div[name='rowEndtPeril']").each(function(row){
				if(row.down("input", 0).value == itemNo){
					tempNum += parseFloat(row.down("input", 6).value.replace(/,/g, ""));
				}
			});
		}
		
		return tempNum;		
	} catch (e){
		showErrorMessage("computeEndtItemPremiumAmount", e);
	}		
}