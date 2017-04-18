function checkRoadMapModuleAccess(lineCd, parType, isPack, currentModule){
	if(objRoadMapAvail.parlist == "AVAILABLE"){
		var moduleName = "";
		if(isPack == "Y"){
			moduleName = parType == "E" ? "GIPIS050A" : "GIPIS001A";
		}else{
			moduleName = parType == "E" ? "GIPIS050" : "GIPIS001";
		}
		
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.parlist = "RESTRICTED";
		};
	}
	if(objRoadMapAvail.basicInfo == "AVAILABLE"){
		var moduleName = "";
		if(isPack == "Y"){
			moduleName = parType == "E" ? "GIPIS058A" : "GIPIS002";
		}else{
			moduleName = parType == "E" ? "GIPIS058" : "GIPIS002";
		}
		
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.basicInfo = "RESTRICTED"; 
		};
	}

	if(objRoadMapAvail.bondBasicInfo == "AVAILABLE"){		
		if(!checkUserModule("GIPIS017")){
			objRoadMapAvail.bondBasicInfo = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.engInfo == "AVAILABLE"){		
		if(!checkUserModule("GIPIS045")){
			objRoadMapAvail.engInfo = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.lineSubCov == "AVAILABLE"){		
		var moduleName = parType == "E" ? "GIPIS094" : "GIPIS093";
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.lineSubCov = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.cargoLiab == "AVAILABLE"){		
		if(!checkUserModule("GIPIS005")){
			objRoadMapAvail.cargoLiab  = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.carrierInfo == "AVAILABLE"){		
		if(!checkUserModule("GIPIS007")){
			objRoadMapAvail.cargoLiab = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.bankColl == "AVAILABLE"){		
		if(!checkUserModule("GIPIS089")){
			objRoadMapAvail.bankColl = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.reqDocs == "AVAILABLE"){		
		if(!checkUserModule("GIPIS029")){
			objRoadMapAvail.reqDocs = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.initAcc == "AVAILABLE"){		
		if(!checkUserModule("GIRIS005")){
			objRoadMapAvail.initAcc = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.collTrans == "AVAILABLE"){		
		if(!checkUserModule("GIPIS018")){
			objRoadMapAvail.collTrans = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.limLiab == "AVAILABLE"){		
		if(!checkUserModule("GIPIS172")){
			objRoadMapAvail.limLiab = "RESTRICTED";
		};
	}
	
	if(objRoadMapAvail.packPolItems == "AVAILABLE"){
		var moduleName = parType == "E" ? "GIPIS096" : "GIPIS095";
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.packPolItems = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemMC == "AVAILABLE"){		
		if(!checkUserModule("GIPIS010")){
			objRoadMapAvail.itemMC = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemFI == "AVAILABLE"){		
		if(!checkUserModule("GIPIS003")){
			objRoadMapAvail.itemFI = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemEN == "AVAILABLE"){		
		if(!checkUserModule("GIPIS004")){
			objRoadMapAvail.itemEN = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemMN == "AVAILABLE"){		
		if(!checkUserModule("GIPIS006")){
			objRoadMapAvail.itemMN = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemMH == "AVAILABLE"){		
		if(!checkUserModule("GIPIS009")){
			objRoadMapAvail.itemMH = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemCA == "AVAILABLE"){		
		if(!checkUserModule("GIPIS011")){
			objRoadMapAvail.itemMH = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemAV == "AVAILABLE"){		
		if(!checkUserModule("GIPIS019")){
			objRoadMapAvail.itemAV = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemAC == "AVAILABLE"){		
		if(!checkUserModule("GIPIS012")){
			objRoadMapAvail.itemAC = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.itemOthers == "AVAILABLE"){		
		if(!checkUserModule("GIPIS157")){
			objRoadMapAvail.itemOthers = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.peril == "AVAILABLE"){		
		if(!checkUserModule("GIPIS038")){
			objRoadMapAvail.peril = "RESTRICTED";
		};
	}
	if(objRoadMapAvail.warrClause == "AVAILABLE"){
		var moduleName = isPack == "Y" ? "GIPIS024A" : "GIPIS024";
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.warrClause = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.discSur == "AVAILABLE"){		

		if(!checkUserModule("GIPIS143")){
			objRoadMapAvail.discSur = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.grpItem == "AVAILABLE"){		
		if(!checkUserModule("GIPIS025")){
			objRoadMapAvail.grpItem = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.billPrem == "AVAILABLE"){		
		var moduleName = lineCd == "SU" ? "GIPIS017B" : "GIPIS025";
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.billPrem = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.invComm == "AVAILABLE"){		
		var moduleName = lineCd == "SU" ? "GIPIS160" : "GIPIS085";
		if(!checkUserModule(moduleName)){
			objRoadMapAvail.invComm = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.coInsurance == "AVAILABLE"){		
		if(!checkUserModule("GIPIS153")){
			objRoadMapAvail.coInsurance = "RESTRICTED";
			objRoadMapAvail.coInsurer = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.leadPol == "AVAILABLE"){		
		if(!checkUserModule("GIPIS154")){
			objRoadMapAvail.leadPol = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.setupGrp == "AVAILABLE"){		
		if(!checkUserModule("GIUWS001")){
			objRoadMapAvail.setupGrp = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.perilDist == "AVAILABLE"){		
		if(!checkUserModule("GIUWS003")){
			objRoadMapAvail.perilDist = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.oneRiskDist == "AVAILABLE"){		
		if(!checkUserModule("GIUWS004")){
			objRoadMapAvail.oneRiskDist = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.distGrp == "AVAILABLE"){		
		if(!checkUserModule("GIUWS013")){
			objRoadMapAvail.distGrp = "RESTRICTED";
		};
	}

	if(objRoadMapAvail.distPeril == "AVAILABLE"){		
		if(!checkUserModule("GIUWS012")){
			objRoadMapAvail.distPeril = "RESTRICTED";
		};
	}
	
	getExactLocation(currentModule, isPack);
	
	if(isPack == "Y"){
		initPackRoadMap("roadmapCanvasLayer");
	}else{
		initRoadmap("roadmapCanvasLayer1");
	}
}