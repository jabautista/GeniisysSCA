/**
 * Show other collections page GIACS015 - Other Collections
 * 
 * @author Kenneth Labrador
 * @date 06.07.2013
 */
function showOtherCollection() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACOtherCollnsController?action=getGIACOtherCollns", {
		method : "GET",
		parameters : {
			gaccTranId : objACGlobal.gaccTranId,
			fundCd : objACGlobal.fundCd,
			ajax : 1
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Other Collections...");
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}