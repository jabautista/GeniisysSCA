/**
 * Populate memo info in Accounting entries when called by GIACS071
 * 
 * @author mariekris
 * @module GIACS071
 * @date 04.09.2013
 */
function populateAccountingEntriesForMemo() {
	try {
		$("fundCd").value = objACGlobal.fundCd;
		$("branch").value = objACGlobal.branchCd;
		$("transactionNo").value = objGIAC071.memoTranNumber;
		$("orNo").value = objGIAC071.memoNumber;
		$("orStatus").value = objGIAC071.memoStatus;
		$("orDate").value = objGIAC071.memoDate;
		$("grossAmtCurrency").value = objGIAC071.memoForeignCurrency; // objGIAC071.memoLocalCurrency;
		$("grossAmt").value = objGIAC071.memoForeignAmt; // objGIAC071.memoLocalAmt;
		$("payor").value = unescapeHTML2(objGIAC071.memoRecipient);
		$("fCurrency").value = objGIAC071.memoLocalCurrency; // objGIAC071.memoForeignCurrency;
		$("fCurrencyAmt").value = objGIAC071.memoLocalAmt; // objGIAC071.memoForeignAmt;
		$("lblOrNo").innerHTML = "Memo No:";
		$("lblOrStatus").innerHTML = "Memo Status:";
		$("lblOrDate").innerHTML = "Memo Date:";
	} catch (e) {
		showErrorMessage("populateAccountingEntriesForMemo", e);
	}
}