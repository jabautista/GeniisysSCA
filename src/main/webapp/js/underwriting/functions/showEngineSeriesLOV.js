/*
 * Date Author Description ========== ===============
 * ============================== 09.01.2011 mark jm lov for engine series
 */
function showEngineSeriesLOV(sublineCd, carCompanyCd, makeCd) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getEngineSeriesLOV",
				sublineCd : sublineCd,
				carCompanyCd : carCompanyCd,
				makeCd : makeCd,
				page : 1
			},
			title : "Engine Series",
			width : 400,
			height : 300,
			columnModel : [ {
				id : "seriesCd",
				title : "Series Cd",
				width : '100px'
			}, {
				id : "engineSeries",
				title : "Engine Series",
				width : '260px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("carCompanyCd").value = row.carCompanyCd;
					$("carCompany").value = unescapeHTML2(row.carCompany);
					$("makeCd").value = row.makeCd;
					$("make").value = unescapeHTML2(row.make);
					$("seriesCd").value = row.seriesCd;
					$("engineSeries").value = unescapeHTML2(row.engineSeries);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showEngineSeriesLOV", e);
	}
}