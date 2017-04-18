/**
 * Filters the Carrier LOV in the Marine Cargo Additional Information 
 * which depends on the quoteId of the quotation selected.
 * @param quoteId - the quoteId of the current quotation
 * 
 */

function filterPackCarrierLOV(quoteId){
	(($$("select#vesselCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
	(($$("select#vesselCd option:not([quoteId='" +quoteId+ "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
	$("vesselCd").options[0].show();
	$("vesselCd").options[0].disabled = false;
	$("vesselCd").show();
}