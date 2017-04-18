/**
 * @module GAICS147
 * @description Prin Premium Deposit
 * @author Kenneth Mark Labrador
 * @date 06.20.2013
 */
function showPremiumDepositMainPage() {
	try {
		new Ajax.Request(contextPath + "/GIACPremDepositController", {
			parameters : {
				action : "showPremiumDeposit"
			},
			onCreate : function() {
				showNotice("Loading Premium Deposit, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showPremiumDeposit", e);
	}
}