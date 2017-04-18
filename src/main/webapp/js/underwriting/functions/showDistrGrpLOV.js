/**
 * Show the join groups overlay for GIUWS010
 * @param id - id of the overlay
 * @param title - title of the overlay
 * @param objArray - objArray that contains the group nos.
 * @param width - width of the overlay
 * @param tableGrid - tableGrid to which values will be assigned.
 * 
 */

function showDistrGrpLOV(id, title, objArray, width, tableGrid){
	try{
		if (nvl(objArray.length,0) <= 0){
			showMessageBox("There are no available groups to choose from. Please try choosing a different set of records.", imgMessage.ERROR);
			return false;
		}
		if (($("contentHolder").readAttribute("src") != id)) {
			initializeOverlayLov(id, title, width);
			setOverlayLOV(id, objArray, width);
			function onOk(){
				try{
					var group = unescapeHTML2(getSelectedRowAttrValue(id+"LovRow", "val"));
					if (group == ""){showMessageBox("Please select any group first.", imgMessage.ERROR); return;};
					joinDistrGroups_2(tableGrid, group);
					hideOverlay();
				}catch(e){
					showErrorMessage("showDistrGrpLOV - onOk", e);
				}
			}
			observeOverlayLovRow(id);
			observeOverlayLovButton(id, onOk);
			observeOverlayLovFilter(id, objArray);
		}
		$("filterTextLOV").focus();
	}catch(e){
		showErrorMessage("showDistrGrpLOV", e);
	}
}