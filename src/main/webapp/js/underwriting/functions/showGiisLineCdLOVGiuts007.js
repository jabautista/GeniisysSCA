function showGiisLineCdLOVGiuts007(lineCd, issCd, moduleId, userId, onOkFunc,
		onCancelFunc) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getLineCdLOVGiuts007",
				lineCd : lineCd,
				issCd : issCd,
				moduleId : moduleId,
				userId : userId,
				page : 1
			},
			title : "",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Code",
				width : '80px'
			}, {
				id : "lineName",
				title : "Line Name",
				width : '310px'
			} ],
			draggable : true,
			showNotice: true,
			noticeMessage: "Getting list, please wait...",
			onSelect : onOkFunc,
			onCancel : onCancelFunc
		});
	} catch (e) {
		showErrorMessage("showGiisLineCdLOVGiuts007", e);
	}
}