/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Company in GIPIS002, GIPIS017
 * 	Parameters	: objArray - object array to be used in listing
 *				  initValue - initial value
 */
function updateCompanyLOV(objArray, initValue){
	$("companyCd").enable();
	removeAllOptions($("companyCd"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	$("companyCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		var opt = document.createElement("option");
		opt.value = objArray[a].payeeNo;
		opt.text = objArray[a].payeeNo+" - " + changeSingleAndDoubleQuotes(objArray[a].nbtPayeeName);
		$("companyCd").options.add(opt);
	}
	$("companyCd").value = initValue;
}