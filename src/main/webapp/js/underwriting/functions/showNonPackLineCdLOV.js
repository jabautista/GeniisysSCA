/**
 * Shows user accessible non package lines
 * @param issCd
 * @param moduleId
 * @param onOkFunc
 */
function showNonPackLineCdLOV(issCd, moduleId, onOkFunc) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getAllNonPackLineLOV",
				page : 1,
				issCd : issCd,
				moduleId : moduleId
			},
			title : "Valid Values for Line Code",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Code",
				width : '70px',
				type : 'number'
			}, {
				id : "lineName",
				title : "Name",
				width : '318px'
			}, {
				id : "menuLineCd",
				title : '',
				width : '0px',
				visible : false
			} ],
			draggable : true,
			onSelect : onOkFunc
		});
	} catch (e) {
		showErrorMessage("showNonPackLineCdLOV", e);
	}
}