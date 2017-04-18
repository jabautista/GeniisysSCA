/**
 * Shows occupancy lov
 * 
 * @author andrew
 * @date 04.25.2011
 */
function showOccupancyLOV(onOkFunc) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIISFireOccupancyLOV",
			page : 1
		},
		title : "Occupancy",
		width : 460,
		height : 300,
		columnModel : [ {
			id : "occupancyCd",
			title : "Code",
			width : '0',
			visible : false
		}, {
			id : "occupancyDesc",
			title : "Risk",
			width : '420px'
		} ],
		draggable : true,
		onSelect : function(row) {
			$("occupancyCd").value = row.occupancyCd;
			$("occupancy").value = unescapeHTML2(row.occupancyDesc);

			if (onOkFunc != null && onOkFunc != undefined) {
				onOkFunc();
			}
		}
	});
}