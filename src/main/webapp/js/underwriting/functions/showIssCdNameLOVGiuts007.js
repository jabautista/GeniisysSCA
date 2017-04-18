function showIssCdNameLOVGiuts007(lineCd, issCd, moduleId, userId, onOkFunc,
		onCancelFunc) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getIssCdLOVGiuts007",
			lineCd : lineCd,
			issCd : issCd,
			moduleId : moduleId,
			userId : userId,
			page : 1
		},
		title : "",
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
		showNotice: true,
		noticeMessage: "Getting list, please wait...",
		onSelect : onOkFunc,
		onCancel : onCancelFunc
	});
}