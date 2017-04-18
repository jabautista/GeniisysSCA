/**
 * Shows LOV for Subline Code/Name
 * 
 * @author Niknok Orio
 * @date 09.26.2011
 */
function showSublineCdLOV(lineCd, moduleId) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getSublineByLineCdLOV",
				page : 1,
				lineCd : lineCd
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
			onSelect : function(row) {
				if (row != undefined) {
					if (moduleId == "GICLS010") {
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						objCLM.variables.checkObserveSublineCd = 1;
						$("txtSublineCd").focus();
						
						// irwin
						objClmBasicFuncs.polSublineCdOnBlur();
						fireEvent($("txtSublineCd"), "change"); //added by kenneth : 05262015 : SR 18829
					}
				}
			},
			onCancel : function() {
				if (moduleId == "GICLS010") {
					objCLM.variables.checkObserveSublineCd = 1;
					$("txtSublineCd").focus();
					$("txtSublineCd").clear();
				}
			},
			onUndefinedRow : function() {
				if (moduleId == "GICLS010") {
					$("txtSublineCd").clear();
					objCLM.variables.checkObserveSublineCd = 1;
					customShowMessageBox("No record selected.", "I",
							"txtSublineCd");
				}
			}
		});
	} catch (e) {
		showErrorMessage("showSublineCdLOV", e);
	}
}