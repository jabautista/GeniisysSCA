function initializeDcbEventObjects() {
	var isComplete = true;
	$$(".dcbEvent").each(
			function(m) {
				m.observe("click",
						function() {
							if (checkClosedMonthYearTrans(Date.parse(
									$F("orDate")).getMonth(), Date.parse(
									$F("orDate")).getFullYear())) {
								if ($F("existingDCBNo") == 0) {
									showConfirmBox("Create DCB_NO",
											"There is no open DCB No. for "
													+ $F("orDate")
													+ ". Create one?", "Yes",
											"No", validatePopulateDCB,
											cancelDCBCreation);
								}
							}
						});
			});
	return isComplete;
}