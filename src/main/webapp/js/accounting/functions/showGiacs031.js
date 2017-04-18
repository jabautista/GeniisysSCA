/**
 * @module GIACS031
 * @description PDC Collections
 * @author John Dolon
 * @date 9.18.2014
 */
function showGiacs031() {
	new Ajax.Request(contextPath + "/GIACPdcChecksController", {
		method : "POST",
		parameters : {
			action : "showGiacs031",
			gaccTranId : objACGlobal.gaccTranId
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete : function(response) {
			hideNotice();
			if (checkErrorOnResponse(response)) {
				$("transBasicInfoSubpage").update(response.responseText);
			}
		}
	});
}