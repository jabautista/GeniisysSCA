function showGIPIS085IntermediaryLOV(parId, assdNo, lineCd, parType,
		defaultIntm, notIn, polFlag) {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getGIPIS085IntermediaryLOV",
						parId : parId,
						assdNo : assdNo,
						lineCd : lineCd,
						parType : parType,
						defaultIntm : defaultIntm,
						notIn : notIn,
						polFlag : polFlag,
						page : 1
					},
					title : "Intermediary",
					width : 700,
					height : 380,
					columnModel : [ {
						id : "intmName",
						title : "Intermediary Name",
						width : '380px'
					}, {
						id : "intmNo",
						title : "Intermediary No.",
						align : 'right',
						width : '120px'
					}, {
						id : "refIntmCd",
						title : "Ref. Intermediary Cd",
						width : '150px'
					} ],
					draggable : true,
					onSelect : function(row) {
						$("txtIntmNo").value = row.intmNo;
						$("txtIntmName").value = row.intmName;
						$("txtParentIntmNo").value = row.parentIntmNo;
						$("txtParentIntmName").value = row.parentIntmName;
						$("txtIntmActiveTag").value = row.activeTag;
						$("txtDspIntmName").value = unescapeHTML2(row.intmNo
								+ " - " + row.intmName);
						// $("txtDspParentIntmName").value =
						// unescapeHTML2(row.parentIntmNo != null ?
						// row.parentIntmNo + " - " + row.parentIntmName : "");
						$("txtDspParentIntmName").value = unescapeHTML2(row.parentIntmNo != null ? row.parentIntmNo
								+ " - " + row.parentIntmName
								: row.intmNo + " - " + row.intmName);
						$("isIntmOkForValidation").value = "Y";

						$("txtParentIntmLicTag").value = row.parentIntmLicTag;
						$("txtParentIntmSpecialRate").value = row.parentIntmSpecialRate;

						if (parType == "E" && defaultIntm == true) {
							$("txtSharePercentage").value = formatToNthDecimal(
									row.sharePercentage, 7);
						}

						$("txtLicTag").value = row.licTag; /*
															 * added by
															 * christian
															 * 08.25.2012
															 */
						$("txtSpecialRate").value = row.specialRate; /*
																		 * added
																		 * by
																		 * christian
																		 * 08.25.2012
																		 */
						$("txtDspIntmName").focus();
					}
				});
	} catch (e) {
		showErrorMessage("showGIPIS085IntermediaryLOV", e);
	}
}