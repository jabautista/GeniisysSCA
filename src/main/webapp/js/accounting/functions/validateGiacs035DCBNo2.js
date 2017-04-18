/**
 * The second part of the WHEN-NEW-VALIDATE-ITEM trigger of DCB_NO in GIACS035
 * (Close DCB)
 * 
 * @author eman
 */
function validateGiacs035DCBNo2() {	
	new Ajax.Request(contextPath+"/GIACAccTransController?action=validateGiacs035DCBNo2", {
		evalScripts: true,
		asynchronous: false,
		method: "GET",
		parameters: {
			gfunFundCd: $F("gaccGfunFundCd"),
			gibrBranchCd: $F("gaccGibrBranchCd"),
			dcbDate: $F("gaccDspDCBDate"),
			dcbYear: $F("gaccDspDCBYear"),
			dcbNo: $F("gaccDspDCBNo"),
			dspDCBFlag: $F("gaccDspDCBFlag"),
			meanDCBFlag: $F("gaccMeanDCBFlag"),
			varAllORsRCancelled: $F("varAllORsRCancelled")
		},
		onComplete: function(response) {
			if (checkErrorOnResponse(response)) {
				var result = response.responseText.toQueryParams();
                       
						if (result.oneUnprintedOR == "Y") {
							showWaitingMessageBox(
									"There is at least one unprinted OR record for this DCB No.",
									imgMessage.INFO,
									function() {
										$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
										$("gaccDspDCBNo").focus();
									});
						} else if (result.oneOpenOR == "Y") {
							showWaitingMessageBox(
									"There is at least one OPEN OR transaction.  Please close the accounting entries before closing this DCB.",
									imgMessage.WARNING,
									function() {
										$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
										$("gaccDspDCBNo").focus();
									});
						} else if (result.noCollectionAmt == "Y") {
							showWaitingMessageBox(
									"No collection amount was specified for this DCB No.",
									imgMessage.INFO,
									function() {
										$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
										$("gaccDspDCBNo").focus();
									});
						} else if (result.oneManualOR == "Y") {
							showWaitingMessageBox(
									"At least one Manual O.R. has no collection amount specified for this DCB No.",
									imgMessage.INFO,
									function() {
										$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
										$("gaccDspDCBNo").focus();
									});
						} else {
							$("gaccDspDCBFlag").value = result.dspDCBFlag;
							$("gaccMeanDCBFlag").value = result.meanDCBFlag;
							
							if ($F("varYesNo") == "Y") {
								$("varUpdateDCB").value = "Y";
							}
							
							$("newDCBForClosing").value = "Y";
							
							gicdSumListTableGrid.url = contextPath
									+ "/GIACAccTransController?action=refreshGicdSumListing&gibrBranchCd="
									+ encodeURIComponent($F("gaccGibrBranchCd"))
									+ "&gfunFundCd="
									+ encodeURIComponent($F("gaccGfunFundCd"))
									+ "&dcbNo="
									+ encodeURIComponent($F("gaccDspDCBNo"))
									+ "&dcbDate="
									+ encodeURIComponent($F("gaccDspDCBDate"));
							
							gicdSumListTableGrid.refresh();
							
							computeGicdSumTotal();
							
							if (checkBankInOR()) {
								// gdbdListTableGrid.url =
								// contextPath+"/GIACAccTransController?action=refreshGdbdListing&gibrBranchCd="+encodeURIComponent($F("gaccGibrBranchCd"))
								gdbdListTableGrid.url = contextPath
										+ "/GIACBankDepSlipsController?action=refreshGdbdListing&gibrBranchCd="
										+ encodeURIComponent($F("gaccGibrBranchCd"))
										+ "&gfunFundCd="
										+ encodeURIComponent($F("gaccGfunFundCd"))
										+ "&dcbYear="
										+ encodeURIComponent($F("gaccDspDCBYear"))
										+ "&dcbNo="
										+ encodeURIComponent($F("gaccDspDCBNo"))
										+ "&dcbDate="
										+ encodeURIComponent($F("gaccDspDCBDate"));
								gdbdListTableGrid.refresh();
								computeGdpdSumTotal(); // robert 9.24.2012
								changeTag = 1;
								changeTagFunc = saveDCB;
							}
						}
					} else {
						$("gaccDspDCBNo").value = $F("controlPrevDCBNo");
						showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}