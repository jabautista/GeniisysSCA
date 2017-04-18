/**
 * the first part of the WHEN-NEW-VALIDATE-ITEM trigger of DCB_NO in GIACS035
 * (Close DCB)
 * 
 * @author eman
 * @return
 */
function validateGiacs035DCBNo1() {
	if (isNaN($F("gaccDspDCBNo")) || $F("gaccDspDCBNo").blank()) {
		showWaitingMessageBox("Invalid input for DCB No.", imgMessge.ERROR,
				function() {
					$F("gaccDspDCBNo").focus();
				});
	} else {
		new Ajax.Request(
				contextPath
						+ "/GIACAccTransController?action=validateGiacs035DCBNo1",
				{
					evalScripts : true,
					asynchronous : false,
					method : "GET",
					parameters : {
						gfunFundCd : $F("gaccGfunFundCd"),
						gibrBranchCd : $F("gaccGibrBranchCd"),
						dcbDate : $F("gaccDspDCBDate"),
						dcbYear : $F("gaccDspDCBYear"),
						dcbNo : $F("gaccDspDCBNo"),
						varAllORsRCancelled : $F("varAllORsRCancelled")
					},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();

							$("varAllORsRCancelled").value = result.varAllORsRCancelled;

							if (result.invalidDCBNo == "Y") {
								showWaitingMessageBox(
										"Invalid DCB No.",
										imgMessage.INFO,
										function() {
											$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
											$("gaccDspDCBNo").focus();
										});
							} else if (result.varAllORsRCancelled == "Y") {
								showConfirmBox(
										"",
										"All ORs of DCB No. "
												+ formatNumberDigits(
														parseInt(nvl(
																$F("gaccDspDCBNo"),
																"0")), 6)
												+ " are cancelled.  Would you like to continue closing this DCB?",
										"Yes", "No", function() {
											$("varYesNo").value = "Y";
											validateGiacs035DCBNo2();
										}, function() {
											$("gaccDspDCBDate").value = "";
											$("gaccDspDCBNo").value = "";
											$("gaccDspDCBYear").value = "";
											$("varYesNo").value = "N";
											// validateGiacs035DCBNo2();
											// //remove by steven 02.01.2013;
											// base on SR 0011942
										});
							} else {
								validateGiacs035DCBNo2();
							}
						} else {
							$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
							showMessageBox(response.responseText,
									imgMessage.ERROR);
						}
					}
				});
	}
}