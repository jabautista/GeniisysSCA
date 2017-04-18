/**
 * Gets the intermediary no and intermediary name for specified tran type, issue
 * source and bill no (GIACS020)
 * 
 * @author emman 09.21.2010
 * @version 1.0
 */
function getCommPaytsIntermediary() {
	new Ajax.Request(contextPath
			+ "/GIACCommPaytsController?action=getIntermediary", {
		evalScripts : true,
		asynchronous : false,
		method : "GET",
		parameters : {
			tranType : $F("txtTranType"),
			issCd : $F("txtIssCd"),
			premSeqNo : $F("txtPremSeqNo")
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				// var result = response.responseText.toQueryParams();
				var result = JSON.parse(response.responseText);

				$("txtIntmNo").value = result.intmNo;
				$("txtDspIntmName").value = result.intmName;
			} else {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}