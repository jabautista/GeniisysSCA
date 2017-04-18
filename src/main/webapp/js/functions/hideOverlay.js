// hide the overlay
function hideOverlay() {
	if (1 == newUserTag) {
		showMessageBox("You must set your own password now.", imgMessage.INFO);
		$("newPassword").focus();
		return false;
	} else {
		Effect.Fade("contentHolder", {
			duration: .001,
			afterFinish: function () {
				$("contentHolder").setAttribute("src", ""); // andrew - 11.3.2010 - added this line to remove the src value when hiding the overlay.
				Effect.Fade("opaqueOverlay", {
					duration: .001
				});
			}
	});
	}
}