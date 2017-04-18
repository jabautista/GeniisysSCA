function clickGrpCover(obj, newDiv) {
	newDiv.observe("click", function() {
		newDiv.toggleClassName("selectedRow");
		if(newDiv.hasClassName("selectedRow")) {
			$$("div#coverageListing div[name='cvgRow']").each(function(cr) {
				if(newDiv.getAttribute("id") != cr.getAttribute("id")) {
					cr.removeClassName("selectedRow");
				}
			});
			setCoverForm(obj);
		} else {
			setCoverForm(null);
		}
	});
}