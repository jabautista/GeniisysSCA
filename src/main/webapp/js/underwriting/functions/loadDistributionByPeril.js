function loadDistributionByPeril(){
	new Ajax.Request(contextPath + "/GIUWPolDistController?action=getGIUWPolDistForPerilDistribution", {
		method: "GET",
		parameters: {
			parId: objGIPIPolbasicPolDistV1.parId,
			distNo: objGIPIPolbasicPolDistV1.distNo
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			objUW.hidObjGIUWS012 = {};
			objUW.hidObjGIUWS012.GIUWPolDist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
			objUW.hidObjGIUWS012.GIUWPolDistPostedRecreated = [];
			objUW.hidObjGIUWS012.giuwPolDistPostQuerySw = "Y"; // bonok :: 12.10.2012
			fireEvent($("btnLoadRecords"), "click");
		}
	});
}