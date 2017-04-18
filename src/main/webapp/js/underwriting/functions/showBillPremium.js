//start-cris
// Modified by Tonio Nov 8, 2010 - added condition for Bond (SU) line code
// Tonio May 5, 2011 - Added condition for PAR type handling
//shows the Bill premium page 
function showBillPremium(){
	//var parStatus = objUWGlobal.parStatus == null ? $F("globalParStatus") : objUWGlobal.parStatus;
/*	if (parseFloat(parStatus) < 5){
		showMessageBox("This menu is not yet accessible due to selected PAR status.", imgMessage.ERROR);
		return;
	}*/
	var parId;
	var lineCd;
	var issCd;
	var action;
	try{		
		parId = objUWParList.parId;//$F("globalParId");objUWParList
		//packParId = objUWParList.packParId;//$F("globalPackParId"); 
		packParId = objUWGlobal.packParId;//$F("globalPackParId"); // andrew - 07.08.2011 - 
		lineCd = objUWParList.lineCd;//$F("globalLineCd");
		issCd = objUWParList.issCd;//$F("globalIssCd");
	} catch (e) {
		showErrorMessage("showBillPremium", e);
	}
	//added by tonio nov 9 2010
		if (lineCd == "SU" || objUWGlobal.menuLineCd == "SU"){
			if ($F("globalParType") == 'P'){
				action = "enterBondBill";
			}else{
				action = "endtEnterBondBill";
			}
			new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWinvoiceController?action=" + action , { 
					method: "GET",
					parameters: {
						parId: $F("globalParId"),
						parNo: $F("globalParNo"),
						assdName: escapeHTML2($F("globalAssdName")),
						lineCd: $F("globalLineCd"),
						sublineCd: $F("globalSublineCd"),
						issCd: $F("globalIssCd"),
						inceptDate: $F("globalInceptDate").substring(0,10),
						//issueDate: $F("globalEffDate").substring(0,10), 
						//issueDate: objGIPIWPolbas.issueDate.substring(0,10), // bonok :: 8.10.2015 :: SR 20091
						issueDate : objUWGlobal.formattedIssueDate, // apollo cruz 09.11.2015 sr#19975
						issueYY: $F("globalIssueYy"),
						polSeqNo: $F("globalPolSeqNo"),
						renewNo: $F("globalRenewNo")
			        },
					asynchronous: false,
					evalScripts: true,
					onCreate: function () {
			        	showNotice("Loading, please wait...");
			        },
			        onComplete: function () {
			        	hideNotice("");
			        }
			 });	
		}else {
			setModuleId("GIPIS026");
			
			new Ajax.Request(contextPath+"/GIPIWItemPerilController?", {
				method: "GET",
				parameters: {
					parId: parId,
					packParId: packParId,
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
						var initialParId = $("initialParId") != undefined ? $F("initialParId"): "";
						new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWinvoiceController?",{ //+Form.serialize("uwParParametersForm"),{
								method: "GET",
								parameters:{
									parId: parId, //$F("globalParId"),
									lineCd: lineCd,//$F("globalLineCd"),
									issCd: issCd, //$F("globalIssCd"),
									packParId: packParId,
									initialParSelected: initialParId,
									action: "showBillPremiumsPage"
								},
								evalScripts:true,
								asynchronous: true,
								onCreate: showNotice("Getting bill premiums, please wait..."),
								onComplete: function (response) {
									parId = $F("initialParId") != undefined ?  $F("initialParId") : parId;
									// updateParParameters(); // andrew - 05.27.2011 - comment out muna
									new Ajax.Updater("taxInformationDiv", contextPath+"/GIPIWinvTaxController",{
										method:"GET",
										parameters:{
											parId: parId,
											lineCd: lineCd,
											issCd: issCd,
											action: "showBillPremiumsPage"
										},
										evalScripts:true,
										asynchronous:true,
										onComplete:function(){
											hideNotice();
											Effect.Appear($("parInfoDiv").down("div", 0), {
													duration: .5,
													afterFinish: function(){
														if($("billPremiumsTableListingContainer").down("div", 0) != null || $("billPremiumsTableListingContainer").down("div", 0) != undefined){
															fireEvent($("billPremiumsTableListingContainer").down("div", 0), "click"); // andrew - 05.01.2011 - first record in bill premiums will be selected by default
														}
														
														//Added by Apollo Cruz 12.22.2014												
														setBillPremiumsCancellation(true,'${allowUpdateTaxEndtCancellation}');	//modified by Gzelle 07272015 SR4744
													}
												}); //billMainDiv
										}
									});
								}
						});
					}
				}
			});
			
			
		}
}