function enableMenus(param){
	new Ajax.Request(contextPath + "/GICLClaimsController?action=enableMenus", {
		method: "GET",
		parameters: {
			claimId: objCLMGlobal.claimId,
			param: param
		},
		asynchronous: false,
		evalScripts: true,
		onComplete: function (response){
			if (checkErrorOnResponse(response)) {
				hideNotice();
				setMenuProperty(JSON.parse(response.responseText.replace(/\\/g, '\\\\')));
			}
		}
	});
}