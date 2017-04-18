function showGiisEndtTextLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getEndtTextLOV"
			},
			title : "Endorsement Text",
			width : 617,
			height : 386,
			columnModel : [ {
				id : "endtCd",
				title : "Endt Cd",
				width : '100px'
			}, {
				id : "endtTitle",
				title : "Endt Title",
				width : '180px'
			}, {
				id : "endtText",
				title : "Endt Text",
				width : '320px',
				renderer : function(value) {
					return value.replace(/\\n/g, "\n");
				}
			} ],
			draggable : true,
			onSelect : function(row) {
				$("endtInformation").value = (unescapeHTML2(row.endtText)
						.replace(/\\n/g, "\n"));
			}
		});
	} catch (e) {
		showErrorMessage("showGiisEndtTextLOV", e);
	}
}