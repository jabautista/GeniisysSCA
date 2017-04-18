/***
 *  For Casualty personnel  no
 *  irwin 9.20.2012
 * */
function validatePersonnelNo(){
	try{
		new Ajax.Request("GICLCasualtyDtlController",{
			parameters:{
				action: 	"validatePersonnelNo",
				lineCd: 	objCLMGlobal.lineCd,
				sublineCd: 	objCLMGlobal.sublineCd,
				polIssCd: 	objCLMGlobal.policyIssueCode,
				issueYy: 	objCLMGlobal.issueYy,
				polSeqNo: 	objCLMGlobal.policySequenceNo,
				renewNo: 	objCLMGlobal.renewNo,
				polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
				expiryDate: objCLMGlobal.strExpiryDate2,
				lossDate: 	objCLMGlobal.strLossDate2,
				issCd: 		objCLMGlobal.issCd,
				itemNo: 	$F("txtItemNo"),
				claimId :objCLMGlobal.claimId,
				personnelNo:	$F("txtPerNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					function resetFields(){
						$("txtPerNo").value = "";
						$("txtPersonnel").value = "";
						$("txtCaPosition").value = "";
						$("txtPosNo").value = "";
						$("txtPosDes").value = "";
						$("txtCoverage").value = "";
						$("txtPerNo").focus();
					}
					if(checkCustomErrorOnResponse(response,resetFields)){
						var mes = response.responseText.toQueryParams();
						objCLMItem.itemLovSw = true;
						$("txtPersonnel").value = unescapeHTML2(mes.name);
						$("txtCaPosition").value =mes.capacityCd ==  null ? "" : mes.capacityCd +" - "+ unescapeHTML2(mes.position);
						$("txtPosNo").value = mes.capacityCd;
						$("txtPosDes").value = unescapeHTML2(mes.position);
						$("txtCoverage").value	= formatCurrency(mes.amountCovered);
						$("txtPerNo").focus();
					}
					
				}
			}
		});
	}catch(e){
		showErrorMessage("validatePersonnelNo",e);
	}
}