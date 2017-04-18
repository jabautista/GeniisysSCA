/*
 * Created By	: andrew robes
 * Date			: October 21, 2010
 * Description	: Retrieves the number of items without deductibles
 * Parameters	: objArray - array of deductible objects
 */
function getItemNosWithoutDeductibles(objArray) {
	try {
		var tempArray = new Array();
		var itemNos = new Array();
		
		$$("div#parItemTableContainer div[name='row']").each(function(div){
			itemNos.push(parseInt(div.down("label", 0).innerHTML));
		});
		
		var exist = null;			
		itemNos.any(function(no) {
			exist = false;
			for(var i=0; i<objArray.length; i++) {
				if (objArray[i].itemNo == no && nvl(objArray[i].recordStatus, 0) != -1) { //marco - added recordStatus condition
					exist = true;
				}
			}
			
			if (!exist){
				tempArray.push(no);
			}				
		});	
		
		return tempArray;
	} catch(e){
		showErrorMessage("getItemNosWithoutDeductibles", e);
	}
}