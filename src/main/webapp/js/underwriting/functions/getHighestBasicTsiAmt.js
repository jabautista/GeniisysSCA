function getHighestBasicTsiAmt(itemNo){
	var highestBasicTsiAmt = 0;
	$$("div[name='row2']").each(function(row){
		if (row.getAttribute("item") == itemNo){
			perilExistsForCurrentItem = true;
			if (row.down("input", 8).value == "B"){
				if (parseFloat(row.down("input", 5).value.replace(/,/g, "")) > parseFloat(highestBasicTsiAmt)){
					highestBasicTsiAmt = parseFloat(row.down("input", 5).value.replace(/,/g, ""));
				}
			}
		}
	});
	return highestBasicTsiAmt;
}