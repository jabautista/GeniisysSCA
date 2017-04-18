/**
 * Shows LOV for Issue Code/Source
 * 
 * @author Niknok Orio
 * @date 09.26.2011
 */
function showIssCdNameLOV(lineCd, moduleId) {
	LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getIssCdNameLOV",
					lineCd : lineCd,
					moduleId : moduleId,
					page : 1
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
					title : 'Issue Code',
					titleAlign : 'center',
					width : '100px'
				}, {
					id : 'issName',
					title : 'Issue Name',
					titleAlign : 'center',
					width : '231px'
				} ],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						if (moduleId == "GICLS010") {
							$("txtPolIssCd").value = row.issCd;
							objCLM.variables.checkObserveIssCd = 1;
							$("txtPolIssCd").focus();
						}
					}
				},
				onCancel : function() {
					if (moduleId == "GICLS010") {
						objCLM.variables.checkObserveIssCd = 1;
						$("txtPolIssCd").focus();
						$("txtPolIssCd").clear();
					}
				},
				onUndefinedRow : function() {
					if (moduleId == "GICLS010") {
						$("txtPolIssCd").clear();
						objCLM.variables.checkObserveIssCd = 1;
						customShowMessageBox("No record selected.", "I",
								"txtPolIssCd");
					}
					//irwin
					objClmBasicFuncs.polIssCdOnBlur();
				}
			});
}