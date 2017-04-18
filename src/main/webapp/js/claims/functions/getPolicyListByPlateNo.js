/**
 * @author rey
 * @date 16-12-2011
 * @param plateNo
 */
function getPolicyListByPlateNo(plateNo,serialNo,motorNo){
	new Ajax.Updater("tableGridOuterDiv", contextPath + "/GICLNoClaimMultiYyController?action=getNoClaimPolicyList", {
		method: "GET",
		parameters: {
			plateNo: plateNo,
			serialNo: serialNo,
			motorNo: motorNo
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			
		},
		onComplete: function (response){			
		}
	});
}