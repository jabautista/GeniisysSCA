// mrobes 01.04.10 shows WPolicy - Warranties and Clauses page
function showWPolicyWarrantyAndClausePage(){
	try	{
		if($F("globalParId").blank() || $F("globalParId") == 0){
			showMessageBox("Please select a policy.", imgMessage.ERROR);
			return;
		}
		updateParParameters();
		if ($F("globalParStatus") < 3){
			showMessageBox("Warranties and Clauses menu is not yet accessible due to selected PAR status.", imgMessage.ERROR);
			return;
		}
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWPolicyWarrantyAndClauseController",{
			method: "GET",
			parameters: {action:	     "showWPolWarrAndClausePageTableGrid", //"showPCPage", replaced by: Nica 11.22.2011  "showWPolWarrAndClausePage", replaced by: Steven 4.26.2012  
						 ajax: "1",
						 globalParType:  $F("globalParType"),
						 globalParId:    $F("globalParId"),
						 globalLineCd:   $F("globalLineCd"),
						 globalParNo:    $F("globalParNo"),
						 globalAssdNo:   $F("globalAssdNo"),
						 globalAssdName: $F("globalAssdName")},
			evalScripts: true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting warranties and clauses, please wait...");
			},
			onComplete: function () {
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001
					/*afterFinish: function (){
						loadWPolicyWarrantyAndClausesByPage(1);
					}*/ //commented by: Nica 11.22.2011
				});
			}
		});
	} catch (e) {
		showErrorMessage("showWPolicyWarrantyAndClausePage", e);
		/*if("element is null" == e.message){
			showMessageBox("Some parameters needed to Policy - Warranties and Clauses page is missing.");
		} else {
			showMessageBox(e.message);
		}*/
	}
}