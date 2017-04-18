//modified by: nica 10.01.10
function saveEndtPar(){
	new Ajax.Updater("uwParParametersDiv", contextPath+"/GIPIPARListController?action=saveEndtPar",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		postBody: Form.serialize("createEndtParForm"),
		onCreate: function(){
			//showNotice("Saving Endorsement PAR, please wait...");
			$("createEndtParForm").disable();
		},
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				getEndtParSeqNo();
				$("createEndtParForm").enable();
				$("endtLineCd").disable();
				$("endtIssueSource").disable();
				$("year").readOnly = true;
				$("remarks").enable();
				objUWGlobal.lineCd = $F("vlineCd"); // andrew - 05.17.2011 - added this line to set the lineCd to global parameter
				objUWGlobal.menuLineCd = $("vlineCd").getAttribute("menuLineCd"); // andrew - 05.17.2011 - added this line to get the menu line code upon creation
				initializePARBasicMenu($F("parType"), $F("vlineCd"));
				showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
				$("createEndtParForm").disable();
			}
			//hideNotice("SAVING SUCCESSFUL.");
			//Effect.Appear("endtParInformationDiv", {duration: .001});
		}
	});
}