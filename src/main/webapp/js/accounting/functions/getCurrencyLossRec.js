/**
 * Get the currecy info in module GIACS010
 * 
 * @author Jerome Orio 10.11.2010
 * @version 1.0
 * @param
 * @return
 */
function getCurrencyLossRec() {
	new Ajax.Request(
			contextPath + "/GIACLossRecoveriesController?action=getCurrency",
			{
				parameters : {
					recoveryId : objAC.hidObjGIACS010.hidRecoveryId.toString(),
					claimId : objAC.hidObjGIACS010.hidClaimId.toString(),
					dspLossDate : $F("txtDspLossDateLossRec"),
					collectionAmt : unformatCurrency("txtCollectionAmtLossRec")
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					var currJSON = response.responseText.evalJSON();
					if (currJSON.vMsgAlert == null || currJSON.vMsgAlert == "") {
						$("currencyDescLossRec").value = currJSON.dspCurrencyDesc;
						$("convertRateLossRec").value = formatToNineDecimal(currJSON.convertRate);
						$("currencyCdLossRec").value = currJSON.currencyCd;
						$("foreignCurrAmtLossRec").value = formatCurrency(currJSON.foreignCurrAmt);
					} else {
						showMessageBox(currJSON.vMsgAlert, imgMessage.ERROR);
					}
				}
			});
}