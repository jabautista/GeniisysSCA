/**
 * 
 * @param Confirm Box Title
 * @param String message to be displayed
 * @param okLabel
 * @param cancelLabel
 * @param onOk function - note: don't include()
 * @param onCancel function - note: don't include()
 * @param defBtnNo
 */
function showConfirmBox3(title, message, okLabel, cancelLabel, onOkFunc, onCancelFunc, defBtnNo) {
	var width = 300;
	if (message.length > 35 && message.length <= 55) {
		width = 400;
	}else if (message.length > 55 && message.length <= 75) { //added by steven 1/16/2012
		width = 500;
	} else if (message.length > 75) {
		width = 600;
	}
	defBtnNo = (defBtnNo == undefined || defBtnNo == "" ? 1 : defBtnNo);
	Dialog.confirm("<div style='margin-top: 5px; float: left; width: 100%;'>" +
					"<span style='float: left; padding: 5px 8px 8px 8px; width: 10%; height: 40px;'>"+
					"<img src='"+contextPath+"/images/message/confirm.png'></span>" +
					"<label style='width: 80%; float: left; margin-top: 5px; line-height: 20px; font-family: Verdana; font-size: 11px;'>"+message+"</label>" +
				"</div>", {
		title: title,
		okLabel: okLabel,
		cancelLabel: cancelLabel,
		onOk: function(){
			Dialog.closeInfo(); //nok - 06.03.2010 para hindi maiwan ung confirm box if ajax asynchronous=false
			if (nvl(onOkFunc,"") == "") {
				return false;
			} else {
				onOkFunc();
			}
			return true;
		},
		onCancel: function() {
			if (nvl(onCancelFunc,"") == "") {
				return false;
			} else {
				Dialog.closeInfo(); //nok - 06.03.2010 para hindi maiwan ung confirm box if ajax asynchronous=false
				onCancelFunc();
				return true;
			}	
		},
		className: "alphacube",
		width: width,
		buttonClass: "button",
		closable: true,
		onShow:	function(){$("btn"+defBtnNo).focus();} // andrew - 111.17.2011 - to set focus on button after showing message
	});
}