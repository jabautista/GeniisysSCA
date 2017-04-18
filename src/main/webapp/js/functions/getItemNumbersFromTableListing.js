// mark jm 09.03.2010
// This function returns item numbers in a specific table in space-delimited format
// Parameter 	:	rowName - name of row used in table listing
//				:	rowNumber - number where the value is located

function getItemNumbersFromTableListing(rowName, rowNumber){
	var itemNos = "";
	
	$$("div[name='" + rowName + "']").each(
		function(row){
			itemNos = itemNos + row.down("input", rowNumber).value + " ";
	});

	itemNos = itemNos.trim();
	
	return itemNos;
}