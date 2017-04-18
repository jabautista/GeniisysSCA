/**
 * Observe div/forms that are dependent to pack quote.
 * This restricts processing if no pack quote is selected. 
 */

function observePackQuoteChildRecords(){
	$$("div.quoteChildRecord").each(function(rec){
		rec.descendants().each(function (obj) {
			if (obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA" || obj.nodeName == "SELECT") {
				obj.observe("focus", function (event) {
					checkIfNoPackQuoteIsSelected();		
				});
			}
		});
	});
}