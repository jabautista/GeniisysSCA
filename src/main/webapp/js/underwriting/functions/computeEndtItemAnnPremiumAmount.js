/*
* Created by	: andrew robes
* Date			: 07.08.2010
* Description	: Returns the total item annual premium amount based on the perils of posted policies
* Parameters	: itemNo - item number of perils to be included in the computation
* 				  objPolPerils - array of objects containing the posted policies' perils
*/
function computeEndtItemAnnPremiumAmount(itemNo, objPolPerils){
	try {
		var tempNum = 0;
		if(objPolPerils != null){
			for(var i=0; i<objPolPerils.length; i++){
				if(objPolPerils[i].itemNo == itemNo){	
					tempNum += parseFloat(objPolPerils[i].premiumAmount);
				}
			}
		} else {			
			$$("div[name='rowPeril']").each(function(row){
				if(row.down("input", 0).value == itemNo){
					tempNum += parseFloat(row.down("input", 6).value.replace(/,/g, ""));
				}
			});
		}
		
		return tempNum;
	} catch (e){
		showErrorMessage("computeEndtItemAnnPremiumAmount", e);
	}		
}