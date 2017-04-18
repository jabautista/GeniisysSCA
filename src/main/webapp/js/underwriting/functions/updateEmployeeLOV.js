/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Employee in GIPIS002, GIPIS017
 * 	Parameters	: param - true/false true if called in initialize
 *				  objArray - object array to be used in listing
 *				  initValue - initial value
 */
function updateEmployeeLOV(param, objArray, initValue){
	$("employeeCd").enable();
	removeAllOptions($("employeeCd"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	opt.setAttribute("empNo", ""); 
	opt.setAttribute("masterEmpNo", "");
	$("employeeCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		if ($F("companyCd") != ""){
			if (objArray[a].masterPayeeNo == $F("companyCd")){
				var opt = document.createElement("option");
				opt.value = objArray[a].refPayeeCd;
				opt.text = objArray[a].refPayeeCd+" - "+changeSingleAndDoubleQuotes(objArray[a].nbtPayeeName);
				opt.setAttribute("empNo", objArray[a].payeeNo);
				opt.setAttribute("masterEmpNo", objArray[a].masterPayeeNo); 
				$("employeeCd").options.add(opt);
			}	
		}else{
			var opt = document.createElement("option");
			opt.value = objArray[a].refPayeeCd;
			opt.text = objArray[a].refPayeeCd+" - "+changeSingleAndDoubleQuotes(objArray[a].nbtPayeeName);
			opt.setAttribute("empNo", objArray[a].payeeNo); 
			opt.setAttribute("masterEmpNo", objArray[a].masterPayeeNo); 
			$("employeeCd").options.add(opt);
		}					
	}
	if (param){
		$("employeeCd").value = initValue;
	}	
}