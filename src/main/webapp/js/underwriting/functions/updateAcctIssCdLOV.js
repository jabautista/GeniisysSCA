/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: update LOV for Bank reference number ACCT_ISS_CD in GIPIS002, GIPIS017
 * 	Parameters	: objArray - object array to be used in listing
 */
function updateAcctIssCdLOV(objArray){
	$("selNbtAcctIssCd").enable();
	removeAllOptions($("selNbtAcctIssCd"));
	var opt = document.createElement("option");
	opt.value = "01";
	opt.text = "01";
	$("selNbtAcctIssCd").options.add(opt);
	for(var a=0; a<objArray.length; a++){
		if (formatNumberDigits(objArray[a].acctIssCd,2) != "01"){
			var opt = document.createElement("option");
			opt.value = formatNumberDigits(objArray[a].acctIssCd,2);
			opt.text = formatNumberDigits(objArray[a].acctIssCd,2);
			$("selNbtAcctIssCd").options.add(opt);
		}
	}
}