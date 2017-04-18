/**
 * Shows Reinsurer lov in GIRIS001 - Create RI Placement
 * 
 * @author Nok
 * @date 07.01.2011
 */
function showReinsurerLOV2(notIn, tableGrid) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getReinsurerLOV2",
				notIn : notIn,
				page : 1
			},
			title : "List of Reinsurers",
			width : 660,
			height : 386,
			columnModel : [ {
				id : "riSname",
				title : "RI Short Name",
				width : '290px'
			}, {
				id : "riName",
				title : "RI Long Name",
				width : '290px'
			}, {
				id : "riCd",
				title : "Code",
				width : '57px'
			}, {
				id : "billAddress1",
				title : "",
				width : '0px',
				visible : false
			}, {
				id : "billAddress2",
				title : "",
				width : '0px',
				visible : false
			}, {
				id : "billAddress3",
				title : "",
				width : '0px',
				visible : false
			} ],
			draggable : true,
			onSelect : function(row) {
				/*
				 * Re-designed
				 * tableGrid.setValueAt(row.riSname,tableGrid.getIndexOf('riSname'),
				 * objUW.hidObjGIRIS001.selIndex, true);
				 * tableGrid.setValueAt(row.riName,tableGrid.getIndexOf('riName'),
				 * objUW.hidObjGIRIS001.selIndex, true);
				 * tableGrid.setValueAt(row.riCd,tableGrid.getIndexOf('riCd'),
				 * objUW.hidObjGIRIS001.selIndex, true);
				 * tableGrid.setValueAt(row.billAddress1,tableGrid.getIndexOf('address1'),
				 * objUW.hidObjGIRIS001.selIndex, true);
				 * tableGrid.setValueAt(row.billAddress2,tableGrid.getIndexOf('address2'),
				 * objUW.hidObjGIRIS001.selIndex, true);
				 * tableGrid.setValueAt(row.billAddress3,tableGrid.getIndexOf('address3'),
				 * objUW.hidObjGIRIS001.selIndex, true);
				 */
				if (nvl(objUW.newObjGIRIS001, null) == null) {
					objUW.newObjGIRIS001 = {};
				}
				objUW.newObjGIRIS001.riSname = row.riSname;
				objUW.newObjGIRIS001.riName = row.riName;
				objUW.newObjGIRIS001.riCd = row.riCd;
				objUW.newObjGIRIS001.billAddress1 = row.billAddress1;
				objUW.newObjGIRIS001.billAddress2 = row.billAddress2;
				objUW.newObjGIRIS001.billAddress3 = row.billAddress3;
				$("txtDspRiSname").value = unescapeHTML2(row.riSname);
			},
			prePager : function() {
				tbgLOV.request.notIn = notIn;
			}
		});
	} catch (e) {
		showErrorMessage("showReinsurerLOV2", e);
	}
}