/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Bancassurance Banc area in GIPIS002, GIPIS017
 * 	Parameters	: objArray - object array to be used in listing
 *				  initValue - initial value
 */
function updateBancAreaCdLOV(objArray, initValue){
	$("selAreaCd").enable();
	removeAllOptions($("selAreaCd"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	$("selAreaCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		var opt = document.createElement("option");
		opt.value = objArray[a].areaCd;
		opt.text = objArray[a].areaCd+" - "+changeSingleAndDoubleQuotes(objArray[a].areaDesc);
		$("selAreaCd").options.add(opt);
	}
	$("selAreaCd").value = initValue;
}