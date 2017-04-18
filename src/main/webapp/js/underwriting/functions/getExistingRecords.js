/*	Created by	: mark jm 11.18.2010
 * 	Description	: used in filtering array
 * 	Parameters	: obj - obj
 */
function getExistingRecords(obj){	
	return((nvl(obj.recordStatus, 0) == 0 || nvl(obj.recordStatus, 0) == 1) 
		&& nvl(obj.itemNo, 0) == ($("itemNo") == null ? "0" : $F("itemNo")));
}