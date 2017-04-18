var objGICLS024 = {};
var objCurrReserveDS = null;
/** 
 * 
 */

/**
 * unused
 */
function showResHistOverlayGrid(itemNo, perilCd){
	try{
		new Ajax.Updater("reserveHistoryGrid", contextPath+"/GICLClaimReserveController",{
			method : "POST",
			parameters:{
				action: "getClmResHistGrid",
				claimId: nvl(objCLMGlobal.claimId, 0),
				itemNo: 8,
				perilCd: 32,
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$(targetDiv).hide();
			},
			onComplete : function(){
				$(targetDiv).show();
			}
		});
	}catch(e){
		showErrorMessage("reserve history tg call", e);
	}
}

var objCurrPaytHistory = {};