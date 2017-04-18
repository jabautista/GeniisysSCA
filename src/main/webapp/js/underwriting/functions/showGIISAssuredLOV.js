/**
 * Shows assured list
 * 
 * @author andrew
 * @date 05.06.2011
 * 
 */
function showGIISAssuredLOV(action, onOkFunction) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : action,
				page : 1
			},
			title : "Assured",
			width : 500,
			height : 370,
			columnModel : [ {
				id : "assdNo",
				title : "Assured No",
				width : '50px'
			}, {
				id : "assdName",
				title : "Assured Name",
				width : '415px'
			} ],
			draggable : true,
			onSelect : onOkFunction
		});
	} catch (e) {
		showErrorMessage("showGIISAssuredLOV", e);
	}
}