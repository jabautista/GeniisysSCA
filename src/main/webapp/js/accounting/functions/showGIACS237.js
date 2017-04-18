function showGIACS237() {
	try {
		new Ajax.Request(contextPath
				+ "/GIACInquiryController?action=showDVStatus"
				+ objGlobalGIACS237.dvStatusURL, {
			onComplete : function(response) {
				try {
					if (checkErrorOnResponse(response)) {
						$("mainContents").update(response.responseText);
						hideAccountingMainMenus();
						if (objGlobalGIACS237.fieldVals != "") {
							setGIACS237FieldValues("N");
						} else {
							setGIACS237FieldValues("Y");
						}
					}
				} catch (e) {
					showErrorMessage("showGIACS237 - onComplete: ", e);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGIACS237", e);
	}
}