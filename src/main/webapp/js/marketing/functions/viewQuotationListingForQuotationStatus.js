function viewQuotationListingForQuotationStatus(pageNo) {
	new Ajax.Updater("searchResult",contextPath	+ "/GIPIQuotationController?action=viewQuotationListingForQuotationStatus&pageNo=" + pageNo, {
		method : "POST",
		postBody : Form.serialize("searchForm"),
		evalScripts : true,
		asynchronous : true,
		onCreate : function() {
			fadeElement("moreFilterDiv", .3, null);
			Effect.Fade($("searchResult").down("div", 0), {
				duration : .001,
				afterFinish : function() {
					showLoading("searchResult",	"Getting list, please wait...", "150px");
				}
			});
		},
		onComplete : function() {
			Effect.Appear($("searchResult").down("div", 0), {
				duration : .001
			});
			$("searchForm").reset();
		}
	});
}