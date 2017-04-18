/**
 * Filters the Motor Types LOV in the Motor Car Additional Information 
 * which depends on the sublineCd of the quotation selected.
 * @param sublineCd - the sublineCd of the current quotation
 * 
 */

function filterPackMotorTypesLOV(sublineCd){
	(($$("select#motorType option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
	(($$("select#motorType option:not([sublineCd='" +sublineCd+ "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
	$("motorType").options[0].show();
	$("motorType").options[0].disabled = false;
	$("motorType").show();
}