/** Populates Tax Info in Other Trans for GIACS070
 * @author:	shan
 * @date:	08.28.2013
 * @module:	GIACS070
 */
function populateTaxPaymentForJournalVoucher(){
	try{
		if(objACGlobal.callingForm == "DETAILS"){
			$("fundCd").value = objGIACS070.taxFieldInfo.gibrGfunFundCd;
			$("branch").value = objGIACS070.taxFieldInfo.gibrBranchCd;
			$("transactionNo").value = nvl(objGIACS070.taxFieldInfo.gprqDocYear, "") + "-" + nvl(lpad(objGIACS070.taxFieldInfo.gprqDocMonth, 2, 0), "") 
									   + "-" +  nvl(lpad(objGIACS070.taxFieldInfo.tranSeqNo, 6, 0), "");
			$("orNo").value = lpad(objGIACS070.taxFieldInfo.dvNo, 6, 0);
			$("orStatus").value = objGIACS070.taxFieldInfo.dvFlagMean;
			$("orDate").value = objGIACS070.taxFieldInfo.dspPrintDate;
			$("grossAmtCurrency").value = objGIACS070.taxFieldInfo.foreignCurrency; 
			$("grossAmt").value = objGIACS070.taxFieldInfo.dvFcurrencyAmt == null ? objGIACS070.taxFieldInfo.dvFcurrencyAmt : 
								  	  formatCurrency(objGIACS070.taxFieldInfo.dvFcurrencyAmt); 
			$("payor").value = unescapeHTML2(objGIACS070.taxFieldInfo.payee);
			$("fCurrency").value = objGIACS070.taxFieldInfo.localCurrency; 
			$("fCurrencyAmt").value = objGIACS070.taxFieldInfo.dvAmt;			
		}else if(objACGlobal.callingForm == "DISB_REQ"){
			$("fundCd").value = objACGlobal.hidObjGIACS070.giopGaccFundCd;
			$("branch").value = objACGlobal.hidObjGIACS070.giopGaccBranchCd;
			$("transactionNo").value = nvl(objGIACS070.selectedRow.tranYy, "") + "-" + nvl(lpad(objGIACS070.selectedRow.tranMm, 2, 0), "") 
									   + "-" +  nvl(lpad(objGIACS070.selectedRow.tranSeqNo, 6, 0), "");
			var lineCd = objGIACS070.taxFieldInfo[0].lineCd == null ? "" : objGIACS070.taxFieldInfo[0].lineCd + "-";
			$("orNo").value = nvl(objGIACS070.taxFieldInfo[0].documentCd,"")+"-"+nvl(objGIACS070.taxFieldInfo[0].branchCd,"")+"-"+lineCd
							+objGIACS070.taxFieldInfo[0].docYear+"-"+objGIACS070.taxFieldInfo[0].docMm+"-"+objGIACS070.taxFieldInfo[0].docSeqNo;							
			$("orStatus").value = objGIACS070.taxFieldInfo[1].meanPaytReqFlag;
			$("orDate").value = objGIACS070.taxFieldInfo[0].strRequestDate;
			$("grossAmtCurrency").value = objGIACS070.taxFieldInfo[1].dspFshortName; 
			$("grossAmt").value = objGIACS070.taxFieldInfo[1].dvFcurrencyAmt == null ? objGIACS070.taxFieldInfo[1].dvFcurrencyAmt : 
								  	  formatCurrency(objGIACS070.taxFieldInfo[1].dvFcurrencyAmt); 
			$("payor").value = unescapeHTML2(objGIACS070.taxFieldInfo[1].payee);
			$("fCurrency").value = objGIACS070.taxFieldInfo[1].dspShortName; 
			$("fCurrencyAmt").value = objGIACS070.taxFieldInfo[1].paytAmt == null ? objGIACS070.taxFieldInfo[1].paytAmt : 
									  formatCurrency(objGIACS070.taxFieldInfo[1].paytAmt);
		}
	}catch(e){
		showErrorMessage("populateTaxPaymentForJournalVoucher", e);
	}
}