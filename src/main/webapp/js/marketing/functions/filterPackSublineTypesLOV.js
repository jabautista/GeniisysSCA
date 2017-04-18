/**
 * Filters the Subline Types LOV in the Motor Car Additional Information 
 * which depends on the sublineCd of the quotation selected.
 * @param sublineCd - the sublineCd of the current quotation
 * 
 */

function filterPackSublineTypesLOV(sublineCd){
	(($$("select#sublineType option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
	(($$("select#sublineType option:not([sublineCd='" +sublineCd+ "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
	$("sublineType").options[0].show();
	$("sublineType").options[0].disabled = false;
	$("sublineType").show();
}