function showCoInsurerPage() {
	if (($F("globalParId").blank()) || ($F("globalParId")== "0")) {
		showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
		return;
	} else {
		var parId   = $F("globalParId");
		var lineCd  = $F("globalLineCd");
		var parType = $F("globalParType");
		
		new Ajax.Request(contextPath+"/GIPICoInsurerController", {
			method: "GET",
			parameters: {
				action: "limitEntry",
				parId: parId,
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					var result = response.responseText;
					if(result == "GIPIS026") {
						showWaitingMessageBox("Please enter your BILL PREMIUM information for this PAR.", 
								imgMessage.INFO, showBillPremium);
					} else if(result == "GIPIS085") {
						showWaitingMessageBox("Please enter your COMMISSION INVOICE information for this PAR.", 
								imgMessage.INFO, showInvoiceCommissionPage);
					} else {
						new Ajax.Updater("parInfoDiv", contextPath+"/GIPICoInsurerController",{
							parameters:{
								parId: parId,
								lineCd: lineCd,
								parType: parType,
								action: "showCoInsurerDetails"
								},
							asynchronous: false,
							evalScripts: true,
							onCreate: showNotice("Getting co-insurer information, please wait..."),
							onComplete: function (response)	{
								hideNotice("");
								Effect.Appear($("parInfoDiv").down("div", 0), { 
									duration: .001,
									afterFinish: function () {
										updateParParameters();
									}
								});
								setDocumentTitle("Enter Co-Insurer");
								addStyleToInputs();
								initializeAll();
							}	
						});
					}
				}
			}
		});
	}
}