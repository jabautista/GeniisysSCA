/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: generate bank reference number in GIPIS002, GIPIS017
 * 	Parameters	: bankRefNo - bank reference number
 */
function generateBankRefNo(bankRefNo){
	/*$("generateBankDtls").disable();
	$("generateBankDtls").checked = true;
	$("selNbtAcctIssCd").hide();
	$("selNbtBranchCd").hide();
	$("nbtAcctIssCd").show();
	$("nbtBranchCd").show();*/
	$("nbtAcctIssCd").readOnly = true;
	$("nbtBranchCd").readOnly = true;
	$("nbtAcctIssCd").value = bankRefNo.substr(0,2);
	$("nbtBranchCd").value = bankRefNo.substr(3,4);
	$("dspRefNo").value = bankRefNo.substr(8,7);
	$("dspModNo").value = bankRefNo.substr(-2,2);
	disableButton("btnGenerateBankDtls");
}