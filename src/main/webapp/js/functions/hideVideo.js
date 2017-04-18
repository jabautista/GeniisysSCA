// hdie video overlay
function hideVideo() {
	$("closer").hide();
	Effect.Fade("videoHolder", {
		duration: .001,
		afterFinish: function () {
			//Modalbox.resizeToContent(); commented by: nica 05.12.2011
		}
	});
}