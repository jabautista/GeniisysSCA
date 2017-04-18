//Claim/Policy Line Code LOV
function getClmLineCdLOV(issCd, id, findText) {
	try {
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getClmLineCdLOV",
				page : 1,
				issCd : issCd,
				moduleId : objCLMGlobal.moduleId,
				findText : findText
			},
			title : "Valid Values for Line Code",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Code",
				width : '70px',
				type : 'number'
			}, {
				id : "lineName",
				title : "Name",
				width : '318px'
			}, {
				id : "menuLineCd",
				title : '',
				width : '0px',
				visible : false
			} ],
			draggable: true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				if (row != undefined) {
					document.getElementById(id).value = unescapeHTML2(row.lineCd);
					enableToolbarButton("btnToolbarEnterQuery");
					(id == "txtNbtLineCd" ? $("txtNbtSublineCd").focus() : $("txtNbtClmSublineCd").focus());
				}
			},
			onCancel : function() {
					document.getElementById(id).focus();
					document.getElementById(id).clear();
			},
			onUndefinedRow : function() {
					document.getElementById(id).clear();
					customShowMessageBox("No record selected.", "I",
							id);
			}
		});
	} catch (e) {
		showErrorMessage("getClmLineCdLOV", e);
	}
}