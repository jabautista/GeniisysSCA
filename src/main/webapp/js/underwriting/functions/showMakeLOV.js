/*
 * Date Author Description ========== ===============
 * ============================== 09.01.2011 mark jm lov for make
 */
function showMakeLOV(sublineCd, carCompanyCd) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getMakeLOV",
				sublineCd : sublineCd,
				carCompanyCd : carCompanyCd,
				page : 1
			},
			title : "Make",
			width : 400,
			height : 300,
			columnModel : [ {
				id : "makeCd",
				title : "Make Cd",
				width : '100px'
			}, {
				id : "make",
				title : "Make",
				width : '260px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("carCompanyCd").value = row.carCompanyCd;
					$("carCompany").value = unescapeHTML2(row.carCompany);
					$("makeCd").value = row.makeCd;
					$("make").value = unescapeHTML2(row.make);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showMakeLOV", e);
	}
}