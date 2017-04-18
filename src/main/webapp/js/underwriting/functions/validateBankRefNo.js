/**
 * Validate Bank reference number in GIPIS002, GIPIS017
 * @author Jerome Orio 01.12.2011
 * @version 1.0
 * @param 
 * @return
 */
function validateBankRefNo(){
	var ok = true;
	new Ajax.Request(contextPath+"/GIPIParInformationController?action=validateBankRefNo",{
		method: "POST",
		parameters:{
			parId: $F("globalParId"),
			lineCd: $F("globalLineCd"),
			issCd: $F("globalIssCd"),
			nbtAcctIssCd: $F("nbtAcctIssCd"),
			nbtBranchCd: $F("nbtBranchCd"),
			dspRefNo: $F("dspRefNo"),
			dspModNo: $F("dspModNo"),
			bankRefNo: $F("bankRefNo")
		},
		asynchronous: false,
		evalScripts: true,
		onComplete: function(response){
			if (checkErrorOnResponse(response)){
				if (response.responseText != ""){
					resetBankRefNo();
					customShowMessageBox(response.responseText, imgMessage.ERROR, "nbtAcctIssCd");
					ok = false;
					return false;
				}else{
					ok = true;
					return true;	
				}	
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
				ok = false;
				return false;
			}		
		}	
	});
	return ok;
}