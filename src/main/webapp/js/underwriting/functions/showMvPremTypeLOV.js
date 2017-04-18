function showMvPremTypeLOV(mvTypeCd) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getMvPremTypeLOV",
				mvTypeCd : mvTypeCd
			},
			title : "MV Prem Type",
			width : 450,
			height : 300,
			columnModel : [ {
				id : "mvPremTypeCd",
				title : "Type",
				width : '80px'
			}, {
				id : "mvPremTypeDesc",
				title : "Description",
				width : '350px'
			} ],
			draggable : true,
			onSelect : function(row) {
				$("mvPremType").value = unescapeHTML2(row.mvPremTypeCd);
				$("mvPremTypeDesc").value = unescapeHTML2(row.mvPremTypeDesc);
				changeTag = 1;
			}
		});
	} catch (e) {
		showErrorMessage("showMvPremTypeLOV", e);
	}
}