function initializeAllComputationFields() {
	$$("input[type='text'].money, .list")
			.each(
					function(m) {
						m
								.observe(
										"blur",
										function() {
											if ($F("recompute") == 'Y') {
												if (parseFloat(m.value.replace(
														/,/g, "")) >= 0
														&& parseFloat((m.value)
																.replace(/,/g,
																		"")) <= unformatCurrency("grossAmt")) {
													computeDeductibles();
													$("recompute").value = 'N';
												}
											}
										});
						m.observe("change", function() {
							if ($F("existingDCBNo") == 0) {
								showConfirmBox("Create DCB_NO",
										"There is no open DCB No. for "
												+ $F("orDate")
												+ ". Create one?", "Yes", "No",
										showDCBReminderDetails,
										cancelDCBCreation);
							}
						});
					});
}