function clickGrpBen(obj, newDiv) {
	newDiv.observe("click", function() {
		newDiv.toggleClassName("selectedRow");
		if(newDiv.hasClassName("selectedRow")) {
			$$("div[name='gBenRow']").each(function(gr) {
				if(newDiv.getAttribute("id") != gr.getAttribute("id")) {
					gr.removeClassName("selectedRow");
				}
			});
			setGrpBenForm(obj);

		} else {
			setGrpBenForm(null);
		}
		
		if(!($("acBenPerilListing").empty())) {
			$$("div#acBenPerilListing div[name='benPerlRow']").each(function(bpr) {
				bpr.remove();
			});
		}
		loadGroupedBenPerils(objWItmPerilBen, $F("groupedItemNo"), $F("bBeneficiaryNo"));
	});
}