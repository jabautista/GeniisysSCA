//go to a module main page
function goToModule(url, title, callback)	{
	Effect.Fade("dynamicDiv", {
		duration: .001,
		beforeFinish: function ()	{
			new Ajax.Updater("dynamicDiv", contextPath+url, {
				evalScripts: true,
				asynhronous: true,
				//onCreate: showNotice("Loading "+title+", please wait...", "440px"),
				onComplete: function ()	{
					hideNotice();
					setDocumentTitle(title);
					Effect.Appear("dynamicDiv", {
						duration: .001,
						afterFinish: function () {initializeMenu();}
					});
					callback();
				}
			});
		}
	});
}