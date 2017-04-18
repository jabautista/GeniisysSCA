/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Bank reference number in GIPIS002, GIPIS017
 * 	Parameters	: objArray - object array to be used in listing
 */
function updateBankRefNoLOV(objArray){
	$("selNbtBranchCd").enable();
	removeAllOptions($("selNbtBranchCd"));
	var opt = document.createElement("option");
	opt.value = "0000";
	opt.text = "0000";
	$("selNbtBranchCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		if (formatNumberDigits(objArray[a].acctIssCd,4) != "0000"){
			if ($F("selNbtAcctIssCd") != ""){
				if ($F("selNbtAcctIssCd") == formatNumberDigits(objArray[a].acctIssCd,2)){
					var opt = document.createElement("option");
					opt.value = formatNumberDigits(objArray[a].branchCd,4);
					opt.text = formatNumberDigits(objArray[a].branchCd,4);
					$("selNbtBranchCd").options.add(opt);
				}
			}else{
				var opt = document.createElement("option");
				opt.value = formatNumberDigits(objArray[a].branchCd,4);
				opt.text = formatNumberDigits(objArray[a].branchCd,4);
				$("selNbtBranchCd").options.add(opt);
			}		
		}
	}
}