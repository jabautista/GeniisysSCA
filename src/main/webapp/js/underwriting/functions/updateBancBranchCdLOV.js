/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Bancassurance Banc branch in GIPIS002, GIPIS017
 * 	Parameters	: param - true/false true if called in initialize
 *				  objArray - object array to be used in listing
 *				  initValue - initial value
 *				  managerCd - is where to put the value of manager cd
 */
function updateBancBranchCdLOV(param, objArray, initValue, managerCd){
	$("selBranchCd").enable();
	removeAllOptions($("selBranchCd"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	opt.setAttribute("areaCd", ""); 
	opt.setAttribute("managerCd", ""); 
	opt.setAttribute("managerName", ""); 
	$("selBranchCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		if ($F("selAreaCd") != ""){
			if ($F("selAreaCd") == objArray[a].areaCd){
				var opt = document.createElement("option");
				opt.value = objArray[a].branchCd;
				opt.text = objArray[a].branchCd+" - "+changeSingleAndDoubleQuotes(objArray[a].branchDesc);
				opt.setAttribute("areaCd", objArray[a].areaCd); 
				opt.setAttribute("managerCd", objArray[a].managerCd); 
				opt.setAttribute("managerName", objArray[a].dspManagerName); 
				$("selBranchCd").options.add(opt);
			}
		}else{
			var opt = document.createElement("option");
			opt.value = objArray[a].branchCd;
			opt.text = objArray[a].branchCd+" - " + changeSingleAndDoubleQuotes(objArray[a].branchDesc);
			opt.setAttribute("areaCd", objArray[a].areaCd);
			opt.setAttribute("managerCd", objArray[a].managerCd);
			opt.setAttribute("managerName", objArray[a].dspManagerName); 
			$("selBranchCd").options.add(opt);
		}
	}
	if ($("selAreaCd").value == ""){
		for(var a=0; a<$("selAreaCd").length; a++){
			$("selAreaCd").options[a].show();
			$("selAreaCd").options[a].disabled = false;
		}
	}
	if (param){
		$("selBranchCd").value = initValue;
		$("dspManagerCd").value = getListAttributeValue("selBranchCd", "managerCd");
		$("dspManagerName").value = getListAttributeValue("selBranchCd", "managerName");
	}

	if ($F("selBranchCd") == ""){
		$("dspManagerCd").value = "";
		$("dspManagerName").value = "No managers for the given values.";
	}else{
		$("dspManagerCd").value = getListAttributeValue("selBranchCd", "managerCd");
		$("dspManagerName").value = getListAttributeValue("selBranchCd", "managerName");
	}
}