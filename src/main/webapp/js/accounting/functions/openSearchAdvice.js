/**
 * Call the Modal Box for searching Advice Sequence Number - GIACS017
 * 
 * @author rencela 10/19/2010
 * @return
 */
function openSearchAdvice() {
	if (!$F("selTransactionType").blank()) {
		Modalbox
				.show(
						contextPath
								+ "/GIACDirectClaimPaymentController?action=openSearchAdviceModalBox&ajaxModal=1",
						{
							title : "Search Advice",
							width : 900,
							asynchronous : true
						});
	} else {
		showMessageBox("Please select Transaction Type first", imgMessage.ERROR);
	}
}