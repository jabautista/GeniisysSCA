function onSelectPayeeClassCd(obj){
	var payeeClassCd = unescapeHTML2(obj.payeeClassCd);
	
	$("payeeClass").value = unescapeHTML2(obj.classDesc);
	$("payeeClass").setAttribute("payeeClassCd", obj.payeeClassCd);
	
	if(payeeClassCd == $("hidRiPayeeClass").value && objCLMGlobal.issueCode == "RI"){
		getDefaultReinsurer();
	}else if(payeeClassCd == $("hidAssdClassCd").value){
		validateAssdClassCd(payeeClassCd);
	}else if(payeeClassCd == $("hidAdjpClassCd").value){
		validateAdjusterClassCd(payeeClassCd);
	}else if(payeeClassCd == $("hidMortgClassCd").value){
		validateMortgageeClassCd(payeeClassCd);
	}else if(payeeClassCd == $("hidIntmClassCd").value){
		var valIntmAvail = validateTextFieldLOV("/ClaimsLOVController?action=getLossExpPayeesList&claimId=" + objCLMGlobal.claimId + "&assdNo=" + objCLMGlobal.assuredNo + "&itemNo=" + nvl(objCurrGICLItemPeril.itemNo, 0)
				+ "&perilCd=" + nvl(objCurrGICLItemPeril.perilCd, 0) + "&payeeClassCd=" + payeeClassCd + "&payeeType=" + $("selPayeeType").value, "%", "Searching, please wait...");
		
		if(valIntmAvail == 0){
			showWaitingMessageBox("There are no more available payee for this claim.", "I", function(){
				$("payee").value = "";
				$("payee").setAttribute("payeeNo", "");
				$("payeeClass").value = "";
				$("payeeClass").setAttribute("payeeClassCd", "");
			});
		}else{
			showLossExpPayeeLov(objCurrGICLItemPeril, $("payeeClass").getAttribute("payeeClassCd"), $("selPayeeType").value);	
		}
	}
}