/**
 * The function CHK_MODIFIED_COMM in Direct Trans Comm Payts (GIACS020), used in
 * PREM_SEQ_NO validation
 * 
 * @author emman 09.21.2010
 * @version 1.0
 */
function chkModifiedComm() {
	var result = true;
	new Ajax.Request(contextPath
			+ "/GIACCommPaytsController?action=validatePremSeqNo", {
		evalScripts : true,
		asynchronous : false,
		method : "GET",
		parameters : {
			premSeqNo : $F("txtPremSeqNo"),
			issCd : $F("txtIssCd")
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				if (response.responseText != "SUCCESS") {
					showMessageBox(response.responseText, imgMessage.ERROR);
					$("varClrRec").value = "Y";
					result = false;
					return false;
				}
			} else {
				showMessageBox(response.responseText, imgMessage.ERROR);
				result = false;
				return false;
			}
		}
	});

	return result;
}
