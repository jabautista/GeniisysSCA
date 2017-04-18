/**
 * Shows LOV for Line Code/Name
 * 
 * @author Niknok Orio
 * @date 09.26.2011
 */
function showLineCdLOV(issCd, moduleId) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getAllLineLOV",
				page : 1,
				issCd : issCd,
				moduleId : moduleId
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
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					if (moduleId == "GICLS010") {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						objCLM.variables.checkObserveLineCd = 1;
						$("txtLineCd").focus();
						
						//irwin
						objClmBasicFuncs.polLineCdOnBlur();
					}
				}
			},
			onCancel : function() {
				if (moduleId == "GICLS010") {
					objCLM.variables.checkObserveLineCd = 1;
					$("txtLineCd").focus();
					$("txtLineCd").clear();
				}
			},
			onUndefinedRow : function() {
				if (moduleId == "GICLS010") {
					$("txtLineCd").clear();
					objCLM.variables.checkObserveLineCd = 1;
					customShowMessageBox("No record selected.", "I",
							"txtLineCd");
				}
			}
		});
	} catch (e) {
		showErrorMessage("showLineCdLOV", e);
	}
}