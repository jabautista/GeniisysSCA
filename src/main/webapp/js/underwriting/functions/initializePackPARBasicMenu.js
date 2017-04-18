// added by: nica 01.14.2011 to initialize package PAR menu
// mark jm 10.05.2011 modified by adding getLineCd in getItemModuleId
function initializePackPARBasicMenu(parType, lineCd) {
	try {
		parType = parType == null || parType == "" ? objUWGlobal.parType : parType;
		lineCd  = lineCd  == null || lineCd  == "" ? objUWGlobal.lineCd : lineCd;
		$("packagePolicyItems").show();
		//$("itemInfo").hide();
		disableMenu("itemInfo");
		observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS031A" : "GIPIS002"), "basicInfo", 
							   (parType == "E" ? showEndtPackParBasicInfo : showPackParBasicInfo));	
		observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS035A" : "GIPIS024A"), "clauses", showWPackWarrantyAndClausePage); //added by steven 12.17.2013; (parType == "E" ? "GIPIS035A" : "GIPIS024A")
		observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS094" : "GIPIS093"), "lineSublineCoverages", 
				(parType == "E" ? showEndtLineSublineCoverages : showLineSublineCoverages));
			//	showLineSublineCoverages); // added by irwin. March 10,2011
		
		// pack par item menus
		
		var mcModId = getItemModuleId(parType, getLineCd(objLineCds.MC));
		var fiModId = getItemModuleId(parType, getLineCd(objLineCds.FI));
		var avModId = getItemModuleId(parType, getLineCd(objLineCds.AV));
		var enModId = getItemModuleId(parType, getLineCd(objLineCds.EN));
		var caModId = getItemModuleId(parType, getLineCd(objLineCds.CA));
		var mnModId = getItemModuleId(parType, getLineCd(objLineCds.MN));
		var mhModId = getItemModuleId(parType, getLineCd(objLineCds.MH));	
		var ahModId = getItemModuleId(parType, getLineCd(objLineCds.AC));
		var otModId = getItemModuleId(parType, getLineCd(objLineCds.OT));
		
		observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS096" : "GIPIS095"), 'packPolItems', showPackPolicyItems);
		observeAccessibleModule(accessType.MENU, mcModId, 'packItemMC', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.MC);});
		observeAccessibleModule(accessType.MENU, fiModId, 'packItemFI', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.FI);});
		observeAccessibleModule(accessType.MENU, avModId, 'packItemAV', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.AV);});
		observeAccessibleModule(accessType.MENU, mnModId, 'packItemMN', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.MN);});
		observeAccessibleModule(accessType.MENU, mhModId, 'packItemMH', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.MH);});
		observeAccessibleModule(accessType.MENU, caModId, 'packItemCA', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.CA);});
		observeAccessibleModule(accessType.MENU, ahModId, 'packItemAH', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.AC);});
		observeAccessibleModule(accessType.MENU, enModId, 'packItemEN', function(){showPackItemsPerLine(objUWGlobal.packParId, objLineCds.EN);});
		observeAccessibleModule(accessType.MENU, "GIPIS143", "discountSurcharge", showDiscountSurcharge); // mark jm 04.18.2011 @UCPBGEN
		observeAccessibleModule(accessType.MENU, "GIPIS025", "groupItemsPerBill", showPackBillGrouping); // mark jm 04.18.2011 @UCPBGEN
		observeAccessibleModule(accessType.MENU, "GIPIS026", "enterBillPremiums", showBillPremium);	// mark jm 04.18.2011 @UCPBGEN
		observeAccessibleModule(accessType.MENU, "GIPIS085", "enterInvoiceCommission", showInvoiceCommissionPage);	// mark jm 04.18.2011 @UCPBGEN
		observeAccessibleModule(accessType.MENU, "GIPIS007", "carrierInfo", function(){showPackCarrierInformation(objUWGlobal.packParId, objLineCds.MN);});
		observeAccessibleModule(accessType.MENU, "GIPIS045", "additionalEngineeringInfo", function (){showPackAdditionalENInfoPage(objUWGlobal.packParId, objLineCds.EN);});
		
		observeAccessibleModule(accessType.MENU, "GIPIS055A", "post", showPostingPar);
		observeAccessibleModule(accessType.MENU, "GIUWS001", "groupPrelimDist", showSetUpGroupsForPrelimDist);
		observeAccessibleModule(accessType.MENU, "GIUWS003", "prelimPerilDist", showPreliminaryPerilDist);
		//observeAccessibleModule(accessType.MENU, "GIUWS004", "prelimOneRiskDist", showPreliminaryOneRiskDist); removed by robert SR 5053 11.11.15
		observeAccessibleModule(accessType.MENU, "GIUWS004", "prelimOneRiskDistTsiPrem", showPreliminaryOneRiskDistByTsiPrem);
		//observeAccessibleModule(accessType.MENU, "GIUWS006", "prelimDistTsiPrem", showPreliminaryPerilDistByTsiPrem); removed by robert SR 5053 11.11.15
		
		observeAccessibleModule(accessType.MENU, "GIUWS006", "initialAcceptance", function(){
			showRIPackParCreationPage("1",parType);
		});
	
		$("samplePolicy").observe("click", function(){
			// mark jm 04.18.2011 @UCPBGEN based on underwriting.js
			/*showOverlayContent(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
					+$F("globalParId")+"&globalPackParId="+$F("globalPackParId"), 
					"Geniisys Report Generator", showReportGenerator, 400, 100, 100);*/
			Modalbox.show(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
					+(objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalParId"))+"&globalPackParId="+(objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalPackParId")), 
					"Geniisys Report Generator", {
				title : "Geniisys Report Generator",
				width : 400
			});
		});
		
		$("roadMap").observe("click", function(){
			showPackRoadMap();
		});
		
	} catch(e){
		showErrorMessage("initializePackPARBasicMenu", e);
	}
	
	// edited by: nica 02.14.2011
	$("parExit").observe("click", function(){doParExit();});
}