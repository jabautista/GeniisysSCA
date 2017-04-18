/*	Created by	: mark jm 12.23.2010
 * 	Description	: used in filtering array
 * 	Parameters	: obj - obj
 */
function getRecordsWithSameItemNo(obj){
	return obj.itemNo == $F("itemNo");
}