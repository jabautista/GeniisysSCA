/**
 * Populate Payee LOV in module GIACS010
 * 
 * @author Jerome Orio 10.07.2010
 * @version 1.0
 * @param objArray -
 *            object array for payee listing
 * @return
 */
function updatePayeeLossRecLOV() {
	$("selPayorClassCdLossRec").enable();
	var objArray = objAC.hidObjGIACS010.payeeListJSON;
	removeAllOptions($("selPayorClassCdLossRec"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	opt.setAttribute("payorName", "");
	opt.setAttribute("payorCd", "");
	$("selPayorClassCdLossRec").options.add(opt);
	for ( var a = 0; a < objArray.length; a++) {
		if (objArray[a].claimId == objAC.hidObjGIACS010.hidClaimId
				&& objArray[a].recoveryId == objAC.hidObjGIACS010.hidRecoveryId) {
			var opt = document.createElement("option");
			opt.value = objArray[a].payorClassCd;
			opt.text = objArray[a].classDesc;
			opt.setAttribute("payorName", objArray[a].payorName);
			opt.setAttribute("payorCd", objArray[a].payorCd);
			$("selPayorClassCdLossRec").options.add(opt);
		}
	}
}