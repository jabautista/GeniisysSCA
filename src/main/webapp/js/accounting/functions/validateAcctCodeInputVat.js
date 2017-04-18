/**
 * Validate the Account Code in module GIACS039
 * 
 * @author Jerome Orio 09.23.2010
 * @version 1.0
 * @param glAcctCategory,
 *            glControlAcct, glSubAcct1, glSubAcct2, glSubAcct3, glSubAcct4,
 *            glSubAcct5, glSubAcct6, glSubAcct7
 * @return glAcctName, glAcctId, gsltSlTypeCd
 */
function validateAcctCodeInputVat() {
	var ok = false;
	if (!$F("txtGlAcctCategoryInputVat").blank()
			&& !$F("txtGlControlAcctInputVat").blank()
			&& !$F("txtGlSubAcct1InputVat").blank()
			&& !$F("txtGlSubAcct1InputVat").blank()
			&& !$F("txtGlSubAcct2InputVat").blank()
			&& !$F("txtGlSubAcct3InputVat").blank()
			&& !$F("txtGlSubAcct4InputVat").blank()
			&& !$F("txtGlSubAcct5InputVat").blank()
			&& !$F("txtGlSubAcct6InputVat").blank()
			&& !$F("txtGlSubAcct7InputVat").blank()) {
		new Ajax.Request(
				contextPath + "/GIACInputVatController?action=validateAcctCode",
				{
					method : "GET",
					parameters : {
						glAcctCategory : $F("txtGlAcctCategoryInputVat"),
						glControlAcct : $F("txtGlControlAcctInputVat"),
						glSubAcct1 : $F("txtGlSubAcct1InputVat"),
						glSubAcct2 : $F("txtGlSubAcct2InputVat"),
						glSubAcct3 : $F("txtGlSubAcct3InputVat"),
						glSubAcct4 : $F("txtGlSubAcct4InputVat"),
						glSubAcct5 : $F("txtGlSubAcct5InputVat"),
						glSubAcct6 : $F("txtGlSubAcct6InputVat"),
						glSubAcct7 : $F("txtGlSubAcct7InputVat")
					},
					asynchronous : false,
					evalScripts : true,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							objValidateAcctCode = JSON
									.parse(response.responseText);
							if (objValidateAcctCode.glAcctId == null
									|| objValidateAcctCode.glAcctId == "") {
								customShowMessageBox(
										"There is no account name existing with this account code.",
										imgMessage.ERROR,
										"txtGlAcctCategoryInputVat");
								$("txtDspAccountName").clear();
								$("hidGlAcctIdInputVat").clear();
								$("hidGsltSlTypeCdInputVat").clear();
								$("txtSlNameInputVat").removeClassName(
										"required");
								$("txtSlNameInputVatDiv").removeClassName(
										"required");
								$("txtSlNameInputVatDiv")
										.setStyle(
												"background-color:"
														+ $("txtSlNameInputVat")
																.getStyle(
																		"background-color"));
								$("hidSlCdInputVat").clear();
								$("txtSlNameInputVat").clear();
								ok = false;
							} else {
								$("txtDspAccountName").value = objValidateAcctCode.glAcctName;
								$("hidGlAcctIdInputVat").value = objValidateAcctCode.glAcctId;
								$("hidGsltSlTypeCdInputVat").value = objValidateAcctCode.gsltSlTypeCd;
								if ($F("hidGsltSlTypeCdInputVat") != "") {
									$("txtSlNameInputVat").addClassName(
											"required");
									$("txtSlNameInputVatDiv").addClassName(
											"required");
									$("txtSlNameInputVat").setStyle({backgroundColor: '#FFFACD'});
									$("txtSlNameInputVatDiv")
											.setStyle(
													"background-color:"
															+ $(
																	"txtSlNameInputVat")
																	.getStyle(
																			"background-color"));
									enableSearch("slCdInputVatDate");
								} else {
									$("txtSlNameInputVat").removeClassName(
											"required");
									$("txtSlNameInputVatDiv").removeClassName(
											"required");
									$("txtSlNameInputVat").setStyle({backgroundColor: 'white'});
									$("txtSlNameInputVatDiv")
											.setStyle(
													"background-color:"
															+ $(
																	"txtSlNameInputVat")
																	.getStyle(
																			"background-color"));
									disableSearch("slCdInputVatDate");
								}
								ok = true;
							}
						}
					}
				});
	} else {
		ok = false;
	}
	return ok;
}