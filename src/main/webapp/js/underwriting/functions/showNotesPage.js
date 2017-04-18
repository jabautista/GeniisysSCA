/**
 * Description - show the notes.jsp,contains
 * 				 a list of notes policies
 * created by  - Fons
 */

function showNotesPage(){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv";
	new Ajax.Updater(div, contextPath+"/GIPIReminderController?action=showGipis208&dateOpt=dateCreated&dateAsOf="+getCurrentDate()+"&parId="+nvl(objUWGlobal.parId,""),{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Notes page, please wait..."),
		onComplete: function () {
			hideNotice();
			setDocumentTitle("Notes");
		}
	});

}