// simple hides the editor for textareas
// whofeih - 07.02.2010
function hideEditor(textId) {
	try {
		Effect.ScrollTo(textId, {duration: .001});
		Effect.Fade("textareaContentHolder", {
			duration: .001,
			afterFinish: function () {
				Effect.Fade("textareaOpaqueOverlay", {
					duration: .001
				});
				$(textId).focus();			//added by d.alcantara
				$(textId).setSelectionRange(0, 0); // Added by J. Diago - Para mapunta yung cursor sa unahan ng textarea. 09.09.2013
			}
		});
	} catch (e) {
		showErrorMessage("hideEditor", e);
	}
}