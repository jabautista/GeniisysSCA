function drawRoadMap(context){
	var lineWidth = 3;
	var w = 20;
	var firstCol = 25;
	var secCol = 100;
	
	// DEFINE LINES HERE
	//makeRectangleLine(context,x,y,width,height,color)
	// VERTICAL LINES
	
	//-- 1st set -------
	makeRectangleLine(context, 4, 45,  lineWidth, 58, GRAY_COLOR);
	makeRectangleLine(context, 4, 103,  lineWidth, 58, GRAY_COLOR);
	makeRectangleLine(context, 4, 160,  lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 4, 185,  lineWidth, 130, GRAY_COLOR);
	makeRectangleLine(context, 4, 315,  lineWidth, 30, GRAY_COLOR);
	
	// -- 2nd set -------
	makeRectangleLine(context, 33, 20,  lineWidth, 20, GRAY_COLOR);
	makeRectangleLine(context, 33, 40,  lineWidth, 80, GRAY_COLOR);
	makeRectangleLine(context, 33, 140,  lineWidth, 10, GRAY_COLOR);
	makeRectangleLine(context, 33, 170,  lineWidth, 10, GRAY_COLOR);
	makeRectangleLine(context, 33, 180,  lineWidth, 70, GRAY_COLOR);
	makeRectangleLine(context, 33, 265,  lineWidth, 40, GRAY_COLOR);
	makeRectangleLine(context, 33, 325,  lineWidth, 10, GRAY_COLOR);
	makeRectangleLine(context, 33, 355,  lineWidth, 10, GRAY_COLOR);
	makeRectangleLine(context, 33, 385,  lineWidth, 10, GRAY_COLOR);
	
	// -- 3rd set -------
	makeRectangleLine(context, 79, 20, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 45, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 140, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 165, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 190, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 245, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 300, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 325, lineWidth, 25, GRAY_COLOR);
	makeRectangleLine(context, 79, 395, lineWidth, 25, GRAY_COLOR);
	
	// HORIZONTAL LINES 
	
	//-- 1st set -------
	makeRectangleLine(context, 4, 45, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 4, 100, 95, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 4, 160, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 4, 180, 75, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 4, 315, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 4, 345, 20, lineWidth, GRAY_COLOR);
	
	// -- 2nd set -------
	makeRectangleLine(context, 45, 45, 35, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 45, 255, 35, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 45, 315, 35, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 45, 405, 35, lineWidth, GRAY_COLOR);
	
	// -- 3rd set -------
	makeRectangleLine(context, 79, 17, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 45, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 70, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 140, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 165, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 190, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 215, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 245, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 270, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 300, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 325, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 350, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 395, 20, lineWidth, GRAY_COLOR);
	makeRectangleLine(context, 79, 420, 20, lineWidth, GRAY_COLOR);
	
	setRoadMapAvailPath(context);
	
	//****** DEFINE/DRAW THE MODULES/ACTIONS HERE ******//

	//makeSquare(context, x, y, w, status, funcWhenAvailable, moduleId, moduleDesc)
	
	function triggerMenu(menuId){
		fireEvent($(menuId), "click");
		winRoadMap.close();
	}
	
	makeSquare(context, firstCol, 6, w, objRoadMapAvail.parlist, function(){triggerMenu("parExit");},"rmParList","PAR Listing"	);
	if(objUWGlobal.lineCd == "SU" || objUWGlobal.menuLineCd == "SU"){
		makeSquare(context, firstCol, 35, w, objRoadMapAvail.bondBasicInfo, function(){triggerMenu("basicInfo");}, "rmBondBasicInfo", "Basic Bond Information");
	}else{
		makeSquare(context, firstCol, 35, w, objRoadMapAvail.basicInfo, function(){triggerMenu("basicInfo");}, "rmBasicInfo", "Basic Information");
	}
  	makeSquare(context, firstCol, 120, w, objRoadMapAvail.itemInfo, function(){triggerMenu("itemInfo"); }, "rmItem", "Items");
  	makeSquare(context, firstCol, 150, w, objRoadMapAvail.peril, function(){triggerMenu("itemInfo"); }, "rmPeril", "Peril");
  	makeSquare(context, firstCol, 245, w, objRoadMapAvail.coInsurance, null, "rmCoInsurance", "Co-Insurance");
  	makeSquare(context, firstCol, 305, w, objRoadMapAvail.prelimDist,	null, "rmPrelimDist", "Preliminary Distribution");
  	makeSquare(context, firstCol, 335, w, objRoadMapAvail.print, function(){ triggerMenu("samplePolicy");}, "rmPrint", "Print");
  	makeSquare(context, firstCol, 365, w, objRoadMapAvail.post , function(){triggerMenu("post"); }, "rmPost", "Post");
  	makeSquare(context, firstCol, 395, w, objRoadMapAvail.dist, null, "rmDist", "Distribution");

  	makeSquare(context, secCol, 10, w, objRoadMapAvail.initAcc, function(){triggerMenu("initialAcceptance"); }, "rmInitAcc", "Initial Acceptance");
  	makeSquare(context, secCol, 35, w, objRoadMapAvail.reqDocs, function(){ triggerMenu("reqDocsSubmitted");}, "rmReqDocs", "Req. Documents Submitted");
  	
  	if(objUWGlobal.lineCd == "SU" || objUWGlobal.menuLineCd == "SU"){
		makeSquare(context, secCol, 60, w, objRoadMapAvail.collTrans, function(){triggerMenu("collateralTransaction");}, "rmCollTran", "Collateral Transaction");
	}else if(objUWGlobal.lineCd == "EN" || objUWGlobal.menuLineCd == "EN"){
		makeSquare(context, secCol, 60, w, objRoadMapAvail.engInfo, function(){triggerMenu("additionalEngineeringInfo");},"rmEngInfo",  "Engineering Information");
	}else{
		makeSquare(context, secCol, 60, w, "INACCESSIBLE", function(){ }, "generic", "");
	}
  	
  	makeSquare(context, secCol, 90,	 w, objRoadMapAvail.warrClause, function(){triggerMenu("clauses"); }, "rmWarrClause", "Warranties and Clauses");
  	makeSquare(context, secCol, 130, w, objRoadMapAvail.discSur, function(){triggerMenu("discountSurcharge"); }, "rmDiscSur", "Discount/Surcharge");
  	makeSquare(context, secCol, 155, w, objRoadMapAvail.grpItem, function(){triggerMenu("groupItemsPerBill"); }, "rmGrpItem", "Group Items per Bill");
  	makeSquare(context, secCol, 180, w, objRoadMapAvail.billPrem, function(){triggerMenu("enterBillPremiums"); }, "rmBillPrem", "Bill Premium");
  	makeSquare(context, secCol, 205, w, objRoadMapAvail.invComm, function(){triggerMenu("enterInvoiceCommission"); }, "rmInvComm", "Invoice Commission");
  	makeSquare(context, secCol, 235, w, objRoadMapAvail.coInsurer, function(){triggerMenu("coInsurer"); }, "rmCoInsurer", "Co-Insurer");
  	makeSquare(context, secCol, 260, w, objRoadMapAvail.leadPol, function(){ triggerMenu("leadPolicy");}, "rmLeadPol", "Lead Policy");
  	makeSquare(context, secCol, 290, w, objRoadMapAvail.setupGrp, function(){triggerMenu("groupPrelimDist"); }, "rmSetupGrp", "Group Setup");
  	makeSquare(context, secCol, 315, w, objRoadMapAvail.perilDist, function(){triggerMenu("prelimPerilDist"); }, "rmPerilDist", "Peril Distribution");
  	makeSquare(context, secCol, 340, w, objRoadMapAvail.oneRiskDist, function(){triggerMenu("prelimOneRiskDist"); }, "rmOneRiskDist", "One Risk Distribution");
  	makeSquare(context, secCol, 385, w, objRoadMapAvail.distPeril, function(){showDistributionByGroup();winRoadMap.close();}, "rmDistPeril", "Distribution by Peril");
  	makeSquare(context, secCol, 410, w, objRoadMapAvail.distGrp, function(){ showDistributionByPeril();winRoadMap.close();}, "rmDistGrp", "Distribution by Group");
}