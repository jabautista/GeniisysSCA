function showClaimInformationListing(lineCd, lineName){
	new Ajax.Request(contextPath + "/GICLClaimsController?action=getClaimInformationTableGrid", {
		method: "GET",
		parameters: {
			ajax: 1,
			lineCd: lineCd,
			lineName: lineName
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}else{
				showMessageBox(response.responseText, "E");
			}
		}
	});
}