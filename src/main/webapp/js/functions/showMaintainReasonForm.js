/*
 * Create by 	:D. Alcantara 09.24.2010
 * Description	: calls the maintainReason page
 */
function showMaintainReasonForm() {
	Effect.Fade("contentsDiv", {
		duration: .001,
		beforeFinish: function() {
			Effect.Appear("assuredDiv", {duration: .001});
			new Ajax.Updater("assuredDiv", contextPath + "/GIISLostBidController?action=showReasonMaintenance", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				onCreate : showNotice("Getting reasons, please wait..."),
				onComplete : function() {
					hideNotice("");
					Effect.Appear("maintainReasonMainDiv", {
						duration : .001
					});
				}
			});
			hideNotice("");
		}
	});
/*	new Ajax.Updater("contentsDiv", contextPath + "/GIISLostBidController?action=showReasonMaintenance", {
		method: "POST",
		asynchronous: true,
		evalScripts: true,
		onCreate : showNotice("Getting reasons, please wait..."),
		onComplete : function() {
			hideNotice("");
			Effect.Appear("maintainReasonMainDiv", {
				duration : .001
			});
		}
	});	*/
}