// jerome orio 02.26.2010 bill Discount/Surcharge
function showDiscountSurcharge() {
	try {
		if (($F("globalParId").blank()) || ($F("globalParId")== "0")) {
			showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
			return;
		/*} else if ($F("globalParStatus") < 5){
			showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);*/
		} else if ($F("globalPolFlag") == 4){
			showMessageBox("You are not allowed to enter discounts for policy that is cancelled.", imgMessage.ERROR);	
		} else {
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
						var parId = $F("globalParId");
						var lineCd = $F("globalLineCd");
						var issCd = $F("globalIssCd");
						new Ajax.Updater("parInfoDiv", contextPath+"/GIPIParDiscountController",{
								parameters:{
									parId: parId,
									lineCd: lineCd,
									issCd: issCd,
									action: "showBillDiscount"
									},
								asynchronous: true,
								evalScripts: true,
								onCreate: function ()	{
									showNotice("Getting Discount/Surcharge, please wait...");
								},
								onComplete: function (response)	{
									hideNotice("");
									Effect.Appear($("parInfoDiv").down("div", 0), { // "billDiscountMainDiv"
										duration: .001,
										afterFinish: function () {
											if ($("message").innerHTML == "SUCCESS"){
												updateParParameters();
											} else {
												showMessageBox($("message").innerHTML, imgMessage.ERROR);
												$("basicInformationForm").disable();
												$("basicInformationFormButton").disable();
											}
										}
									});
									setDocumentTitle("Discounts/Surcharge Information");
									addStyleToInputs();
									initializeAll();
								}	
						});	
					}
				}
			});
		}	
	} catch (e){
		showErrorMessage("showDiscountSurcharge", e);
	}
}