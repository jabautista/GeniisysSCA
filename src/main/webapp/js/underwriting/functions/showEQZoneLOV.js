/*
 * Created by : mark jm 05.03.2011 Description : show LOV for EQ Zone Modified
 * by : Nica 04.14.2012 - added unescapeHTML2
 */
function showEQZoneLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getEQZoneLOV",
				page : 1
			},
			title : "EQ Zone",
			width : 700,
			height : 350,
			columnModel : [ {
				id : "eqZone",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "eqDesc",
				title : "Description",
				width : '700px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("eqZone").value = row.eqZone;
					$("eqZoneDesc").value = unescapeHTML2(row.eqDesc);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showEQZoneLOV", e);
	}
}