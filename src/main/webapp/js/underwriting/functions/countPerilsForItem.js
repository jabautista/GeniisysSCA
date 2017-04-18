/*
 * Created by	: Bryan
 * Date			: October 18, 2010
 * Description	: Returns the count of perils for a certain itemNo
 * Parameters	: itemNo - the itemNo
 */
function countPerilsForItem(itemNo){
	var perilCount = 0;
	/*$$("div#parItemPerilTable div[name='row2']").each(function(p){
		if (p.down("input", 0).value == itemNo){
			perilCount++;
		}
	});*/
	for (var i = 0; i < objGIPIWItemPeril.length; i++){
		if ((objGIPIWItemPeril[i].itemNo == itemNo)
				&& (objGIPIWItemPeril[i].recordStatus != -1)){
			perilCount++;
		}
	}
	return perilCount;
}