/**
 * Shows the attachment dialog
 * @author andrew robes
 * @date 03.9.2012
 * 
 */
function showAttachmentList(){
	try{
		overlayAttachmentList = Overlay.show(contextPath+"/GIPIPictureController", {
			urlContent: true,
			urlParameters: {action : "showAttachmentList",
							policyId : $F("hidPolicyId"),
							itemNo : $F("txtItemNo"),
							ajax : "1"},
		    title: "Attachments",
		    height: 350,
		    width: 620,
		    draggable: true,
		    showNotice: true
		});
	}catch(e){
		showErrorMessage("showAttachmentList", e);
	}
}