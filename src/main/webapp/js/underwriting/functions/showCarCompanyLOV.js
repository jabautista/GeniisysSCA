/*
 * Date Author Description ========== ===============
 * ============================== 09.01.2011 mark jm lov for car company
 */
function showCarCompanyLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCarCompanyLOV",
				page : 1
			},
			title : "Car Company",
			width : 400,
			height : 300,
			columnModel : [ {
				id : "carCompanyCd",
				title : "Car Company Cd",
				width : '100px'
			}, {
				id : "carCompany",
				title : "Car Company",
				width : '260px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("carCompanyCd").value = row.carCompanyCd;
					$("carCompany").value = unescapeHTML2(row.carCompany);
					$("makeCd").value = "";
					$("make").value = "";
					$("seriesCd").value = "";
					$("engineSeries").value = "";
				}
			}
		});
	} catch (e) {
		showErrorMessage("showCarCompanyLOV", e);
	}
}