/*
 * Created by : mark jm 05.03.2011 Description : show LOV for Typhoon Zone
 * Modified by : Nica 04.14.2012 - added unescapeHTML2
 */
function showFloodZoneLOV() {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getFloodZoneLOV",
						page : 1
					},
					title : "Flood Zone",
					width : 700,
					height : 350,
					columnModel : [ {
						id : "floodZone",
						title : "",
						width : '0',
						visible : false
					}, {
						id : "floodZoneDesc",
						title : "Description",
						width : '700px'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("floodZone").value = row.floodZone;
							$("floodZoneDesc").value = unescapeHTML2(row.floodZoneDesc);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showFloodZoneLOV", e);
	}
}