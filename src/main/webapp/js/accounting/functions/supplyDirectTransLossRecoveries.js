/**
 * Populate form data when user select a record in module GIACS010
 * 
 * @author Jerome Orio 10.07.2010
 * @version 1.0
 * @param obj -
 *            object of giac_loss_recoveries records
 * @return
 */
function supplyDirectTransLossRecoveries(obj) {
	try {
		objAC.hidObjGIACS010.recordStatus = obj.recordStatus;
		$("selTransactionTypeLossRec").value = (obj.transactionType == null ? ""
				: nvl(obj.transactionType, ""));
		$("txtLineCdLossRec").value = unescapeHTML2((obj.lineCd == null ? ""
				: nvl(obj.lineCd, "")));
		$("txtIssCdLossRec").value = unescapeHTML2((obj.issCd == null ? ""
				: nvl(obj.issCd, "")));
		$("txtRecYearLossRec").value = changeSingleAndDoubleQuotes((obj.recYear == null ? ""
				: nvl(obj.recYear, "")));
		$("txtRecSeqNoLossRec").value = changeSingleAndDoubleQuotes((obj.recSeqNo == null ? ""
				: nvl(formatNumberDigits(obj.recSeqNo, 3), "")));
		objAC.hidObjGIACS010.hidClaimId = (obj.claimId == null ? "" : nvl(
				obj.claimId, ""));
		$("txtDspClaimNoLossRec").value = unescapeHTML2((obj.dspClaimNo == null ? ""
				: nvl(obj.dspClaimNo, "")));
		$("txtDspPolicyNoLossRec").value = unescapeHTML2((obj.dspPolicyNo == null ? ""
				: nvl(obj.dspPolicyNo, "")));
		// *****
		$("txtDspLossDateLossRec").value = (obj.dspLossDate == null ? "" : nvl(
				dateFormat(obj.dspLossDate, 'mm-dd-yyyy'), ""));
		// change by shan for PHILFIRE-QA SR-13432 from
		// $("txtDspLossDateLossRec").value =
		// changeSingleAndDoubleQuotes((obj.dspLossDate == null ? ""
		// :nvl(dateFormat(obj.dspLossDate,'mm-dd-yyyy'),"")));
		$("txtDspAssuredNameLossRec").value = unescapeHTML2((obj.dspAssuredName == null ? ""
				: nvl(obj.dspAssuredName, "")));
		objAC.hidObjGIACS010.hidRecoveryId = (obj.recoveryId == null ? ""
				: nvl(obj.recoveryId, ""));
		objAC.hidObjGIACS010.hidRecTypeCd = (obj.recTypeCd == null ? "" : nvl(
				obj.recTypeCd, ""));
		$("txtRecoveryTypeDescLossRec").value = unescapeHTML2((obj.recTypeDesc == null ? ""
				: nvl(obj.recTypeDesc, "")));
		updatePayeeLossRecLOV();
		$("selPayorClassCdLossRec").value 			= changeSingleAndDoubleQuotes((obj.payorClassCd == null ? "" :nvl(obj.payorClassCd,"")));
		objAC.hidObjGIACS010.hidPayorCd			= (obj.payorCd == null ? "" :nvl(obj.payorCd,""));
		$("txtPayorNameLossRec").value 				= unescapeHTML2((obj.payorName == null ? "" :nvl(obj.payorName,"")));
		$("txtRemarksLossRec").value 				= ((obj.remarks == null ? "" :nvl(unescapeHTML2(obj.remarks),"")));
		$("txtCollectionAmtLossRec").value 			= formatCurrency((obj.collectionAmt == null ? "" :nvl(obj.collectionAmt,"")));
		objAC.hidObjGIACS010.hidOrPrintTag 		= (obj.orPrintTag == null ? "" :nvl(obj.orPrintTag,""));
		objAC.hidObjGIACS010.hidCpiRecNo 		= (obj.cpiRecNo == null ? "" :nvl(obj.cpiRecNo,""));
		objAC.hidObjGIACS010.hidCpiBranchCd 	= changeSingleAndDoubleQuotes((obj.cpiBranchCd == null ? "" :nvl(obj.cpiBranchCd,"")));
		if (changeSingleAndDoubleQuotes((obj.acctEntTag == null ? "" :nvl(obj.acctEntTag,""))) == "Y"){
			$("chkAcctEntTagLossRec").checked = true;	
		}else{
			$("chkAcctEntTagLossRec").checked = false;
		}
		$("currencyCdLossRec").value = (obj.currencyCd == null ? "" : nvl(
				obj.currencyCd, ""));
		$("currencyDescLossRec").value = unescapeHTML2(obj.dspCurrencyDesc == null ? ""
				: nvl(obj.dspCurrencyDesc, ""));
		$("convertRateLossRec").value = formatToNineDecimal(obj.convertRate == null ? ""
				: nvl(obj.convertRate, ""));
		$("foreignCurrAmtLossRec").value = formatCurrency(obj.foreignCurrAmt == null ? ""
				: nvl(obj.foreignCurrAmt, ""));
		enableOrDisableDirectTransLossRec(obj);
	} catch (e) {
		showErrorMessage("supplyDirectTransLossRecoveries", e);
	}
}