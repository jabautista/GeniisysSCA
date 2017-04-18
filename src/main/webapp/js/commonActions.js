/*function goToAssuredPageNo(pageNo) {
	new Ajax.Updater("assuredListingTable", contextPath+"/GIISAssuredController?action=getAssuredListing", {
		method: "GET",
		evalScripts: true,
		asynchronous: true,
		parameters: {
			pageNo: pageNo,
			keyword: $F("keyword"),
			isFromAssuredListingMenu: "true"
		},
		onCreate: function () {
			Effect.Fade($("assuredListingTable").down("div", 0), {
				duration: .5,
				afterFinish: function () {
					showLoading("assuredListingTable", "Getting list, please wait...", "150px");
				}
			});
		},
		onComplete: function () {
			Effect.Appear($("assuredListingTable").down("div", 0), {duration: .5});
		}
	});
}*/