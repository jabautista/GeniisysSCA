function hideTextEditor() {
	try {
		Effect.Fade("textareaContentHolder", {
			duration: .001,
			afterFinish: function () {
				Effect.Fade("textareaOpaqueOverlay", {
					duration: .001
				});
			}
		});
	} catch (e) {
		showErrorMessage("hideTextEditor", e);
	}
}