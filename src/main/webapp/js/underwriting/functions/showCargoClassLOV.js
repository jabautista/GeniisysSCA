/*
 * Date Author Description ========== ===============
 * ============================== 09.20.2011 mark jm lov for marine cargo class
 */
function showCargoClassLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCargoClassLOV",
				page : 1
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
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("cargoClassCd").value = row.cargoClassCd;
					$("cargoClass").value = unescapeHTML2(row.cargoClassDesc);
					$("cargoType").value = "";
					$("cargoTypeDesc").value = "";
				}
			}
		});
	} catch (e) {
		showErrorMessage("showCargoClassLOV", e);
	}
}