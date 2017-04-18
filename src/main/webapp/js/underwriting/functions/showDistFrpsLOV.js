/**
 * @author d.alcantara
 * @date 06.24.2011
 */
function showDistFrpsLOV(action, moduleId, saveFunc) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : action,
			moduleId : moduleId,
			notIn : "",
			page : 1
		},
		title : "List of FRPS",
		width : 595,
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
			id : 'frpsNo',
			title : 'FRPS No.',
			titleAlign : 'center',
			width : '100px'

		}, {
			id : 'parNo',
			title : 'PAR No.',
			width : '140px',
			titleAlign : 'center'

		}, {
			id : 'parType',
			title : '&#160;&#160;P',
			width : '22px',
			titleAlign : 'center',
			align : 'center',
			sortable : false
		}, {
			id : 'policyNo',
			title : 'Policy No.',
			titleAlign : 'center',
			width : '160px'
		}, {
			id : 'endtNo',
			title : 'Endorsement No.',
			titleAlign : 'center',
			width : '130px'
		}, {
			id : 'premAmt',
			width : '0',
			visible : false
		}, {
			id : 'tsiAmt',
			width : '0',
			visible : false
		}, {
			id : 'currDesc',
			width : '0',
			visible : false
		}, {
			id : 'totFacTsi',
			width : '0',
			visible : false
		}, {
			id : 'totFacPrem',
			width : '0',
			visible : false
		}, {
			id : 'renewNo',
			width : '0',
			visible : false
		}, {
			id : 'sublineCd',
			width : '0',
			visible : false
		}, {
			id : 'polSeqNo',
			width : '0',
			visible : false
		}, {
			id : 'issueYy',
			width : '0',
			visible : false
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				if (changeTag == 1 && moduleId == "GIRIS002") {
					showConfirmBox4("Confirm",
							"Do you want to save the changes you have made?",
							"Yes", "No", "Cancel", function() {
								saveFunc();
								setRiFromDistFrpsLOV(row, moduleId);
							}, function() {
								setRiFromDistFrpsLOV(row, moduleId);
							}, null, null);
				} else {
					setRiFromDistFrpsLOV(row, moduleId);
				}
			}
		}
	});
}