/**
 * @author d.alcantara resets value for some of the global params in accounting
 * @date 05.28.2012
 */
function setORParams(module) {
	try {
		new Ajax.Request(contextPath + "/GIACOrderOfPaymentController", {
			method : "GET",
			parameters : {
				action : "retrieveORParams",
				gaccTranId : objACGlobal.gaccTranId
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					objACGlobal.orFlag = res.orFlag;
					objACGlobal.opTag = res.opTag;
					objACGlobal.tranFlagState = res.tranFlag;
					objACGlobal.orTag = res.orTag;
					objAC.tranFlagState = res.tranFlag; // andrew - 09.01.2012
					// dagdagan na lang pag may kailangan pa
					if (nvl(module, "") == "GIACS025") { // marco -
															// 07.08.2013 -
															// added module
															// parameter
						$("orNo").value = nvl(res.orNo, "");
						$("orStatus").value = nvl(res.orFlagRV, "");
					}
					
				}
			}
		});
	} catch (e) {
		showErrorMessage("retrieveORParams", e);
	}
}