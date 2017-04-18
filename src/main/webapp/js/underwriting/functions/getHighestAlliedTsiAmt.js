function getHighestAlliedTsiAmt(itemNo){
	var highestAlliedTsiAmt = 0;
	$$("div[name='row2']").each(function(row){
		if (row.getAttribute("item") == itemNo){
			perilExistsForCurrentItem = true;
			if (row.down("input", 8).value == "A"){
				if (parseFloat(row.down("input", 5).value.replace(/,/g, "")) > parseFloat(highestAlliedTsiAmt)){
					highestAlliedTsiAmt = parseFloat(row.down("input", 5).value.replace(/,/g, ""));
				}
			}
		}
	});
	return highestAlliedTsiAmt;
}