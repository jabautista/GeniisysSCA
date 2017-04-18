/*
 * Created By	: Bryan Joseph G. Abuluyan
 * Date			: November 24, 2010
 * Description	: returns the value of the attribute for the requested item peril with the given itemNo and perilCd
 * Parameters	: itemNo - itemNo of the peril
 * 				  perilCd - peril cd in search
 * 				  attribute - name of the attribute/column needed
 */
function getObjAttrValueForItemPeril(itemNo, perilCd, attribute){
	var attrValue = null;
	for (var i=0; i<objGIPIWItemPeril.length; i++){
		if ((objGIPIWItemPeril[i].itemNo == itemNo) 
				&& (objGIPIWItemPeril[i].perilCd == perilCd)
				&& (objGIPIWItemPeril[i].recordStatus != -1)){
			attrValue = objGIPIWItemPeril[i][attribute];
		}
	}
	return attrValue;
}