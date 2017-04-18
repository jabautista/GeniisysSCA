// moved from directTransPremDeposit.jsp : shan 11.04.2013
function validateOldTranType() {
	collectionDefaultAmount($F("txtTransactionType"));
	$("lastOldTranType").value = $F("txtOldTranType");
}