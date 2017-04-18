// created by d.alcantara, 06-14-2012
function showSummarizePolicy() {
	new Ajax.Updater("mainContents", contextPath+"/CopyUtilitiesController",{
		parameters: {
			action: "showSummarizePoltoPar"
		},
		asynchronous: false,
		evalScripts: true,
		onComplete : function() {
			hideNotice("");
			Effect.Appear("mainContents", {
				duration : .001
			});
		}
	});
}