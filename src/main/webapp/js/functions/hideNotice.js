// hide notice in the main page
// parameter: the message to replace the existing content while fading out
function hideNotice(message)	{
	document.getElementById("noticeOverlay").style.display = "none";
	$$("div[name='notice']").invoke("hide");	
	// andrew - 02.21.2013 - let us hide the notice directly to avoid progress bar notices that are lingering in the module pages 
	
	/*if (!(Object.isUndefined(message)) && message.include("occur")) {
		$$("div[name='notice']").invoke("hide");
		showMessageBox(message);
	} else {
		if (message != "" && message != undefined)	{
			$("noticeMessage").update(message);
			$$("div[name='notice']").invoke("hide");
		} else {
			$$("div[name='notice']").invoke("hide");
		}
	}
	Effect.Fade("notice", {
		duration: .00001
	});
	
	setTimeout(function(){
		if (document.getElementById("notice").style.display == "block" || document.getElementById("noticeOverlay").style.display == "block"){
			hideNotice();
		}
	}, 200);*/
}