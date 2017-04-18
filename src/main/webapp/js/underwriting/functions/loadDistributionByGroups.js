function loadDistributionByGroups(){
	new Ajax.Request(contextPath + "/GIUWPolDistController?action=loadDistByGroupsGIUWS013JSON", {
		method: "GET",
		parameters: {
			parId: objGIPIPolbasicPolDistV1.parId,
			policyId: objGIPIPolbasicPolDistV1.policyId,
			distNo: objGIPIPolbasicPolDistV1.distNo
			//lineCd: objGIPIPolbasicPolDistV1.lineCd,
			//issCd: objGIPIPolbasicPolDistV1.issCd
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			objUW.hidObjGIUWS013 = {};
			objUW.hidObjGIUWS013.GIUWPolDist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
			objUW.hidObjGIUWS013.GIUWPolDistClone = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
			objUW.hidObjGIUWS013.GIUWPolDistPostedRecreated = [];
			objUW.hidObjGIUWS013.selectedGIUWPolDist = {};
			objUW.hidObjGIUWS013.selectedGIUWWpolicyds = {};
			objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl = {};
			objUW.hidObjGIUWS013.distListing = {};
			objUW.hidObjGIUWS013.globalParId = null;
			objUW.hidObjGIUWS013.lineCd = null;
			objUW.hidObjGIUWS013.nbtLineCd = null;
			objUW.hidObjGIUWS013.sumDistSpct = 0;
			objUW.hidObjGIUWS013.sumDistTsi = 0;
			objUW.hidObjGIUWS013.sumDistPrem = 0;
			fireEvent($("dummyShowListing"), "click");
		}
	});
}