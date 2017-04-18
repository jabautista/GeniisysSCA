/*
 * Created By	: Bryan Joseph G. Abuluyan
 * Date			: November 24, 2010
 * Description	: returns the value of the attribute for the requested item with the given itemNo
 * Parameters	: itemNo - itemNo of the peril
 * 				  attribute - name of the attribute/column needed
 */
function getObjAttrValueForItem(itemNo, attribute){
	var attrValue = null;
	for (var i=0; i<objGIPIWItem.length; i++){
		if (objGIPIWItem[i].itemNo == itemNo
				&& objGIPIWItem[i].recordStatus != -1){
			attrValue = objGIPIWItem[i][attribute];
		}
	}
	return attrValue;
}