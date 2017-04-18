// position the pager div
function positionPageDiv() {
	var size = $$("div[name='row']").size();
	$$("div[name='row']").each(function (row) {
		if (!row.visible()) {
			size--;
		}
	});
	var margin = 310 - (size*30);
	$("pager").setStyle("margin-top: "+margin+"px;");
}