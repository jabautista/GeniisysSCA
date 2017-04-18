/**
 * @date 04.22.2013
 * @module GIACS002
 * @params objDV - if called from disbursementVoucher.jsp, pass the voucher info
 * @params gaccTranId - if called from the listing, pass only the gaccTranId
 */
function showCheckDetailsPage(objDV, gaccTranId) {
	try {
		new Ajax.Request(
				contextPath
						+ "/GIACDisbVouchersController?action=getGIACS002ChkDisbursementTG",
				{
					parameters : {
						gaccTranId : gaccTranId,
						branchCd : objACGlobal.branchCd, //added by steven 09.15.2014
						fundCd : objACGlobal.fundCd
					/*
					 * , dvItem: JSON.stringify(objDV)
					 */
					},
					evalScripts : true,
					asynchronous : false,
					onCreate : function() {
						showNotice("Redirecting to Check Details Page, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						objGIACS002.itemNoList = null;
						if (checkErrorOnResponse(response)) {
							//$("dynamicDiv").update(response.responseText);
							var dvId = objGIACS002.fromGIACS054 ? "dvDetailsDiv" : "mainContents";	// shan 09.26.2014
							if (objGIACS002.fromGIACS054) { //added by steven 10.03.2014
								$("disbursementVoucherMainDiv").hide();
								$("dvDetailsDiv").show();
							}
							$(dvId).update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showCheckDetailsPage: " + e);
	}
}