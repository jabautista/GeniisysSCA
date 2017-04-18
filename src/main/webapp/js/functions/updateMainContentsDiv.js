// Update Main Contents Div - Used for listings
function updateMainContentsDiv(url, noticeMessage, appearCallback, callbackParams) {
	new Ajax.Updater("mainContents", contextPath+url, {
		asynchronous: true,
		evalScripts: true,
		onCreate: function () {
			/*Effect.Fade($("mainContents").down("div", 0), {
				duration: .2
			});*/
			showNotice(noticeMessage);
		},
		onComplete: function (response) {
			hideNotice();
			initializeAll();
			Effect.Appear($("mainContents").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					if (appearCallback != null) {
						appearCallback(callbackParams[0], callbackParams[1], callbackParams[2], callbackParams[3]);
						hideNotice();
					} else {
						hideNotice();
					}
				}
			});
		}
	});
}