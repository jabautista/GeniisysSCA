// show login page
function showLogin()	{
	//hideNotice("");
	Effect.Fade("dynamicDiv", {
		duration: .3,
		beforeFinish: function ()	{
			new Ajax.Updater("dynamicDiv", contextPath+"/pages/login.jsp", {
			 	evalScripts: true,
			 	asynchronous: true,
			 	onComplete:	function () {
			 		Effect.Appear("dynamicDiv", {
			 			duration: .3,
			 			afterFinish: function ()	{
			 				initializeAll();
			 				focusCursor("userId");
			 			}
			 		});
			 	}
			});
		}
	});

	if ($$(".dialog").size() > 0) {
		$$(".dialog").each(function (d) {
			d.hide();
		}); 
		$("overlay_modal").hide();
	}
}