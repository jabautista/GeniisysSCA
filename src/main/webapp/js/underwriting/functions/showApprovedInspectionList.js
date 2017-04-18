function showApprovedInspectionList(parId, assdNo) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getApprovedInspectionList",
				parId : parId,
				assdNo : assdNo
			},
			title : "Inspection List",
			width : 900,
			height : 400,
			columnModel : [ {
				id : "itemNo",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "inspNo",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "assdName",
				title : "Assured Name",
				width : '200px'
			}, {
				id : "inspName",
				title : "Inspector Name",
				width : '200px'
			}, {
				id : "itemTitle",
				title : "Item Title",
				width : '200px'
			}, {
				id : "itemDesc",
				title : "Item Description",
				width : '200px'
			}, {
				id : "province",
				title : "Province",
				width : '150px'
			}, {
				id : "city",
				title : "City",
				width : '150px'
			}, {
				id : "districtDesc",
				title : "District",
				width : '150px'
			}, {
				id : "blockDesc",
				title : "Block",
				width : '150px'
			}, {
				id : "locRisk1",
				title : "Loc Risk 1",
				width : '150px'
			}, {
				id : "locRisk2",
				title : "Loc Risk 2",
				width : '150px'
			}, {
				id : "locRisk3",
				title : "Loc Risk 3",
				width : '150px'
			}, {
				id : "provinceCd",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "blockNo",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "districtNo",
				title : "",
				width : '0',
				visible : false
			}, ],
			draggable : true,
			onSelect : function(row) {
				convertInspectionToPAR(row);
			}
		});
	} catch (e) {
		showErrorMessage("showApprovedInspectionList", e);
	}
}