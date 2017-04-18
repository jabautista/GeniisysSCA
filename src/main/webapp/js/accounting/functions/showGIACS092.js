function showGIACS092() { // pol cruz 04.19.2013
	try {
		new Ajax.Request(contextPath + "/GIACInquiryController", {
			parameters : {
				action : "showGIACS092"
			},
			onComplete : function(response) {
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
			}
		});
	} catch (e) {
		showErrorMessage("Error in PDC Payments Inquiry : ", e);
	}
}