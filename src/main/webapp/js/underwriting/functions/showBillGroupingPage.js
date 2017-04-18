//nica 10.15.2010 for bill grouping page
function showBillGroupingPage(){
	try {
		/*if (($F("globalParId").blank()) || ($F("globalParId")== "0")) { // comment out by andrew - 10.04.2011
			showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
			return;
		} else {*/
		new Ajax.Request(contextPath+"/GIPIWItemPerilController?", { // andrew - 08.31.2012 - validation for items without peril/s
			method: "GET",
			parameters: {
				parId: objUWParList.parId,
				packParId: objUWGlobal.packParId,
				action: "checkPerilOnAllItems"
			},
			evalScripts:true,
			asynchronous: true,
			onComplete: function (response) {
				if(response.responseText != "SUCCESS") {
					showScrollingMessageBox(response.responseText, "info", 
							function() {
								showItemInfoTG();
							});
				} else {
					var parId   = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
					var lineCd  = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
					var issCd   = (objUWGlobal.packParId != null ? objUWGlobal.issCd : $F("globalIssCd"));
					var parType = (objUWGlobal.packParId != null ? objUWGlobal.parType : $F("globalParType"));
					var policyNo= (objUWGlobal.packParId != null ? "" : $F("globalEndtPolicyNo"));
					var container = (objUWGlobal.packParId != null ? "packParBillGroupingDiv" : "parInfoDiv");
					new Ajax.Updater(container, contextPath+"/GIPIParBillGroupingController",{
							parameters:{
								parId: parId,
								lineCd: lineCd,
								issCd: issCd,
								parType: parType,
								policyNo: policyNo,
								action: "showBillGrouping",
								isPack : (objUWGlobal.packParId != null ? "Y" : "N")
								},
							asynchronous: true,
							evalScripts: true,
							onComplete: function (response)	{
								Effect.Appear($(container).down("div", 0), { 
									duration: .001,
									afterFinish: function () {
										if ($("message").innerHTML == "SUCCESS"){
											updateParParameters();
										} else {
											showMessageBox($("message").innerHTML, imgMessage.ERROR);
											//$("basicInformationForm").disable();
											//$("basicInformationFormButton").disable();
										}
									}
								});
								setDocumentTitle("Group Item Per Bill");
								addStyleToInputs();
								initializeAll();
							}	
					});
				}
			}
		});
		//}
	} catch (e){
		showErrorMessage("showBillGroupingPage", e);
	}
}