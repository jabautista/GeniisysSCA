/**
 * Shows motor basic color lov Note: This is being used in quotation, policy
 * issuance and endt policy issuance
 * 
 * @author andrew
 * @date 05.18.2011
 */
function showBasicColorLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getBasicColorLOV",
				page : 1
			},
			title : "Basic Color",
			width : 390,
			height : 320,
			columnModel : [ {
				id : "basicColor",
				title : "Basic Color",
				width : '350px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					onBasicColorSelected(row);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showBasicColorLOV", e);
	}
}