function setRoadMapFromParStatus(parList, wpolbas, isPack, currentModule, userId){
	var parStatus = parList.parStatus;
	var underwriter = parList.underwriter;
	var lineCd = parList.lineCd;
	var issCd = wpolbas.issCd;
	var coInsuranceSw = wpolbas.coInsuranceSw;
	var wPackLineSubline = isPack == "Y" ? wpolbas.gipiwPackLineSubline : {};
	var parType = parList.parType;
	
	objRoadMapAvail.allowEntry = "Y";
	
	if(nvl(parType, "P") != "P"){
		showWaitingMessageBox("Cannot access form called from menu. " +
						"PAR being processed has been tagged for endorsement.", "E", 
						function(){
							winRoadMap.close();
						});
	}
	
	if (parStatus == null || parStatus == ""){
		showWaitingMessageBox("The status of this PAR is not defined. " +
							"Will now return to PAR Listing module.", imgMessage.INFO, 
							function(){
								winRoadMap.close();
								if(isPack == "Y"){
									goBackToPackagePARListing();
								}else{
									goBackToParListing();
								}
							});
		return false;
	}
	
	if(userId != underwriter){
		showMessageBox("User is not allowed to make transactions with the selected PAR record.", "E");
		objRoadMapAvail.allowEntry = "N";
		checkRoadMapModuleAccess(lineCd, parType, isPack, currentModule);
		return false;
	}
	
	setRoadMapForOtherLines(issCd);
	
	if(parStatus < 2){
		showWaitingMessageBox("The PAR that you are currently processing has not yet been assigned. " +
			"You are not permitted to edit this PAR.", imgMessage.INFO, 
			function(){
				winRoadMap.close();
				if(isPack == "Y"){
					goBackToPackagePARListing();
				}else{
					goBackToParListing();
				}
			});
		return false;
	}else if(parStatus == 2){
		objRoadMapAvail.parlist 	= "AVAILABLE";
		objRoadMapAvail.basicInfo 	= "AVAILABLE";
		objRoadMapAvail.lineSubCov 	= "INACCESSIBLE";
		objRoadMapAvail.packPolItems= "INACCESSIBLE";
		objRoadMapAvail.peril 		= "INACCESSIBLE";
		objRoadMapAvail.warrClause 	= "INACCESSIBLE";
		setBillInfoRoadMap("disable");
		setDistRoadMap("disable");
		objRoadMapAvail.coInsurance = "INACCESSIBLE";
		objRoadMapAvail.coInsurer 	= "INACCESSIBLE";
		objRoadMapAvail.leadPol 	= "INACCESSIBLE";
		objRoadMapAvail.post 		= "INACCESSIBLE";
		objRoadMapAvail.print 		= "INACCESSIBLE";
		objRoadMapAvail.bankColl 	= "INACCESSIBLE";
	
	}else if(parStatus == 3){
		objRoadMapAvail.parlist 	= "AVAILABLE";
		objRoadMapAvail.basicInfo 	= "AVAILABLE";
		objRoadMapAvail.lineSubCov 	= "AVAILABLE";
		objRoadMapAvail.packPolItems= "AVAILABLE";
		setPackItemsRoadMap(wPackLineSubline);
		objRoadMapAvail.peril 		= "INACCESSIBLE";
		objRoadMapAvail.warrClause 	= "INACCESSIBLE";
		setBillInfoRoadMap("disable");
		setDistRoadMap("disable");
		objRoadMapAvail.coInsurance = "INACCESSIBLE";
		objRoadMapAvail.coInsurer 	= "INACCESSIBLE";
		objRoadMapAvail.leadPol 	= "INACCESSIBLE";
		objRoadMapAvail.post 		= "INACCESSIBLE";
		objRoadMapAvail.print 		= "AVAILABLE";
		
	}else if(parStatus == 4){
		objRoadMapAvail.parlist 	= "AVAILABLE";
		objRoadMapAvail.basicInfo 	= "AVAILABLE";
		objRoadMapAvail.lineSubCov 	= "AVAILABLE";
		objRoadMapAvail.packPolItems= "AVAILABLE";
		setPackItemsRoadMap(wPackLineSubline);
		objRoadMapAvail.peril 		= "AVAILABLE";
		objRoadMapAvail.warrClause 	= "AVAILABLE";
		setBillInfoRoadMap("disable");
		setDistRoadMap("disable");
		objRoadMapAvail.coInsurance = "INACCESSIBLE";
		objRoadMapAvail.coInsurer 	= "INACCESSIBLE";
		objRoadMapAvail.leadPol 	= "INACCESSIBLE";
		objRoadMapAvail.post 		= "INACCESSIBLE";
		objRoadMapAvail.print 		= "AVAILABLE";
	
	}else if(parStatus == 5){
		objRoadMapAvail.parlist 	= "AVAILABLE";
		objRoadMapAvail.basicInfo 	= "AVAILABLE";
		objRoadMapAvail.lineSubCov 	= "AVAILABLE";
		objRoadMapAvail.packPolItems= "AVAILABLE";
		setPackItemsRoadMap(wPackLineSubline);
		objRoadMapAvail.peril 		= "AVAILABLE";
		objRoadMapAvail.warrClause 	= "AVAILABLE";
		setBillInfoRoadMap("enable");
		setDistRoadMap("enable");
		objRoadMapAvail.invComm 	= "INACCESSIBLE";
		setCoInsuranceRoadMap(coInsuranceSw);
		objRoadMapAvail.post 		= "INACCESSIBLE";
		objRoadMapAvail.print 		= "AVAILABLE";
		
	}else if(parStatus == 6){
		objRoadMapAvail.parlist 	= "AVAILABLE";
		objRoadMapAvail.basicInfo 	= "AVAILABLE";
		objRoadMapAvail.lineSubCov 	= "AVAILABLE";
		objRoadMapAvail.packPolItems= "AVAILABLE";
		setPackItemsRoadMap(wPackLineSubline);
		objRoadMapAvail.peril 		= "AVAILABLE";
		objRoadMapAvail.warrClause 	= "AVAILABLE";
		setBillInfoRoadMap("enable");
		setDistRoadMap("enable");
		objRoadMapAvail.invComm 	= "AVAILABLE";
		setCoInsuranceRoadMap(coInsuranceSw);
		objRoadMapAvail.post 		= "INACCESSIBLE";
		objRoadMapAvail.print 		= "AVAILABLE";
		
	}else if(parStatus == 10){
		objRoadMapAvail.parlist 	= "INACCESSIBLE";
		objRoadMapAvail.basicInfo 	= "INACCESSIBLE";
		objRoadMapAvail.lineSubCov 	= "INACCESSIBLE";
		objRoadMapAvail.print 		= "INACCESSIBLE";
		objRoadMapAvail.bondBasicInfo = "INACCESSIBLE";
		objRoadMapAvail.reqDocs 	= "INACCESSIBLE";
		objRoadMapAvail.initAcc 	= "INACCESSIBLE";
		objRoadMapAvail.packPolItems = "INACCESSIBLE";
		objRoadMapAvail.peril 		= "INACCESSIBLE";
		objRoadMapAvail.warrClause 	= "INACCESSIBLE";
		objRoadMapAvail.lineSubCov 	= "INACCESSIBLE";
		objRoadMapAvail.billInfo 	= "INACCESSIBLE";
		objRoadMapAvail.grpItem 	= "INACCESSIBLE";
		objRoadMapAvail.billPrem 	= "INACCESSIBLE";
		objRoadMapAvail.discSur 	= "INACCESSIBLE";
		objRoadMapAvail.invComm 	= "INACCESSIBLE";
		objRoadMapAvail.coInsurance = "INACCESSIBLE";
		objRoadMapAvail.coInsurer 	= "INACCESSIBLE";
		objRoadMapAvail.leadPol 	= "INACCESSIBLE";
		objRoadMapAvail.prelimDist 	= "INACCESSIBLE";
		objRoadMapAvail.setupGrp 	= "INACCESSIBLE";
		objRoadMapAvail.perilDist 	= "INACCESSIBLE";
		objRoadMapAvail.OneRiskDist = "INACCESSIBLE";
		objRoadMapAvail.post 		= "INACCESSIBLE";
		objRoadMapAvail.dist 		= "AVAILABLE";
		objRoadMapAvail.distPeril 	= "AVAILABLE";
		objRoadMapAvail.distGrp 	= "AVAILABLE";
		
	}else{
		showWaitingMessageBox("PAR cannot be processed due to its status. " +
				  "Will now return to PAR Listing module.", imgMessage.INFO, 
				  function(){
					winRoadMap.close();
					if(isPack == "Y"){
						goBackToPackagePARListing();
					}else{
						goBackToParListing();
					}
				  });
		return false;
	}
	if(parType == "E"){

		if(((parStatus > 2 && parStatus < 5) || parStatus == 6) && checkUserModule("GIPIS055") && wPackLineSubline.length > 0){
			objRoadMapAvail.post = "AVAILABLE"; 
		}else{
			objRoadMapAvail.post = "INACCESSIBLE";
		}
	} else {

		if(parStatus == 6 && checkUserModule("GIPIS055") && wPackLineSubline.length > 0){
			objRoadMapAvail.post = "AVAILABLE"; 
		}else{
			objRoadMapAvail.post = "INACCESSIBLE";
		}
	}
	
	checkRoadMapModuleAccess(lineCd, parType, isPack, currentModule);
}