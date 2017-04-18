function showIssCdNameLOV2(lineCd, moduleId, onOkFunc) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getIssCdNameLOV",
			lineCd : lineCd,
			moduleId : moduleId,
			page : 1
		},
		title : "Valid Values for Issuing Source Code",
		width : 360,
		height : 386,
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false,
			editor : 'checkbox'
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : 'issCd',
			title : 'Issue Code',
			titleAlign : 'center',
			width : '100px'
		}, {
			id : 'issName',
			title : 'Issue Name',
			titleAlign : 'center',
			width : '231px'
		} ],
		draggable : true,
		onSelect : onOkFunc
	});
}