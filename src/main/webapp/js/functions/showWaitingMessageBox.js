/* Created by mark jm 07.12.10
 * New version of showMessageBox
 * This messagebox waits for the user to press the Ok button
 * then execute the function onOkFunc
 */
function showWaitingMessageBox(message, mesType, onOkFunc) {
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
	
	var width = 300;
	if (message.stripScripts().stripTags().strip().length > 35 && message.stripScripts().stripTags().strip().length <= 55) {
		width = 400;
	}else if (message.stripScripts().stripTags().strip().length > 55 && message.stripScripts().stripTags().strip().length <= 75) { //added by steven 1/16/2012
		width = 500;
	} else if (message.stripScripts().stripTags().strip().length > 75) {
		width = 600;
	}
	if(showMBox== "N"){
		showMBox = "Y";
		showNoticeSw = "N";
		Dialog.alert("<div style='margin-top: 5px; float: left; width: 100%'>" +
					    "<span style='float: left; padding: 5px 8px 8px 8px; width: 10%; height: 40px;'>"+
				     	"<img src='"+contextPath+"/images/message/"+imgType+".png'></span>" +
				     	"<label style='width: 80%; float: left; margin-top: 5px; line-height: 20px; font-family: Verdana; font-size: 11px;'>"+message+"</label>" +
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

					if(onOkFunc){
						onOkFunc();
					}
					
					//added by Nok 02.08.2011 for logout with changes
					if (logOutOngoing == "Y"){
						if (changeTag == 0){
							changeTagFunc = "";
							showConfLogOut();
							logOutOngoing = "N"; 
						}
					}	
					//end Nok
				}
			},
			className: "alphacube", /*options: "",*/
			width: width,
			buttonClass: "button",
			onShow:	function(){$("btnMsgBoxOk").focus();} // andrew - 10.21.2011 - to set focus on button after showing message
	   	});
	}
}