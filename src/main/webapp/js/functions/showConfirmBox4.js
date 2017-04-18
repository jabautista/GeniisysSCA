/*
 * Created By	: andrew
 * Date			: November 2, 2010
 * Description	: Shows a confirmation message with three buttons to choose from (Yes, No, Cancel).
 * Parameters	: title - title of the confirmation window
 * 				  message - confirmation message
 * 				  btn1Label - label for button 1
 * 				  btn2Label - label for button 2
 * 				  btn3Label - label for button 3
 * 				  btn1Func - function call back for button 1
 *				  btn2Func - function call back for button 2
 *				  btn3Func - function call back for button 3
 */
function showConfirmBox4(title, message, btn1Label, btn2Label, btn3Label, btn1Func, btn2Func, btn3Func, defBtnNo) {
	var width = 300;
	var lblsLength = (btn1Label.length+ btn2Label.length+ btn3Label.length) > 30; // added to handle long lables - irwin
	if (message.length > 35 && message.length <= 55) {
		width = 400;
	}else if (message.length > 55 && message.length <= 75) { //added by steven 1/16/2012
		width = 500;
	} else if (message.length > 75) {
		width = 600;
	}
	
	if(lblsLength){
		width = 500;
	}
	defBtnNo = (defBtnNo == undefined || defBtnNo == "" ? 1 : defBtnNo);
	Dialog.confirm("<div style='margin-top: 5px; float: left; width: 100%;'>" +
						"<span style='float: left; padding: 5px 8px 8px 8px; width: 10%; height: 40px;'>"+
					   "<img src='"+contextPath+"/images/message/confirm.png'></span>" +
					   "<label style='width: 80%; float: left; margin-top: 5px; line-height: 20px; font-family: Verdana; font-size: 11px;'>"+message+"</label>" +
				   "</div>", {
		title: title,
		button1Label: btn1Label,
		button2Label: btn2Label,
		button3Label: btn3Label,
		button1Callback: function(){
			if (nvl(btn1Func,"") == "") {
				return false;
			} else {
				Dialog.closeInfo(); 
				btn1Func();
				return true;
			}
		},
		button2Callback: function() {
			if (nvl(btn2Func,"") == "") {
				return false;
			} else {
				Dialog.closeInfo();
				btn2Func();
				return true;
			}	
		},
		button3Callback: function() {
			if (nvl(btn3Func,"") == "") {
				return false;
			} else {
				Dialog.closeInfo();
				btn3Func();
				return true;
			}
		},
		className: "alphacube",
		width: width,
		buttonCount: 3,
		draggable: true,
		onShow:	function(){$("btn"+defBtnNo).focus();} // andrew - 111.17.2011 - to set focus on button after showing message
	});
}