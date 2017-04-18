/**
 * Created by : andrew Date : 10.08.2010 Description : Sets the OR details as
 * global parameters Parameters : tranId = transaction id of the selected OR
 * from list
 */
function setGlobalORDetails(tranId) {
	for ( var i = 0; i < objORList.jsonArray.length; i++) {
		var objOR = objORList.jsonArray[i];
		if (objOR.gaccTranId == tranId) {
			objACGlobal.gaccTranId = objOR.gaccTranId;
			objACGlobal.branchCd = objOR.branchCd;
			objACGlobal.fundCd = objOR.fundCd;
			objACGlobal.workflowColVal = objOR.gaccTranId;
			objACGlobal.orTag = objOR.orTag;
			objACGlobal.orFlag = objOR.orFlag;
			objACGlobal.opTag = objOR.opTag;
			objACGlobal.withPdc = objOR.withPdc;
			objACGlobal.callingForm = "orListing";
		}
	}
}