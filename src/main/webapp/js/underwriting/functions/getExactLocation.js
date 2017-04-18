/**
 * 
 * @param moduleId
 * @param isPack
 */
function getExactLocation(moduleId, isPack){
  var btnId = "";
  if (moduleId == null) {
	 moduleId = "GIPIS001";
  }
     
  if (moduleId == "GIPIS001" || moduleId == "GIPIS058" || moduleId == "GIPIS001A" || moduleId == "GIPIS058A") {
	 btnId = "rmParlist";
	 objRoadMapAvail.parlist = "CURRENT";
  }else if(moduleId == "GIPIS002" || moduleId == "GIPIS031" || moduleId == "GIPIS002A" || moduleId == "GIPIS031A") {
	 btnId = "rmBasicInfo";
	 objRoadMapAvail.basicInfo = "CURRENT";
  }else if(moduleId == "GIPIS017") {
  	 btnId = "rmBondBasicInfo";
  	 objRoadMapAvail.bondBasicInfo = "CURRENT";
  }else if(moduleId == "GIPIS045"){
  	 btnId = "rmEngInfo";
  	 objRoadMapAvail.engInfo = "CURRENT";
  }else if(moduleId == "GIPIS093") {
  	 btnId = "rmLineSubCov";
  	 objRoadMapAvail.lineSubCov = "CURRENT";
  }else if(moduleId == "GIPIS005") {
  	 btnId = "rmMNLiab";
  	 objRoadMapAvail.cargoLiab = "CURRENT";
  }else if(moduleId == "GIPIS007") {
  	 btnId = "rmCarrierInfo";
  	 objRoadMapAvail.carrierInfo = "CURRENT";
  }else if(moduleId == "GIPIS089") {
  	 btnId = "rmBankColl";
  	 objRoadMapAvail.bankColl = "CURRENT";
  }else if(moduleId == "GIPIS029") {
  	 btnId = "rmReqDocs";
  	 objRoadMapAvail.reqDocs = "CURRENT";
  }else if(moduleId == "GIRIS005") {
  	 btnId = "rmInitAcc";
  	 objRoadMapAvail.initAcc = "CURRENT";
  }else if(moduleId == "GIPIS018") {
  	 btnId = "rmCollTrans";
  	 objRoadMapAvail.collTrans = "CURRENT";
  }else if(moduleId == "GIPIS172") {
  	 btnId = "rmLimLiab";
  	 objRoadMapAvail.limLiab = "CURRENT";
  }else if(moduleId == "GIPIS095") {
  	 btnId = "rmPackPolItems";
  	 objRoadMapAvail.packPolItems = "CURRENT";
  }else if(moduleId == "GIPIS010") {
  	 btnId = isPack == "Y" ? "rmMCItem" : "rmItems";
  	 isPack == "Y" ? objRoadMapAvail.itemMN = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS003") {
	 btnId = isPack == "Y" ? "rmFIItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemFI = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS004") {
	 btnId = isPack == "Y" ? "rmENItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemEN = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS006") {
	 btnId = isPack == "Y" ? "rmMNItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemMN = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS009") {
	 btnId = isPack == "Y" ? "rmMHItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemMH = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS011") {
	 btnId = isPack == "Y" ? "rmCAItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemCA = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS019") {
	 btnId = isPack == "Y" ? "rmAVItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemAV = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS012") {
	 btnId = isPack == "Y" ? "rmACItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemAC = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS157") {
	 btnId = isPack == "Y" ? "rmOthersItem" : "rmItems";
	 isPack == "Y" ? objRoadMapAvail.itemOthers = "CURRENT" : objRoadMapAvail.itemInfo = "CURRENT";
  }else if(moduleId == "GIPIS038") {
  	 btnId = "rmPeril";
  	 objRoadMapAvail.peril = "CURRENT";
  }else if(moduleId == "GIPIS024" || moduleId == "GIPIS024A" || moduleId == "GIPIS035" || moduleId == "GIPIS035A") {
  	 btnId = "rmWarrClause";
  	 objRoadMapAvail.warrClause = "CURRENT";
  }else if(moduleId == "GIPIS143") {
  	 btnId = "rmDiscSur";
  	 objRoadMapAvail.discSur = "CURRENT";
  }else if(moduleId == "GIPIS025") {
  	 btnId = "rmGrpItem";
  	 objRoadMapAvail.grpItem = "CURRENT";
  }else if(moduleId == "GIPIS017B" || moduleId == "GIPIS026") {
  	 btnId = "rmBillPrem";
  	 objRoadMapAvail.billPrem = "CURRENT";
  }else if(moduleId == "GIPIS160" || moduleId == "GIPIS085") {
  	 btnId = "rmInvComm"; 
  	 objRoadMapAvail.invComm = "CURRENT";
  }else if(moduleId == "GIPIS153") {
  	 btnId = "rmCoInsurer";
  	 objRoadMapAvail.coInsurer = "CURRENT";
  }else if(moduleId == "GIPIS154") {
  	 btnId = "rmLeadPol";
  	 objRoadMapAvail.leadPol = "CURRENT";
  }else if(moduleId == "GIUWS001") {
  	 btnId = "rmSetupGrp";
  	 objRoadMapAvail.setupGrp = "CURRENT";
  }else if(moduleId == "GIUWS003") {
  	 btnId = "rmPerilDist";
  	 objRoadMapAvail.perilDist = "CURRENT";
  }else if(moduleId == "GIUWS004") {
  	 btnId = "rmOneRiskDist";
  	 objRoadMapAvail.oneRiskDist = "CURRENT";
  }else if(moduleId == "GIPIS900") {
  	 btnId = "rmPrint";
  	 objRoadMapAvail.print = "CURRENT";
  }else if(moduleId == "GIPIS055") {
  	 btnId = "rmPost";
  	 objRoadMapAvail.post = "CURRENT";
  }else if(moduleId == "GIUWS013") {
  	 btnId = "rmDist";
  	 objRoadMapAvail.dist= "CURRENT";
  }
}