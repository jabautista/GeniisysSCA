// hide notice message in popups
// parameter: the mesage replace the existing content while fading out
function hideNoticeInPopup(message) {
	if (message != "")	{
		$("noticePopup").update(message);
	}
	Effect.Fade("noticePopup", {
		duration: .001
	});
}