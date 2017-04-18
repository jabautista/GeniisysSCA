function clickACGrouped(obj, newDiv) {
	newDiv.observe("click", function() {
		newDiv.toggleClassName("selectedRow");
		if(newDiv.hasClassName("selectedRow")) {
			$$("div[name='grpRow']").each(function(gr) {
				if(newDiv.getAttribute("id") != gr.getAttribute("id")) {
					gr.removeClassName("selectedRow");
				}
			});
			setACGroupedForm(obj);
		} else {
			setACGroupedForm(null);
		}
		clearCoverageListing();
		loadACCoverageSubPage(objWItmperlGrouped, $("groupedItemNo").value);
		loadGroupedBen(objWGrpItemBen, $("groupedItemNo").value);
	});
}