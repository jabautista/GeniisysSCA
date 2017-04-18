/*
 * Tonio 8.10.2011
 * GICLS010 Claim Basic Information
 * Get Claims Menu properties
 */
function getClaimsMenuProperties(param){
	new Ajax.Request(contextPath + "/GICLClaimsController?action=initializeMenu", {
		method: "GET",
		parameters: {
			claimId: objCLMGlobal.claimId,
			lineCd: objCLMGlobal.lineCd
		},
		asynchronous: false,
		evalScripts: true,
		onCreate : function() {
			nvl(param,false) ? null :showNotice("Loading, please wait..."); //nok added condition
		},
		onComplete: function (response){
			if (checkErrorOnResponse(response)) {
				hideNotice("");
				var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				setClaimsMenuProperty(obj);
			}
		}
	});
}