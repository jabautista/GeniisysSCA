// shan 04.26.2013
function showGIACS230(frmMenu) {
	try {
		if (frmMenu == "Y") {
			objGIACS230.glTransURL = null;
			objGIACS230.fieldVals = [];
		}

		new Ajax.Request(contextPath+ "/GIACInquiryController?action=showGLAccountTransaction&moduleId=GIACS230"+ objGIACS230.glTransURL,{
			onComplete : function(response) {
				try {
					if (checkErrorOnResponse(response)) {
						$("mainContents").update(response.responseText);
						hideAccountingMainMenus();
						$("acExit").hide();

						if (objGIACS230.fieldVals != "" || frmMenu == "N") {
							setGIACS230FieldValues("N");
						} else {
							objGIACS230.from_date = null;
							objGIACS230.to_date = null;
							setGIACS230FieldValues("Y"); // Y for reset
						}

					}
				} catch (e) {
					showErrorMessage("showGIACS230 - onComplete: ", e);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGIACS230", e);
	}
}