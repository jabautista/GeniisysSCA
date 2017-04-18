/**
 * Shows Disbursement Voucher Page
 * 
 * @author Kris Felipe
 * @module GIACS002
 * @date 04.11.2013
 * 
 * andrew added parameter queryOnly
 */
function showDisbursementVoucherPage(cancelFlag, action, queryOnly) {
	// objGIACS002.cancelFlag = cancelFlag;
	objGIACS002.cancelDV = cancelFlag;
	objACGlobal.queryOnly = objGIACS002.fromGIACS054 ? "Y" : queryOnly;
	var message = action == "getGIACS002DisbVoucherList" ? "Loading Generate Disbursement Voucher page, please wait..."
			: "Loading Disbursement Voucher Listing, please wait...";
	try {
		new Ajax.Request(contextPath + "/GIACDisbVouchersController", {
			parameters : {
				action : action,
				gaccTranId : nvl(objACGlobal.gaccTranId, 0),
				fundCd : objGIACS002.fundCd,
				branchCd : objGIACS002.branchCd,
				moduleId : "GIACS002",
				cancelFlag : cancelFlag,
				dvFlagParam:		"N"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function() {
				showNotice(message);
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					if (objACGlobal.callingForm == "GIACS230") { // if
																	// condition
																	// added by
																	// shan
																	// 04.29.2013
						$("mainContents").update(response.responseText);
						enableFields(false);
					}else if(objGIACS002.fromGIACS054){
						$("GIACS002Div").update(response.responseText);
						$("GIACS002Div").show();
						$("checkBatchPrintingMainDiv").hide();
					} else {
						$("mainContents").update(response.responseText);
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("showDisbursementVoucherPage", e);
	}
}