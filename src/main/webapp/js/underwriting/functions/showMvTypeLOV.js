function showMvTypeLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCgRefCodeLOV",
				domain : "GIPI_VEHICLE.MV_TYPE",
				page : 1
			},
			title : "MV Type",
			width : 450,
			height : 300,
			columnModel : [ {
				id : "rvLowValue",
				title : "Type",
				width : '75px'
			}, {
				id : "rvMeaning",
				title : "Description",
				width : '340px'
			} ],
			draggable : true,
			onSelect : function(row) {
				$("mvType").value = unescapeHTML2(row.rvLowValue);
				$("mvTypeDesc").value = unescapeHTML2(row.rvMeaning);
				$("mvPremType").value = "";
				$("mvPremTypeDesc").value = "";
				changeTag = 1;
			}
		});
	} catch (e) {
		showErrorMessage("showMvTypeLOV", e);
	}
}