function initializePARBasicMenu(parType, lineCd) { // andrew - 09.29.2010 - added parType and lineCd parameters
	//menu related scripts
	// menus for par basic info
	parType = parType == "" || parType == null ? $F("globalParType") : parType;
	lineCd  = lineCd  == "" || lineCd  == null ? $F("globalLineCd") : lineCd;
	var itemInfoModuleId = getItemModuleId(parType, objUWGlobal.lineCd, objUWGlobal.menuLineCd);
	
	observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS165" : "GIPIS017"), "bondBasicInfo", (parType == "E" ? showEndtBondBasicInfo : showBondBasicInfo));
	observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS165A" :"GIPIS017"), "bondPolicyData", (parType == "E"? showEndtBondPolicyDataPage : showBondPolicyDataPage));
	observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS031" : "GIPIS002"), "basicInfo", showBasicInfo);
	observeAccessibleModule(accessType.MENU, "GIPIS143", "discountSurcharge", showDiscountSurcharge);
	observeAccessibleModule(accessType.MENU, "GIPIS024", "clauses", showWPolicyWarrantyAndClausePage);
	observeAccessibleModule(accessType.MENU, itemInfoModuleId, "itemInfo", showItemInfo);
	observeAccessibleModule(accessType.MENU, "GIPIS007", "carrierInfo", showCarrierInfoPage);
	observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS078" : "GIPIS005"), "cargoLimitsOfLiability", function(){parType == "E" ? showEndtLimitsOfLiabilityPage() : showLimitsOfLiabilityPage(1);});
	
	observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS173" : "GIPIS172"), "limitsOfLiabilities", (parType == "E" ? function(){showEndtLimitsOfLiabilityDataEntry();} : function(){showLimitsOfLiabilityPage(0);}));
	observeAccessibleModule(accessType.MENU, "GIUTS034", "miniReminder", showMiniReminder);
	//observeAccessibleModule(accessType.MENU, "GIPIS172", "limitsOfLiabilities", function(){showLimitsOfLiabilityPage(0);});
	observeAccessibleModule(accessType.MENU, "GIPIS089", "bankCollection", showBankCollectionPage);
	observeAccessibleModule(accessType.MENU, "GIPIS025", "groupItemsPerBill", showBillGroupingPage); // nica 10.15.2010
	observeAccessibleModule(accessType.MENU, "GIPIS026", "enterBillPremiums", showBillPremium);
	observeAccessibleModule(accessType.MENU, "GIPIS085", "enterInvoiceCommission", showInvoiceCommissionPage);
	
	observeAccessibleModule(accessType.MENU, "GIPIS153", "coInsurer", showCoInsurerPage);
	observeAccessibleModule(accessType.MENU, "GIPIS154", "leadPolicy", /* showLeadPolicyPage */ checkCoInsurerInfo); // nica 04.25.2011 // changed to checkCoInsurerInfo : shan 10.21.2013
	observeAccessibleModule(accessType.MENU, "GIPIS029", "reqDocsSubmitted", showRequiredDocsPage);
	observeAccessibleModule(accessType.MENU, "GIPIS018", "collateralTransaction", showCollateralTransactionPage); //rmanalad 04.13.2011
	//observeAccessibleModule(accessType.MENU, "GIPIS090", "policyPrinting", showPolicyPrintingPage);
	observeAccessibleModule(accessType.MENU, "GIPIS055", "post", showPostingPar);
	observeAccessibleModule(accessType.MENU, "GIUWS001", "groupPrelimDist", showSetUpGroupsForPrelimDist);
	observeAccessibleModule(accessType.MENU, "GIUWS003", "prelimPerilDist", showPreliminaryPerilDist);
	//observeAccessibleModule(accessType.MENU, "GIUWS004", "prelimOneRiskDist", showPreliminaryOneRiskDist); removed by robert SR 5053 11.11.15
	observeAccessibleModule(accessType.MENU, "GIUWS004", "prelimOneRiskDistTsiPrem", showPreliminaryOneRiskDistByTsiPrem);
	//observeAccessibleModule(accessType.MENU, "GIUWS006", "prelimDistTsiPrem", showPreliminaryPerilDistByTsiPrem); removed by robert SR 5053 11.11.15
	observeAccessibleModule(accessType.MENU, "GIPIS045", "additionalEngineeringInfo", showAdditionalENInfoPage);
	//observeAccessibleModule(accessType.MENU, "GIRIS005", "initialAcceptance", function(){showRIParCreationPage("1", parType);});
	observeAccessibleModule(accessType.MENU, 
			objUWGlobal.packParId == null ? "GIRIS005" : "GIRIS005A", "initialAcceptance", 
			function(){
				if(nvl(objUWGlobal.packParId, null) == null) {
					showRIParCreationPage("1", parType);
				} else {
					
				}
			});
	//observeAccessibleModule(accessType.MENU, "", "print", printPolicy);

	$("samplePolicy").observe("click", function(){
		/*showOverlayContent(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
				+$F("globalParId")+"&globalPackParId="+$F("globalPackParId"), 
				"Geniisys Report Generator", showReportGenerator, 400, 100, 100);*/
		Modalbox.show(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
				+$F("globalParId")+"&globalPackParId="+$F("globalPackParId"),//+"&globalLineCd="+$F("globalLineCd"), 
		    {
			title : "Geniisys Reports Generator",
			width : 400
		});
	});
	
	$("coverNote").observe("click", function(){
		showCovernoteReportGenerator();
	});
	
	$("roadMap").observe("click", function(){  /**  GIPIS300A */
		showRoadMap();
	});
	
	// menus for par basic info
	observeGoToModule("parExit", goBackToParListing);
}