/**
 * Draws the road map image for Package PAR.
 * @author Veronica V. Raymundo
 * @param context - the id of the canvas
 */
function drawPackRoadMap(context){
	var lineWidth = 3;
	var w = 20;
	var firstCol = 35;
	var secCol = 105;
	var thirdCol = 175;
	
	/*Draws the line path for each icons*/
	/*PAR listing to basic info.*/
	
	//makeRectangleLine(context,x,y,width,height,color)
	
	// VERTICAL LINES -- 1st set -------

	makeRectangleLine(context, 20, 43, lineWidth, 207,GRAY_COLOR);
	makeRectangleLine(context, 20, 250, lineWidth, 30,GRAY_COLOR);
	makeRectangleLine(context, 20, 280, lineWidth, 60,GRAY_COLOR);
	makeRectangleLine(context, 20, 340, lineWidth, 30,GRAY_COLOR);
	makeRectangleLine(context, 43, 30, lineWidth,  5,GRAY_COLOR);
	makeRectangleLine(context, 43, 43, lineWidth, 85,GRAY_COLOR);
	makeRectangleLine(context, 43, 145, lineWidth, 55,GRAY_COLOR);
	makeRectangleLine(context, 43, 220, lineWidth, 20,GRAY_COLOR);
	makeRectangleLine(context, 43, 260, lineWidth, 10,GRAY_COLOR);
	makeRectangleLine(context, 43, 290, lineWidth, 10,GRAY_COLOR);
	makeRectangleLine(context, 43, 320, lineWidth, 10,GRAY_COLOR);
	makeRectangleLine(context, 43, 350, lineWidth, 10,GRAY_COLOR);
	makeRectangleLine(context, 43, 380, lineWidth, 10,GRAY_COLOR);
	makeRectangleLine(context, 43, 410, lineWidth, 10,GRAY_COLOR);
	
	// -- 2nd set -------
	makeRectangleLine(context,	90, 60,	 lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 85,  lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 110, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 135, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 160, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 185, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 210, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 235, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 300, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90, 340, lineWidth, 20,	GRAY_COLOR);
	makeRectangleLine(context,	90, 360, lineWidth, 25,	GRAY_COLOR);
	makeRectangleLine(context,	90,	385, lineWidth, 25,	GRAY_COLOR);
	
	// -- 3rd set -------
	makeRectangleLine(context, 160, 20,  lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 43,  lineWidth,	27,	GRAY_COLOR);
	makeRectangleLine(context, 160, 70,  lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 95,	 lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 120, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 145, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 170, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 195, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 220, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 280, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 305, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 330, lineWidth,	25,	GRAY_COLOR);
	makeRectangleLine(context, 160, 405, lineWidth,	25,	GRAY_COLOR);
	
	// HORIZONTAL LINES -- 1st set -------
	makeRectangleLine(context, 20, 43,  15,	lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 35, 43,  130,lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 50, 135, 40, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 20, 250, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 20, 280, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 35, 280, 130,lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 35, 312, 55, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 20, 340, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 35, 340, 55, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 20, 370, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 35, 430, 130,lineWidth, GRAY_COLOR);
	
	// -- 2nd set -------
	makeRectangleLine(context, 90, 60,	15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 85,	15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 110,	15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 135, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 160, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 185, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 210, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 235, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 260, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 300, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 325, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 360, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 385, 15, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 90, 410, 15, lineWidth, GRAY_COLOR);
	
	// -- 3rd set -------
	makeRectangleLine(context, 160, 20,  15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 43,  15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 70,  15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 95,  15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 120, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 145, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 170, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 195, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 220, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 245, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 280, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 305, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 330, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 355, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 405, 15, lineWidth,	GRAY_COLOR);
	makeRectangleLine(context, 160, 430, 15, lineWidth,	GRAY_COLOR);
	
	function triggerMenu(menuId){
		fireEvent($(menuId), "click");
		winRoadMap.close();
	}
	
	setPackRoadMapAvailPath(context);
	
	//makeSquare(context, x, y, w, status, funcWhenAvailable, moduleId, moduleDesc)
	
	makeSquare(context, firstCol, 10,  w, objRoadMapAvail.parlist, function(){	triggerMenu("parExit");	}, "rmParlist",	"PAR Listing");
	makeSquare(context, firstCol, 35,  w, objRoadMapAvail.basicInfo, function(){triggerMenu("basicInfo");}, "rmBasicInfo", "Basic Information");
  	makeSquare(context, firstCol, 125, w, objRoadMapAvail.packPolItems, function(){triggerMenu("packPolItems");}, "rmPackPolItems", "Package Policy Items");
  	makeSquare(context, firstCol, 200, w, objRoadMapAvail.peril, null, "rmPeril", "Peril");
  	makeSquare(context, firstCol, 240, w, objRoadMapAvail.warrClause, function(){triggerMenu("clauses");}, "rmWarrClause", "Warranties and Clauses");
  	makeSquare(context, firstCol, 270, w, objRoadMapAvail.billInfo, null, "rmBillInfo", "Bill Information");
  	makeSquare(context, firstCol, 300, w, objRoadMapAvail.coInsurance, null,"rmCoInsurance", "Co-Insurance");
  	makeSquare(context, firstCol, 330, w, objRoadMapAvail.prelimDist, null, "rmPrelimDist", "Preliminary Distribution");
  	makeSquare(context, firstCol, 360, w, objRoadMapAvail.print, function(){triggerMenu("samplePolicy");}, "rmPrint", "Print");
  	makeSquare(context, firstCol, 390, w, objRoadMapAvail.post, function(){triggerMenu("post");}, "rmPost", "Post");
  	makeSquare(context, firstCol, 420, w, objRoadMapAvail.dist, null, "rmDist", "Distribution");
  	
  	makeSquare(context, secCol, 50,  w, objRoadMapAvail.itemMC, function(){triggerMenu("packItemMC");}, "rmMCItem", "Motor Car Item Information");
  	makeSquare(context, secCol, 75,  w, objRoadMapAvail.itemFI, function(){triggerMenu("packItemFI");}, "rmFIItem", "Fire Item Information");
  	makeSquare(context, secCol, 100, w, objRoadMapAvail.itemEN, function(){triggerMenu("packItemEN");}, "rmENItem", "Engineering Item Information");
  	makeSquare(context, secCol, 125, w, objRoadMapAvail.itemMN, function(){triggerMenu("packItemMN");}, "rmMNItem", "Cargo Item Information");
  	makeSquare(context, secCol, 150, w, objRoadMapAvail.itemMH, function(){triggerMenu("packItemMH");}, "rmMHItem", "Marine Hull Item Information");
  	makeSquare(context, secCol, 175, w, objRoadMapAvail.itemCA, function(){triggerMenu("packItemCA");}, "rmCAItem", "Misc. Casual Item Information");
  	makeSquare(context, secCol, 200, w, objRoadMapAvail.itemAV, function(){triggerMenu("packItemAV");}, "rmAVItem", "Aviation Item Information");
  	makeSquare(context, secCol, 225, w, objRoadMapAvail.itemAC, function(){triggerMenu("packItemAH");}, "rmACItem", "Accident Item Information");
  	makeSquare(context, secCol, 250, w, objRoadMapAvail.itemOthers, null, "rmOthers", "Others");
  	
  	makeSquare(context, secCol, 290, w, objRoadMapAvail.coInsurer, function(){triggerMenu("coInsurer");}, "rmCoInsurer", "Co-Insurer");
  	makeSquare(context, secCol, 315, w, objRoadMapAvail.leadPol, function(){triggerMenu("leadPolicy");}, "rmLeadPol", "Lead Policy");
  	makeSquare(context, secCol, 350, w, objRoadMapAvail.setupGrp, function(){triggerMenu("groupPrelimDist");}, "rmSetupGrp", "Group Set-up");
  	makeSquare(context, secCol, 375, w, objRoadMapAvail.perilDist, function(){triggerMenu("prelimPerilDist");}, "rmPerilDist",  "Peril and Distribution");
  	makeSquare(context, secCol, 400, w, objRoadMapAvail.oneRiskDist, function(){triggerMenu("prelimOneRiskDist");}, "rmOneRiskDist", "One Risk Distribution");
  	
  	makeSquare(context, thirdCol, 10,  w, objRoadMapAvail.bondBasicInfo, function(){triggerMenu("bondBasicInfo");}, "rmBondBasicInfo", "Bond Basic Information");
  	makeSquare(context, thirdCol, 35,  w, objRoadMapAvail.engInfo, function(){triggerMenu("additionalEngineeringInfo");},"rmEngInfo",  "Engineering Information");
  	makeSquare(context, thirdCol, 60,  w, objRoadMapAvail.lineSubCov, function(){triggerMenu("lineSublineCoverages");}, "rmLineSubCov", "Line/Subline Coverage");
  	makeSquare(context, thirdCol, 85,  w, objRoadMapAvail.cargoLiab, function(){triggerMenu("cargoLimitsOfLiability");}, "rmMNLiab",  "Cargo Limits of Liability");
  	makeSquare(context, thirdCol, 110, w, objRoadMapAvail.carrierInfo, function(){triggerMenu("carrierInfo");}, "rmCarrierInfo", "Carrier Information");
  	makeSquare(context, thirdCol, 135, w, objRoadMapAvail.bankColl, function(){triggerMenu("bankCollection");}, "rmBankColl", "Bank Collection");
  	makeSquare(context, thirdCol, 160, w, objRoadMapAvail.reqDocs, function(){triggerMenu("reqDocsSubmitted");}, "rmReqDocs", "Documents Submitted");
  	makeSquare(context, thirdCol, 185, w, objRoadMapAvail.initAcc, function(){triggerMenu("initialAcceptance");},"rmInitAcc",  "Initial Acceptance");
  	makeSquare(context, thirdCol, 210, w, objRoadMapAvail.collTrans, function(){triggerMenu("collateralTransaction");}, "rmCollTran", "Collateral Transaction");
  	makeSquare(context, thirdCol, 235, w, objRoadMapAvail.limLiab, function(){triggerMenu("rmLimLiab");}, "rmLimLiab", "Limits of Liabilities");
  	makeSquare(context, thirdCol, 270, w, objRoadMapAvail.discSur, function(){triggerMenu("discountSurcharge");}, "rmDiscSur", "Discount/Surcharge");
  	makeSquare(context, thirdCol, 295, w, objRoadMapAvail.grpItem, function(){triggerMenu("groupItemsPerBill");}, "rmGrpItem", "Group Items per Bill");
  	makeSquare(context, thirdCol, 320, w, objRoadMapAvail.billPrem, function(){triggerMenu("enterBillPremiums");}, "rmBillPrem",  "Bill Premium");
  	makeSquare(context, thirdCol, 345, w, objRoadMapAvail.invComm, function(){triggerMenu("enterInvoiceCommission");}, "rmInvComm", "Invoice Commission");
  	makeSquare(context, thirdCol, 395, w, objRoadMapAvail.distPeril, function(){showDistributionByGroup();winRoadMap.close();}, "rmDistPeril", "Distribution by Peril");
  	makeSquare(context, thirdCol, 420, w, objRoadMapAvail.distGrp, function(){showDistributionByPeril();winRoadMap.close();}, "rmDistGrp", "Distribution by Group");
}