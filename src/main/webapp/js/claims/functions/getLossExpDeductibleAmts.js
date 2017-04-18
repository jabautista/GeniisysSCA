function getLossExpDeductibleAmts(){
	try{
		new Ajax.Request(contextPath+"/GICLLossExpDtlController", {
			asynchronous: false,
			parameters:{
				action: "getLossExpDeductibleAmts",
				claimId: objCLMGlobal.claimId,
				lossExpCd: $("txtLossExpCd").getAttribute("lossExpCd"),
				dtlAmt: unformatCurrencyValue($("txtDeductibleAmt").value),
				dedBaseAmt : unformatCurrencyValue($("txtDedBaseAmt").value),
				noOfUnits: nvl($("txtDedUnits").value, 1),
				nbtDeductType: $("hidDedType").value,
				dedRate:   formatToNineDecimal($("txtDedRate").value), //changed by : Kenneth : 05.26.2015 : SR 3637
				nbtMinAmt: $("hidDedMinAmt").value,
				nbtMaxAmt: $("hidDedMaxAmt").value,
				nbtRangeSw: $("hidDedRangeSw").value,
				nbtDedAggrSw: $("hidDedAggregateSw").value,
				nbtCeilingSw: $("hidDedCeilingSw").value,
				paramDedAmt: unformatCurrencyValue($("txtDeductibleAmt").value),
				nbtDedLossExpCd: $("txtDedLossExpCd").getAttribute("dedLossExpCd"),
				itemNo: objCurrGICLItemPeril.itemNo,
				perilCd: objCurrGICLItemPeril.perilCd,
				groupedItemNo : objCurrGICLItemPeril.groupedItemNo,
				payeeType: objCurrGICLLossExpPayees.payeeType,
				lineCd    : objCLMGlobal.lineCode,
				sublineCd : objCLMGlobal.sublineCd,
				polIssCd  : objCLMGlobal.policyIssueCode,
				issueYy   : objCLMGlobal.issueYy,
				polSeqNo  : objCLMGlobal.policySequenceNo,
				renewNo   : objCLMGlobal.renewNo,
				lossDate  : objCLMGlobal.strDspLossDate,
				polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
				expiryDate: objCLMGlobal.strExpiryDate2
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var jsonDed = JSON.parse(response.responseText);
					$("txtDedBaseAmt").value = formatCurrency(jsonDed.dedBaseAmt);
					$("txtDedRate").value = formatToNineDecimal(jsonDed.dedRate);
					$("txtDeductibleAmt").value = formatCurrency(jsonDed.dtlAmt);
					//added by : Kenneth : 05.26.2015 : SR 3637
					if(Math.abs(unformatCurrency("txtDeductibleAmt")) == unformatCurrency("txtDedBaseAmt") && $F("txtDedUnits") == 1){
						$("txtDedRate").value = formatToNineDecimal(100);
					}
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}
			}
		});
	}catch(e){
		showErrorMessage("getLossExpDeductibleAmts", e);	
	}
}