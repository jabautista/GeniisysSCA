/*
 * Created by	: Bryan
 * Date			: October 22, 2010
 * Description	: Returns the count of items
 */
function countItems(){
	var itemCount = 0;
	/*$$("div[name='rowItem']").each(function(i){
		itemCount++;
	});*/
	for (var i = 0; i < objGIPIWItem.length; i++){
		if (objGIPIWItem[i].recordStatus != -1){
			itemCount++;
		}
	}
	return itemCount;
}