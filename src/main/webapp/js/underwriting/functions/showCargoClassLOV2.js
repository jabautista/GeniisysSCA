// shan 09.03.2013: for GIPIS901
function showCargoClassLOV2() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCargoClassLOV3"
			},
			title : "Cargo Class",
			width : 400,
			height : 300,
			columnModel : [ {
				id : "cargoClassCd",
				title : "Code",
				width : '100px'
			}, {
				id : "cargoClassDesc",
				title : "Cargo Class",
				width : '260px'
			} ],
			findText:	$F("txtCargoClassCd").trim(),
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				if (row != undefined) {
					$("txtCargoClassCd").value = row.cargoClassCd;
					$("txtCargoClassDesc").value = unescapeHTML2(row.cargoClassDesc);
				}
			},
			onCancel: function(){
				$("txtCargoClassCd").focus();
			}
		});
	} catch (e) {
		showErrorMessage("showCargoClassLOV2", e);
	}
}