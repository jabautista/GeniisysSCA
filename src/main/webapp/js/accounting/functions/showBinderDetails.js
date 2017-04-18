function showBinderDetails() {
	try {
		new Ajax.Updater(
				"binderListDiv",
				contextPath
						+ "/GIACOutFaculPremPaytsController?action=getBinderList",
				{
					method : "GET",
					parameters : {
						tranType : $("tranType").options[$("tranType").selectedIndex].value,
						riCd : $("reinsurer").options[$("reinsurer").selectedIndex].value,
						lineCd : null,
						binderYY : null
					},
					evalScripts : true,
					onCreate : showNotice("Getting Binder Listing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {

						}
					}
				});
	} catch (e) {
		showErrorMessage("showBinderDetails", e);
		// showMessageBox("showBinderDetails : " + e.message);
	}
}