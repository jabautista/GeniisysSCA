/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Bancassurance Banc type in GIPIS002, GIPIS017
 * 	Parameters	: objArray - object array to be used in listing
 *				  initValue - initial value 
 */
function updateBancTypeCdLOV(objArray, initValue){
	$("selBancTypeCd").enable();
	removeAllOptions($("selBancTypeCd"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	$("selBancTypeCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		var opt = document.createElement("option");
		opt.value = objArray[a].bancTypeCd;
		opt.text = objArray[a].bancTypeCd+" - "+changeSingleAndDoubleQuotes(objArray[a].bancTypeDesc);
		$("selBancTypeCd").options.add(opt);
	}
	$("selBancTypeCd").value = initValue;
}