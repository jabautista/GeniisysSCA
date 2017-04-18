//by bonok :: GIUTS008A :: 06.13.2012
function showCopyPackagePolicy(){
	new Ajax.Updater("mainContents",contextPath+"/GIUTSCopyPackagePolicyController?action=showCopyPackagePolicy",{
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Loading, please wait...");
		},
		onComplete: function() {
			hideNotice("");
		}
	});
}