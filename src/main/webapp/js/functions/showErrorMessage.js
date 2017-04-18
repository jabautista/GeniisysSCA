/**
 * @author Andrew Robes
 * @date February 22, 2011
 * @param functionName - name of function where the error occured.
 *  	  error - catched error
 */
function showErrorMessage(functionName, error){
	hideNotice();
	var message; /*= "An error occured.<br/><br/>"
				+"Occured at: "+functionName+"<br/>"
				+"Error Description: "+error.message;		*/
			
	new Ajax.Request(contextPath+"/JavascriptErrorLogger", {
		method: "POST",
		parameters: {functionName : functionName,
					 description : error.message},
		onComplete: function(response){
			showErrorMessageAfterComplete(response.responseText);
		}
	});
	
	function showErrorMessageAfterComplete(message){
		var width = 300;
		var length = message.stripScripts().stripTags().strip().length; 
		if (length > 20 && length < 45 || functionName.length > 20 && functionName.length < 45) {
			width = 400;
		} else if (length > 45 && length < 70 || functionName.length > 45 && functionName.length < 70) {
			width = 500;
		} else if (length > 70 || functionName.length > 70){
			width = 600;
		}
		
		if(showMBox== "N"){
			showMBox = 'Y';
			showNoticeSw = "N";
			Dialog.alert("<div style='margin-top: 5px;'>" +
							"<div style='margin: 10px;'>" +
							    "<span style='float: left; margin: 2px 5px 10px 2px; width: 10%;'>"+
						     	"<img src='"+contextPath+"/images/message/error.png'></span>" +
						     	"<label style='width: 80%; margin-left: 5px; line-height: 20px; font-family: Verdana; font-size: 11px;'>"+message+"</label>" +
					     	"</div>" +
					     "</div>", {
				title: "GENIISYS",
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
						if (logOutOngoing == "Y"){
							if (changeTag == 0){
								changeTagFunc = "";
								showConfLogOut();
								logOutOngoing = "N"; 
							}
						}	
					}
				},
				className: "alphacube", /*options: "",*/
				width: width,
				buttonClass: "button",
				draggable: true,
				onShow:	function(){$("btnMsgBoxOk").focus();} // andrew - 10.21.2011 - to set focus on button after showing message
		   	});		
		}
	}
}