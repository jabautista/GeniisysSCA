// nica 10.21.2010
function showExistingGroupsOverlay(){
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")); // andrew - 10.05.2011 - added condition for pack par
	new Ajax.Request(contextPath+"/GIPIParBillGroupingController",{
		parameters:{
			action: "showExistingGroupsOverlay",
			parId: parId
		},
		asynchronous: false,
		evalScripts: true
	});
}