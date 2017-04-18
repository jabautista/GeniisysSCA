/**
 * Shows motor color lov Note: This is being used in quotation, policy issuance
 * and endt policy issuance
 * 
 * @author andrew
 * @date 05.18.2011
 */
function showColorLOV(basicColorCd) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getColorLOV",
				basicColorCd : basicColorCd,
				page : 1
			},
			title : "Color",
			width : 390,
			height : 320,
			columnModel : [ {
				id : "color",
				title : "Color",
				width : '350px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					onColorSelected(row);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showColorLOV", e);
	}
}