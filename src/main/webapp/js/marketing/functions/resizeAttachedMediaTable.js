/**
 * Resizes the table for attached media records for
 * Package Quotation Information 
 * 
 */

function resizeAttachedMediaTable() {
	var ctr = 0;
	var selectedItem = getSelectedRow("row").getAttribute("itemNo");
	
	$$("div[name='rowMedia']").each(function(row) {
		if(row.getAttribute("quoteId")== objCurrPackQuote.quoteId 
		   && row.getAttribute("itemNo") == selectedItem){
			ctr++;
		}
	});
	
	if (ctr > 3) {
		$("mediaUploaded").setStyle("height: 210px; overflow-y: auto;");
	} else {
		$("mediaUploaded").setStyle("height: " + (parseInt(ctr) * 68) + "px;");
	}
}