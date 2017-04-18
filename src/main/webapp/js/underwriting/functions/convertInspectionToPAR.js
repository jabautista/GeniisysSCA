/**
 * Converts a Fire Inspection report to a PAR
 * @param insp - object that contains the inspection details to be converted
 * @author Veronica V. Raymundo
 */
function convertInspectionToPAR(insp){
	try{
		new Ajax.Request(contextPath+"/GIPIInspectionReportController", {
			evalScripts:	true,
			asynchronous:	true,
			parameters: {
				action : "convertInspectionToPAR",
				parId  : $F("globalParId"),
				inspNo : nvl(insp.inspNo, 0)
			},
			onCreate : function(){
				showNotice("Converting Fire Quotation to PAR...");
			},
			onComplete : function(response){
				copyAttachments(insp); // SR-21674 JET DEC-13-2016
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showBasicInfo);
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("convertInspectionToPAR", e);
	}
}

function copyAttachments(insp) {
	new Ajax.Request(contextPath + "/GIPIInspectionReportController", {
		method: "POST",
		parameters: {
			action: "copyAttachments",
			lineCd: $F("globalLineCd"),
			parId: $F("globalParId"),
			parNo: $F("globalParNo").replace(/\s/g, ''),
			inspNo: insp.inspNo
		}
	});
}