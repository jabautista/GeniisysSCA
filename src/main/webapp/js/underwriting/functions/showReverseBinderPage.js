/**
 * Shows  Reverse and Replace Binder page
 * Module: GIUTS004 -  Reverse and Replace Binder
 * @author Robert Virrey 
 * @since 08.09.2011
 */
function showReverseBinderPage(loadFromUWMenu) {
	clearParParameters();
	new Ajax.Updater("mainContents", contextPath+"/GIRIFrpsRiController?action=showReverseBinderTableGrid"/*contextPath+"/GIRIFrpsRiController?action=showReverseBinderPage"replace by: Nica 10.09.2012*/, {
		method: "GET",
		parameters: {
			    moduleId: "GIUTS004",
			    loadFromUWMenu : nvl(loadFromUWMenu, null) == null ? "Y" : loadFromUWMenu,
				lineCd : objRiFrps.lineCd,
				frpsYy : objRiFrps.frpsYy,
				frpsSeqNo : objRiFrps.frpsSeqNo
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function ()	{
			showNotice("Loading Reverse Binder, please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUTS004");
			setDocumentTitle("Reverse Binder With Replacement");
		}
	});
}