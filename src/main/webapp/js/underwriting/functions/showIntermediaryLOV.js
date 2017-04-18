function showIntermediaryLOV(controller, action, onOkFunction) {
	LOV.show({
		controller : controller,
		urlParameters : {
			action : action,
			page : 1
		},
		title : "Intermediary",
		width : 380,
		height : 386,
		columnModel : [ {
			id : 'intmNo',
			title : 'Intermediary No.',
			titleAlign : 'right',
			align : 'right',
			width : '100px'
		}, {
			id : 'intmName',
			title : 'Intermediary Name',
			titleAlign : 'left',
			width : '261px'
		} ],
		draggable : true,
		onSelect : onOkFunction
	});
}