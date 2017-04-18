/*
* Created by	: andrew robes
* Date			: 07.08.2010
* Description	: Returns the total item annual tsi amount based on the perils of posted policies
* Parameters	: itemNo - item number of perils to be included in the computation
* 				  objPolPerils - array of objects containing the posted policies' perils
*/
function computeEndtItemAnnTsiAmount(itemNo, objPolPerils){		
	try {
		var tempNum = 0;
		//edited by d.alcantara, 11-15-2011, to include only Basic Perils in the computation
		if(objPolPerils != null){
			for(var i=0; i<objPolPerils.length; i++){
				if(objPolPerils[i].itemNo == itemNo && objPolPerils[i].perilType == "B"){				
					tempNum += parseFloat(objPolPerils[i].tsiAmount);										
				}
			}
		} else {
			$$("div[name='rowPeril']").each(function(row){
				if(row.down("input", 0).value == itemNo){					
					tempNum += parseFloat(row.down("input", 4).value.replace(/,/g, ""));										
				}
			});
		}
		
		return tempNum;
	} catch (e){
		showErrorMessage("computeEndtItemAnnTsiAmount", e);
	}
}