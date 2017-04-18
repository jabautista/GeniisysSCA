function refreshSpoilOrListing(){
	new Ajax.Updater("spoilORTable", contextPath + "/GIACSpoiledOrController", {
		method: "GET",
		evalScripts: true,
		parameters: {
			action: "refreshSpoiledOR2",
			branchCd: objACGlobal.branchCd,
			fundCd: objACGlobal.fundCd
		}
	});
}