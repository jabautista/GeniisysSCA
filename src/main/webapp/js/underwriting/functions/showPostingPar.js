//jerome 03.23.10 for posting of PAR
function showPostingPar(){
	var action = "";
	var parId = objUWParList.parId;
	if (nvl(objUWGlobal.packParId,null) == null){
		action = "getPostPar";
		title = "Post Par";
		updateParParameters();
		if (nvl(objUWParList.parId,null) == null || objUWParList.parId == "0") {
			showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
			return;
		} 
	}else{
		action = "getPostPackPar";
		title = "Post Package Par";
		if(nvl(objUWGlobal.packParId,null) == null){ // andrew - 07.18.2011
			updatePackParParameters();
			parId = objUWParList.packParId;
		} else {
			parId = objUWGlobal.packParId;
			objUWParList.packParId = parId;
		}
		
		//if (nvl(objUWParList.packParId,null) == null || objUWParList.packParId == "0") { // andrew - 07.18.2011 - modified the condition
		if (nvl(parId,null) == null || parId == "0") {
			showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
			return;
		} 
	}	
	
	if (objUWParList.parType == "P" && objUWParList.parStatus < 6){ // andrew - 04.30.2011 - added partype condition
		showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
		return;
	}
	
	overlayPost = Overlay.show(contextPath+"/OverlayController", { // andrew - 07.15.2011
						urlContent: true,
						urlParameters: {action : action,
										parId : parId,
										ajax : "1"},
					    title: title,
					    height: 165,
					    width: 542,
					    draggable: true
					});
	/*showOverlayContent2(contextPath+"/OverlayController?action="+action+"&ajax=1&parId="+parId, title,
					540, showPostingParMainPage);*/
}