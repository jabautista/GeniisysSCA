/*
 * Created by : mark jm 08.01.2011 Description : lov for peril tariff codes
 */
function showTariffByPeril(lineCd, perilCd) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPerilTariffLOV",
				lineCd : lineCd,
				perilCd : perilCd,
				page : 1
			},
			title : "Tariffs",
			width : 660,
			height : 320,
			columnModel : [ {
				id : "tariffCd",
				title : "Code",
				width : '220px'
			}, {
				id : "tariffDesc",
				title : "Description",
				width : '300px'
			}, {
				id : "tariffRate",
				title : "Rate",
				width : '90px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("perilTarfCd").value = row.tariffCd;
					$("txtPerilTarfDesc").value = row.tariffCd;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showTariffByPeril", e);
	}
}