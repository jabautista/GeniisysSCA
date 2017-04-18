/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.21.2011	mark jm			show upload enrollee page
 */
function showUploadEnrolleesOverlay2(parId,itemNo,uploadEnrolleesSaved){
	try{
		overlayUploadEnrollees = Overlay.show(contextPath + "/OverlayController", {
			title : "Upload Enrollees",
			urlContent : true,
			urlParameters : {
				action : "showUploadEnrollees",
				parId : parId,
				itemNo : itemNo,
				uploadEnrolleesSaved : uploadEnrolleesSaved,
				page : 1
			},
			width : 720,
			height : 500,
			draggable : true
		});
		
	}catch(e){
		showErrorMessage("showUploadEnrolleesOverlay2", e);
	}
	/*
	if (uploadEnrolleesSaved == "U" || uploadEnrolleesSaved == "UY"){
		document.getElementById("contentHolder").writeAttribute("src", "");
		uploadEnrolleesSaved = uploadEnrolleesSaved=="U"?"":"Y";
	}
	showOverlayContent2(contextPath+"/OverlayController?action=showUploadEnrollees&ajax=1&parId="+parId+"&itemNo="+itemNo+"&uploadEnrolleesSaved="+uploadEnrolleesSaved,
			"Upload Enrollees", 600, 
			showUploadEnrolleesMainPage, 9010);	
	*/
}