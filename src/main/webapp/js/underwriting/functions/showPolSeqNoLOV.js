/**
 * Shows LOV for Policy Sequence No.
 * 
 * @author Niknok Orio
 * @date 09.26.2011
 */
function showPolSeqNoLOV(lineCd, sublineCd, issCd, issueYy, moduleId) {
	var action = (moduleId == "GIUTS009") ? "getPolbasicPolSeqNoLOV" : "getPolSeqNoLOV"; //  added by: Nica 05.21.2013
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : action, //"getPolSeqNoLOV",
			lineCd : lineCd,
			sublineCd : sublineCd,
			issCd : issCd,
			issueYy : issueYy,
			page : 1
		},
		title : "Valid Values for Policy Sequence No.",
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
			id : 'polSeqNo',
			title : 'Sequence No.',
			titleAlign : 'right',
			align : 'right',
			width : '200px'
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				if (moduleId == "GICLS010") {
					$("txtPolSeqNo").value = parseInt(row.polSeqNo)
							.toPaddedString(7);
					$("txtPolSeqNo").focus();
					
					objClmBasicFuncs.polSeqNoOnBlur();
				} else if (moduleId == "GIUTS009") {
					$("txtPolSeqNo").value = parseInt(row.polSeqNo)
					.toPaddedString(7);
					fireEvent($("txtPolSeqNo"), "change");
				} else if (moduleId == "GIUTS008") {
					$("txtPolSeqNo").value = parseInt(row.polSeqNo)
							.toPaddedString(7);
					fireEvent($("txtPolSeqNo"), "change"); //"blur");
					/*
					 * $("txtNbtParSeqNo").value =
					 * parseInt(row.polSeqNo).toPaddedString(7);
					 * $("txtNbtParSeqNo").setAttribute("readOnly","readOnly");
					 */

				}
			}
		},
		onCancel : function() {
			if (moduleId == "GICLS010") {
				$("txtPolSeqNo").focus();
				$("txtPolSeqNo").clear();
			}
		}
	});
}