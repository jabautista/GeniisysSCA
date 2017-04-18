//for testing
function showScrollingMessageBox(message, mesType, onOkFunc) {
	var width = 500;

	hideNotice();
	var mesType = getIcon(mesType);
	mesType = mesType == null || mesType == "" ? "info" : mesType;
	var imgType = imgMessage.INFO;
	var titleMessage = "Information Message";
	if (mesType == imgMessage.ERROR) {
		imgType = imgMessage.ERROR;
		titleMessage = "Error Message";
	} else if (mesType == imgMessage.WARNING) {
		imgType = imgMessage.WARNING; 
		titleMessage = "Warning Message";
	} else if (mesType == imgMessage.SUCCESS) {
		imgType = imgMessage.SUCCESS;
		titleMessage = "Success Message";
	}
	
	if(showMBox== "N"){
		showMBox = "Y";
		showNoticeSw = "N";
		Dialog.alert("<div style='margin-top: 5px; float: left; width: 100%; height: 80px;'>" +
			     "<span style='float: left; padding: 5px 8px 8px 8px; width: 10%; height: 35px;'>"+
	     	     "<img src='"+contextPath+"/images/message/"+imgType+".png'></span>" +
			     "<textarea readonly='readonly' style='width: 82%; float: left; margin-left: 12px; margin-top: 5px; border: none; resize: none; font-family: Verdana; font-size: 11px; height: 95%;'>"+message+"</textarea>" +
			     "</div>", {
			title: titleMessage,
			okLabel: "Ok",
			onOk: function () {
				showMBox = "N";
				showNoticeSw = "Y";
				if (message.include("Your session has expired.")) {
					showLogin();
					Dialog.closeInfo();
				} else {
					$$("div[name='notice']").invoke("hide");
					Dialog.closeInfo();
					onOkFunc();
					if (logOutOngoing == "Y"){
						if (changeTag == 0){
							changeTagFunc = "";
							showConfLogOut();
							logOutOngoing = "N"; 
						}
					}	
				}
			},
			className: "alphacube", 
			width: width,
			buttonClass: "button",
			onShow:	function(){$("btnMsgBoxOk").focus();} 
	   	});
	}
}