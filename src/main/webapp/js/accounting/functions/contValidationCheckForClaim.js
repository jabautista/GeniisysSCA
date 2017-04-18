function contValidationCheckForClaim(result1){
	if (result1[0].hasClaim != 'FALSE' && objAC.fromBtnDcOk != 'Y' && nvl(objAC.fromPolOk, "N") == "N") { //added objAC.fromBtnDcOk by robert 11.25.2013
		showConfirmBox("Premium Collection", "The policy of "+objAC.currentRecord.issCd+"-"
				+objAC.currentRecord.premSeqNo+"-"+objAC.currentRecord.instNo
				+" has existing claim(s): Claim Number(s) "+result1[0].hasClaim+
				". Would you like to continue with the premium collections?", "Yes", "No", 
				function () {
					if(objAC.claimsOverride == 1) {
						contValidationCheckForOverdue(result1);
					} else {
						validateUserFunction('CC', 'GIACS007', 'claim', result1);
					}
				}, function () {
					inValidateOverridePayt();
				});

	} else {
		objAC.fromPolOk = "N"; //marco - 09.16.2014
		contValidationCheckForOverdue(result1);
	}
}