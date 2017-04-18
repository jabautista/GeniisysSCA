function goToPageNo2(listingTableId, url, action, pageNo) {
	try {
		new Ajax.Updater(listingTableId, contextPath+url, {
			method: "GET",
			evalScripts: true,
			asynchronous: true,
			parameters: {
				pageNo: pageNo,
				action: action,
				ajax: 1
			},
			onCreate: function () {
				if (!(Object.isUndefined($("searchSpan")))) {
					fadeElement("searchSpan", .001, null);
				}
				Effect.Fade($(listingTableId).down("div", 0), {
					duration: .3,
					afterFinish: function () {
						showLoading(listingTableId, "Getting list, please wait...", "150px");
					}
				});
			},
			onComplete: function () {
				Effect.Appear($(listingTableId).down("div", 0), {duration: .2});
			}
		});
	} catch (e) {
		showErrorMessage("goToPageNo2", e);
	}
}