/*
* Created by	: andrew robes
* Date			: 07.08.2010
* Description	: Returns the total item tsi amount of the current perils of the endt par.
* Parameters	: itemNo - item number of perils to be included in the computation
* 				  objPolPerils - array of objects containing the endt par perils
*/
function computeEndtItemTsiAmount(itemNo, objEndtPerils){
	try {
		var tempNum = 0;
		
		if (objEndtPerils != null) {
			for(var i=0; i<objEndtPerils.length; i++){
				if(objEndtPerils[i].itemNo == itemNo && objEndtPerils[i].perilType != "A" && objEndtPerils[i].recordStatus != -1){
					tempNum += parseFloat(objEndtPerils[i].tsiAmt);
				}
			}
		} else {		
			$$("div[name='rowEndtPeril']").each(function(row){
				if(row.down("input", 0).value == itemNo && row.down("input", 15).value != "A"){					
					tempNum += parseFloat(row.down("input", 4).value.replace(/,/g, ""));
				}
			});
		}
		return tempNum;
	} catch (e){
		showErrorMessage("computeEndtItemTsiAmount", e);
	}		
}