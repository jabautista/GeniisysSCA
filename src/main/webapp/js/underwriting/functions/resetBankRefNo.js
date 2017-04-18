/*	Created by	: Jerome Orio 01.11.2011
 * 	Description	: reset bank reference number in GIPIS002, GIPIS017
 * 	Parameters	: 
 */
function resetBankRefNo(){
	if ($F("swBankRefNo") != "Y"){
		$("nbtBranchCd").value = "0000";
		$("dspRefNo").value = "0000000";
		$("dspModNo").value = "00";
		$("bankRefNo").value = "";
		enableButton("btnGenerateBankDtls");
	}
}