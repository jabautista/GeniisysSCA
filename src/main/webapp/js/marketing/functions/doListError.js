/** 
 * Quotation Warranty and Clauses Scripts 
 */
function doListError() {
	if ((typeof errorNoList) != "undefined") {
		new Effect.Highlight($("errorNoList"), {
			startcolor : '#ff0000',
			endcolor : '#ffffff',
			restorecolor : true
		});
	}
}