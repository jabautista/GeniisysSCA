/*
 * Created By	: Bryan Joseph G. Abuluyan
 * Date			: November 25, 2010
 * Description	: inserts a new peril object to objGIPIWItemPeril, checking first if there is a previously deleted object with same PK
 */
function addNewPerilObject(newObj){
	newObj.recordStatus = 0;

	/*for (var i=0; i<objGIPIWItemPeril.length; i++){
		if ((objGIPIWItemPeril[i].itemNo == newObj.itemNo) 
				&& (objGIPIWItemPeril[i].perilCd == newObj.perilCd) 
				&& (objGIPIWItemPeril[i].recordStatus == -1)){
			objGIPIWItemPeril.splice(i, 1);
			newObj.recordStatus = 1;
		} else {
			newObj.recordStatus = 0;
		}
	}*/
	objGIPIWItemPeril.push(newObj);
	
}