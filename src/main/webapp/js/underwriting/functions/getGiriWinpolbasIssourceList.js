function getGiriWinpolbasIssourceList(moduleId) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGiriWinpolbasIssourceList",
			page : 1
		},
		title : "List of Reinsurers",
		width : 300,
		height : 350,
		columnModel : [ {
			id : "issCd",
			title : "Issue Code",
			width : '80'
		}, {
			id : "issName",
			title : "Issue Name",
			width : '180px'
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				if (moduleId == "GIRIS005A" || moduleId == "GIRIS005") {
					$("riSName2").value = unescapeHTML2(nvl(row.issName));
					$("riSName2").writeAttribute("riCd", row.issCd);
				}
			}
		}
	});
}