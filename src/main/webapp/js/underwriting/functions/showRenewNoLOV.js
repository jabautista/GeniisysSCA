/**
 * Shows LOV for Renew No.
 * 
 * @author Niknok Orio
 * @date 09.26.2011
 */
function showRenewNoLOV(lineCd, sublineCd, issCd, issueYy, polSeqNo, moduleId) {
	var action = (moduleId == "GIUTS009") ? "getPolbasicRenewNoLOV" : "getRenewNoLOV"; //  added by: Nica 05.21.2013
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : action, //"getRenewNoLOV",
			lineCd : lineCd,
			sublineCd : sublineCd,
			issCd : issCd,
			issueYy : issueYy,
			polSeqNo : polSeqNo,
			page : 1
		},
		title : "Valid Values for Renew No.",
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
			id : 'renewNo',
			title : 'Renew No.',
			titleAlign : 'right',
			align : 'right',
			width : '200px'
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				if (moduleId == "GICLS010") {
					$("txtRenewNo").value = parseInt(row.renewNo)
							.toPaddedString(2);
					$("txtRenewNo").focus();
					objClmBasicFuncs.polRenewNoOnBlur();
				} else if ( moduleId == "GIUTS009") {
					$("txtRenewNo").value = parseInt(row.renewNo).toPaddedString(2);
					$("txtRenewNo").focus();
					objUWGlobal.hideObjGIUTS009.checkIfPolicyExists("txtRenewNo");
				} else if (moduleId == "GIUTS008") {
					$("txtRenewNo").value = parseInt(row.renewNo).toPaddedString(2);
					fireEvent($("txtRenewNo"), "change"); //"blur");
					/*
					 * $("txtNbtQuoteSeqNo").value =
					 * parseInt(row.renewNo).toPaddedString(2);
					 * $("txtNbtQuoteSeqNo").setAttribute("readOnly","readOnly");
					 * $("txtRenewNo").focus();
					 */
				}
			}
		},
		onCancel : function() {
			if (moduleId == "GICLS010") {
				$("txtRenewNo").focus();
				$("txtRenewNo").clear();
			}
		}
	});
}