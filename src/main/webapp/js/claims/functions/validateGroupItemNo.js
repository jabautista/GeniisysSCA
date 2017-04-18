/***
 *  For Casualty Group Item no
 *  irwin 9.20.2012
 * */
function validateGroupItemNo(){
	try{
		new Ajax.Request("GICLCasualtyDtlController",{
			parameters:{
				action: 	"validateGroupItemNo",
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
				groupItemNo:	$F("txtGrpCd")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var mes = response.responseText.toQueryParams();
					if(mes.exist == "N"){
						showWaitingMessageBox("Invalid item no. entered.", "I", function(){
							$("txtGrpCd").value = "";
							$("txtAmtCov").value = "";
							$("txtDspGrpDesc").value = "";
							$("txtGrpCd").focus();
						});
					}else{
						$("txtAmtCov").value = formatCurrency(mes.amountCoverage);
						$("txtDspGrpDesc").value = unescapeHTML2(mes.groupItemTitle);
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("validateGroupItemNo",e);
	}
}