/**
 * rmanalad 9/10/2012 GIPIS143 LOV /replace current dropdown LOV
 */
function showBillItemPerilLOV(parId, lineCd, itemNo, onOkFunc) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getBillItemPerilLOV",
				parId : parId,
				lineCd : lineCd,
				itemNo : itemNo
			},
			title : "",
			width : 360,
			height : 386,
			columnModel : [ {
				id : "perilName",
				title : "Peril Name",
				width : '250px'
			}, {
				id : "perilCd",
				title : "Peril Code",
				width : '100px'
			}, {
				id : "itemNo",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "perilType",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "tsiAmt",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "premAmt",
				title : "",
				width : '0',
				visible : false
			} ],
			draggable : true,
			onSelect : onOkFunc
		});
	} catch (e) {
		showErrorMessage("showBillItemPerilLOV", e);
	}
}