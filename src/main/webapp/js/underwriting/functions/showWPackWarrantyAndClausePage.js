/** Calls the Package Warranty And Clause Page
 *  Module/s : GIPIS024A and GIPIS035A
 *  @author Veronica V. Raymundo
 *  January 17, 2011
 */
function showWPackWarrantyAndClausePage(){
	try	{
		if(objUWGlobal.packParId == "" || objUWGlobal.packParId == 0){
			showMessageBox("Please select a policy.", imgMessage.ERROR);
			return;
		}
		if (objUWGlobal.parStatus < 3){
			showMessageBox("Warranties and Clauses menu is not yet accessible due to selected PAR status.", imgMessage.ERROR);
			return;
		}
		
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIPackWarrantyAndClausesController",{
			method: "POST",
			parameters: {action:	     "showPackWarrClaTableGrid",//"showPackClause" replace to: "showPackWarrClaTableGrid", replaced by: Steven 6.4.2012
						 globalPackParId: objUWGlobal.packParId,
						 globalParType:  objUWGlobal.parType,
						 globalParNo:    objUWGlobal.parNo,
						 globalAssdNo:   objUWGlobal.assdNo,
						 globalAssdName: objUWGlobal.assdName,
						 ajax: "1"},
			evalScripts: true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting Warranties and Clauses, please wait...");
			},
			onComplete: function () {
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001,
					afterFinish: function (){
					} 
				});
			}
		});
	} catch (e) {
		showErrorMessage("showWPackWarrantyAndClausePage", e);
		/*if("element is null" == e.message){
			showMessageBox("Some parameters needed to Package Policy - Warranties and Clauses page is missing.");
		} else {
			showMessageBox(e.message);
		}*/
	}
}