// show the notice in the main page
// parameter: the message to show
function showNotice(message){
	if(showNoticeSw == "Y"){
		document.getElementById("noticeOverlay").style.display = "block";
		$("notice").setStyle("display: block;");
		$("noticeLoadingImg").show();
		/*if (message.include("...") || message.include("wait")) {
			$("noticeLoadingImg").show();		
		} else {
			$("noticeLoadingImg").hide();
		}*/
		$("noticeMessage").update(message);
/*		Effect.Appear("notice", {
			//duration: .00001
		});*/
	} 
}