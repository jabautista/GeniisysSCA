/**
 * Shows Final Loss Advice Details
 * Module: GICLS033
 * @author Marco Paolo Rebong
 * @date 03.30.2012
 */
function showFlaDtls(claimId, grpSeqNo, shareType, adviceId){
	new Ajax.Updater("flaDtlsGroDiv", contextPath+"/GICLAdvsFlaController",{
		method: "POST",
		parameters: {
			action    : "getFLADtls",
			claimId   : claimId,
			grpSeqNo  : grpSeqNo,
			shareType : shareType,
			adviceId  : adviceId
		},
		evalScripts: true,
		asynchronous: true,
		onComplete: function() {
			hideNotice("");
		}
	});
}