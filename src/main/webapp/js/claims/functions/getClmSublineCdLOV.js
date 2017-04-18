//Claim/Policy SubLine Code LOV
function getClmSublineCdLOV(lineCd, id, findText) {
	try {
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getClmSublineCdLOV",
				page : 1,
				lineCd : lineCd,
				findText: findText
			},
			title : "Valid Values for Subline Code",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Code",
				width : '70px',
				type : 'number'
			}, {
				id : "sublineName",
				title : "Name",
				width : '320px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				if (row != undefined) {
						document.getElementById(id).value = unescapeHTML2(row.sublineCd);
						(id == "txtNbtSublineCd" ? $("txtNbtPolIssCd").focus() : $("txtNbtClmIssCd").focus());
				}
			},
			onCancel : function() {
					document.getElementById(id).focus();
					document.getElementById(id).clear();
					document.getElementById(id).enable();
			},
			onUndefinedRow : function() {
					document.getElementById(id).clear();
					customShowMessageBox("No record selected.", "I",
							id);
			}
		});
	} catch (e) {
		showErrorMessage("getClmSublineCdLOV", e);
	}
}