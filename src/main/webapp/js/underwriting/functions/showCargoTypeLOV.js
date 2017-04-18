/*
 * Date Author Description ========== ===============
 * ============================== 09.21.2011 mark jm lov for marine cargo type
 */
function showCargoTypeLOV(cargoClassCd) {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getCargoTypeLOV",
						cargoClassCd : cargoClassCd,
						page : 1
					},
					title : "List of Cargo Type",
					width : 400,
					height : 300,
					columnModel : [ {
						id : "cargoType",
						title : "Cargo Type",
						width : '100px'
					}, {
						id : "cargoTypeDesc",
						title : "Description",
						width : '260px'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("cargoType").value = row.cargoType;
							$("cargoTypeDesc").value = unescapeHTML2(row.cargoTypeDesc);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showCargoTypeLOV", e);
	}
}