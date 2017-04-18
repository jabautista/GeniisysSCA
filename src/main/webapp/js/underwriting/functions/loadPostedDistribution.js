function loadPostedDistribution(){
	new Ajax.Request(contextPath + "/GIUWPolDistController?action=loadPostedDistGIUTS002JSON", {
		method: "GET",
		parameters: {
			parId: objGIPIPolbasicPolDistV1.parId,
			policyId: objGIPIPolbasicPolDistV1.policyId,
			distNo: objGIPIPolbasicPolDistV1.distNo
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			objUW.hidObjGIUTS002 = {};
			objUW.hidObjGIUTS002.GIUWPolDist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
			objUW.hidObjGIUTS002.GIUWPolDistPostedRecreated = [];
			objUW.hidObjGIUTS002.selectedGIUWPolDist = {};
			objUW.hidObjGIUTS002.selectedGIUWWpolicyds = {};
			objUW.hidObjGIUTS002.selectedGIUWWpolicydsDtl = {};
			objUW.hidObjGIUTS002.distListing = {};
			objUW.hidObjGIUTS002.globalParId = null;
			objUW.hidObjGIUTS002.lineCd = null;
			objUW.hidObjGIUTS002.nbtLineCd = null;
			objUW.hidObjGIUTS002.sumDistSpct = 0;
			objUW.hidObjGIUTS002.sumDistTsi = 0;
			objUW.hidObjGIUTS002.sumDistPrem = 0;
			resetDivs();
			fireEvent($("dummyShowListing"), "click");
		}
	});
}