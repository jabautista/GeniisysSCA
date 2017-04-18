/**
 * Show LOV for PAR seq no.
 * 
 * @author rmanalad
 * @date 6/19/2012
 * @param lineCd
 * @param issCd
 * @param parYy
 * @param onOkFunc
 */
function showParSeqNoLOVList(lineCd, issCd, parYy, onOkFunc, onCancelFunc) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getParListLOV",
				lineCd : lineCd,
				issCd : issCd,
				parYy : parYy,
				page : 1
			},
			title : "",
			width : 420,
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
				id : "lineCd",
				title : "Line Cd",
				width : '95px',
				align : 'left',
				type : 'number'
			}, {
				id : 'issCd',
				title : 'Iss Cd',
				align : 'left',
				width : '95px'
			}, {
				id : 'parYy',
				title : 'PAR Yy',
				type : 'number',
				align : 'right',
				width : '95px',
			}, {
				id : 'parSeqNo',
				title : 'Par Seq No.',
				align : 'right',
				width : '95px'
			} ],
			draggable : true,
			showNotice: true,
			noticeMessage: "Getting list, please wait...",
			onSelect : onOkFunc,
			onCancel : onCancelFunc
		});
	} catch (e) {
		showErrorMessage("showParSeqNoLOVList", e);
	}
}