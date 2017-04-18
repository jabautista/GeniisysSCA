// show notice message in pop-ups
// parameter: the message to show
function showNoticeInPopup(message) {
	$("noticePopup").update(message);
	Effect.Appear("noticePopup", {
		duration: .001,
		afterFinish: function () {
			/*Effect.Fade("noticePopup", {
				duration: 5
			});*/
		}
	});
}