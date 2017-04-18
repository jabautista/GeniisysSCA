// initialize onchange event on paginations
// parameters:
// table: id of the table containing the list
// url: url for the ajax updater
// pageNo: page no selected
function initializePagination(tableId, url, action) {
	try {
	$("pager").down("select", 0).observe("change", function () {
		var pageNo = $("pager").down("select", 0).value;
		goToPageNo(tableId, url, action, pageNo);
	});
	} catch (e) {
		showErrorMessage("initializePagination", e);
	}
}