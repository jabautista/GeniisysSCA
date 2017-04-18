/**
 * Show Other Branch OR
 * 
 * @author D. Alcantara 01.25.2011
 */
function showBranchOR(branchOROP) {
	// branchOROP == 1, generate OR
	// branchOROP == 2, enter manual OR
	// branchOROP == 3, cancel OR
	var otherBranchAccess = "GENERATE";
	if (branchOROP == 1)
		otherBranchAccess = "GENERATE";
	if (branchOROP == 2)
		otherBranchAccess = "MANUAL";
	if (branchOROP == 3)
		otherBranchAccess = "CANCEL";

	objACGlobal.tranSource = "OR";
	objACGlobal.opReqTag = "N";
	objACGlobal.opTag = null;
	if (branchOROP == 1) {
		objACGlobal.orTag = "S";
		objACGlobal.orCancellation = "N";
	} else if (branchOROP == 2) {
		objACGlobal.orTag = "M";
		objACGlobal.orCancellation = "N";
	} else if (branchOROP == 3) {
		objACGlobal.orTag = "C";
		objACGlobal.orCancellation = "Y";
	} else if (branchOROP == "APDC") {
		objACGlobal.orTag = "X";
		objACGlobal.orCancellation = "X";
	}
	new Ajax.Updater("mainContents", contextPath
			+ "/GIACOtherBranchORController?action=showBranchOR", {
		parameters : {
			page : 1,
			tranSource : objACGlobal.tranSource,
			opReqTag : objACGlobal.opReqTag,
			orTag : objACGlobal.orTag,
			opTag : objACGlobal.opTag,
			orCancellation : objACGlobal.orCancellation,
			otherBranchAccess : otherBranchAccess,
			moduleId : "GIACS156" //pol cruz, 10.16.2013 (required for check user access)
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Branch OR page. Please wait... </br>"
					+ contextPath);
		},
		onComplete : function(response) {
			hideNotice("");
			if (checkErrorOnResponse(response)) {
				hideAccountingMainMenus();
				$("acExit").show(); // added by andrew - 02.18.2011
			}
		}
	});
}