/**
 * Shows province lov
 * 
 * @author andrew
 * @date 04.20.2011
 */
function showProvinceLOV() {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIISProvinceLOV",
			regionCd : $F("region"),
			page : 1
		},
		title : "Province",
		width : 458,
		height : 350,
		columnModel : [ {
			id : "provinceCd",
			title : "Code",
			width : '0',
			visible : false
		}, {
			id : "provinceDesc",
			title : "Province",
			width : '420px'
		} ],
		draggable : true,
		onSelect : function(row) {
			selectProvince(row);
		}
	});
}