/**
 * Filters the Geography Description LOV in the Marine Cargo Additional Information 
 * which depends on the quoteId of the quotation selected.
 * @param quoteId - the quoteId of the current quotation
 * 
 */

function filterPackGeogDescLOV(quoteId){
	(($$("select#geogCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
	(($$("select#geogCd option:not([quoteId='" +quoteId+ "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
	$("geogCd").options[0].show();
	$("geogCd").options[0].disabled = false;
	$("geogCd").show();
}