// mark jm 01.05.10 ItemInfo Screen ends here
function showPARCreation(){
	new Ajax.Updater("mainContents", "pages/underwriting/parCreation.jsp",{
		method: "POST",
		asynchronous: true,
		evalScripts: true
	});
}