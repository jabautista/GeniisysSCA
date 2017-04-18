function goToPageNo(listingTableId, url, action, pageNo) {
	try {
		new Ajax.Updater(listingTableId, contextPath+url, {
			method: "GET",
			evalScripts: true,
			asynchronous: true,
			parameters: {
				pageNo: pageNo,
				keyword: $F("keyword"),
				action: action,
				ajax: 1
			},
			onCreate: function () {
				if (!(Object.isUndefined($("searchSpan")))) {
					fadeElement("searchSpan", .3, null);
				}
				Effect.Fade($(listingTableId).down("div", 0), {
					duration: .001,
					afterFinish: function () {
						showLoading(listingTableId, "Getting list, please wait...", "150px");
					}
				});
			},
			onComplete: function (response) {
				//hideNotice();
				if (checkErrorOnResponse(response)) {
					Effect.Appear($(listingTableId).down("div", 0), {
						duration: .001,
						afterFinish: function () {
							var marRight = parseInt((screen.width - mainContainerWidth)/2);
							$("filterSpan").setStyle("right: " + marRight + "px; top: 105px;");
							$("searchSpan").setStyle("right: " + marRight + "px; top: 105px;");
						}
					});
				} else {
					$(listingTableId).update("<div style='align: center; margin-top: 100px;'>Failed to load records. Please contact your adminstrator.</div>");
				}
			}
		});
	} catch (e) {
		showErrorMessage("goToPageNo", e);
	}
}