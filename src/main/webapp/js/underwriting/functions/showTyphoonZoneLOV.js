/*
 * Created by : mark jm 05.03.2011 Description : show LOV for Typhoon Zone
 * Modified by : Nica 04.14.2012 - added unescapeHTML2
 */

function showTyphoonZoneLOV() {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getTyphoonZoneLOV",
						page : 1
					},
					title : "Typhoon Zone",
					width : 700,
					height : 350,
					columnModel : [ {
						id : "typhoonZone",
						title : "",
						width : '0',
						visible : false
					}, {
						id : "typhoonZoneDesc",
						title : "Description",
						width : '700px'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("typhoonZone").value = row.typhoonZone;
							$("typhoonZoneDesc").value = unescapeHTML2(row.typhoonZoneDesc);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showTyphoonZoneLOV", e);
	}
}