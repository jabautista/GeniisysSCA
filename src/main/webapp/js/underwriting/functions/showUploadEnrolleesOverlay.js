//jerome for Accident Enrollee Upload overlay
function showUploadEnrolleesOverlay(parId,itemNo,uploadEnrolleesSaved){
	if (uploadEnrolleesSaved == "U" || uploadEnrolleesSaved == "UY"){
		document.getElementById("contentHolder").writeAttribute("src", "");
		uploadEnrolleesSaved = uploadEnrolleesSaved=="U"?"":"Y";
	}
	showOverlayContent(contextPath+"/OverlayController?action=getUploadEnrollees&ajax=1&parId="+parId+"&itemNo="+itemNo+"&uploadEnrolleesSaved="+uploadEnrolleesSaved,
			"Upload Enrollees",
			showUploadEnrolleesMainPage, (screen.width)/8, 20,380);	
}