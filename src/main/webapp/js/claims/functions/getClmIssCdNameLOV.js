function getClmIssCdNameLOV(lineCd, id, findText) {
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getClmIssCdNameLOV",
				lineCd : lineCd,
				moduleId : objCLMGlobal.moduleId,
				page : 1,
				findText: findText
			},
			title : "Valid Values for Issuing Source Code",
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
				id : 'issCd',
				title : 'Iss',
				titleAlign : 'center',
				width : '100px'
			}, {
				id : 'issName',
				title : 'Iss Name',
				titleAlign : 'center',
				width : '231px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				if (row != undefined) {
						document.getElementById(id).value = unescapeHTML2(row.issCd);
						(id == "txtPolIssCd" ? $("txtNbtIssueYy").focus() : $("txtNbtClmYy").focus());
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
		showErrorMessage("getClmIssCdNameLOV", e);
	}
}