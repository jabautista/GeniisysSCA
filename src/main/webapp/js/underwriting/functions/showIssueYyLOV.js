/**
 * Shows LOV for Issue Year
 * 
 * @author Niknok Orio
 * @date 09.26.2011
 */
function showIssueYyLOV(lineCd, sublineCd, issCd, moduleId) {
	var action = (moduleId == "GIUTS009") ? "getPolbasicIssueYyLOV" : "getIssueYyLOV"; //  added by: Nica 05.21.2013
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : action, //"getIssueYyLOV",
			lineCd : lineCd,
			sublineCd : sublineCd,
			issCd : issCd,
			page : 1
		},
		title : "Valid Values for Issue Year",
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
			id : 'issueYy',
			title : 'Issue Year',
			titleAlign : 'right',
			align : 'right',
			width : '200px'
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				if (moduleId == "GICLS010") {
					$("txtIssueYy").value = parseInt(row.issueYy)
							.toPaddedString(2);
					$("txtIssueYy").focus();
					objClmBasicFuncs.polSeqNoOnBlur();
				} else if(moduleId == "GIUTS009") {
					$("txtIssueYy").value = parseInt(row.issueYy).toPaddedString(2);
					$("txtParYy").value = parseInt(row.issueYy).toPaddedString(2);
					$("txtPolSeqNo").value = "";
					$("txtRenewNo").value = "";
				} else if (moduleId == "GIUTS008") {
					$("txtIssueYy").value = parseInt(row.issueYy)
							.toPaddedString(2);
					fireEvent($("txtIssueYy"), "change"); //"blur");
					// $("txtIssueYy").blur();
					/*
					 * $("txtNbtParYy").value =
					 * parseInt(row.issueYy).toPaddedString(2);
					 * $("txtNbtParYy").setAttribute("readOnly","readOnly");
					 */
					// checkUserPerIssCd();
				}
			}
		},
		onCancel : function() {
			if (moduleId == "GICLS010") {
				$("txtIssueYy").focus();
				$("txtIssueYy").clear();
			}
		}
	});
}