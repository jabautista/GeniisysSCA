/**
 * rmanalad 9/10/2012 GIPIS143 LOV /replace current dropdown LOV
 */
function showBillItemLOV(parId, onOkFunc) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getBillItemLOV",
				parId : parId
			},
			title : "",
			width : 360,
			height : 386,
			columnModel : [ {
				id : "itemNo",
				title : "Item No. ",
				width : '100px'
			}, {
				id : "itemTitle",
				title : "Item Title",
				width : '250px'
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
		showErrorMessage("showBillItemLOV", e);
	}
}