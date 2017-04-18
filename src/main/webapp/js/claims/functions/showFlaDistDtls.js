/**
 * Shows Final Loss Advice Distribution Details
 * Module: GICLS033
 * @author Marco Paolo Rebong
 * @date 03.30.2012
 */
function showFlaDistDtls(claimId, adviceId, lineCd){
	new Ajax.Updater("distDtlsGroDiv", contextPath+"/GICLAdvsFlaController",{
		method: "POST",
		parameters: {
			action   : "getFLADistDtls",
			claimId  : claimId,
			adviceId : adviceId,
			lineCd   : lineCd
		},
		evalScripts: true,
		asynchronous: true,
		onComplete: function() {
			hideNotice("");
		}
	});
}