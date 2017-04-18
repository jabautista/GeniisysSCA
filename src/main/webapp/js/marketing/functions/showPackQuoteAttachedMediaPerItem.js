/**
 * Shows attached media records for the selected item and 
 * hides records of other items under the Package Quotation.
 */

function showPackQuoteAttachedMediaPerItem(){
	var selectedItem = getSelectedRow("row").getAttribute("itemNo");
	
	if($("mediaItemNo") != null ){
		$("mediaItemNo").value = selectedItem;
	}
	
	if($("btnUploadMedia") != null && $("btnUploadMedia") != null){
		enableButton("btnUploadMedia"); 				
		disableButton("btnDeleteMedia");
	}
	
	$$("div[name='rowMedia']").each(function(row) {
		row.hide();
		row.removeClassName("selectedRow");
		if(row.getAttribute("quoteId")== objCurrPackQuote.quoteId &&
		   row.getAttribute("itemNo") == selectedItem){
			row.show();
		}
	});
	resizeAttachedMediaTable();
}