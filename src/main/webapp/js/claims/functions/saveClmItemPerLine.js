/**
 * Save claim item info per line code
 * 
 * @author Niknok Orio
 * @param
 */
function saveClmItemPerLine(){
	try{
		var ok = true;
	 	var addedRows 	 = itemGrid.getNewRowsAdded();
		var modifiedRows = itemGrid.getModifiedRows();
		var delRows  	 = itemGrid.getDeletedRows();
		var addedPerilRows	 	= [];
		var modifiedPerilRows 	= [];
		var delPerilRows		= [];
		var addedBeneficiaryRows = [];
		var delBeneficiaryRows  = [];
		var addedPersonnelRows = [];
		var delPersonnelRows = [];
		
		if (nvl(perilGrid,null) instanceof MyTableGrid){
			addedPerilRows 	 	= perilGrid.getNewRowsAdded();
			modifiedPerilRows 	= perilGrid.getModifiedRows();
			delPerilRows  	 	= perilGrid.getDeletedRows();
		}
		
		if (nvl(personnelGrid,null) instanceof MyTableGrid){
			addedPersonnelRows 	 	= personnelGrid.getNewRowsAdded();
			delPersonnelRows  	 	= personnelGrid.getDeletedRows();
		}
		
		if (objCLMItem.benCount == 1){
			addedBeneficiaryRows = objCLMItem.newBeneficiary;
			if (nvl(beneficiaryGrid, null) instanceof MyTableGrid){
				addedBeneficiaryRows = beneficiaryGrid.getNewRowsAdded();
				delBeneficiaryRows	 = beneficiaryGrid.getDeletedRows(); 
			}
		}else{
			if (nvl(beneficiaryGrid, null) instanceof MyTableGrid){
				addedBeneficiaryRows = beneficiaryGrid.getNewRowsAdded();
				delBeneficiaryRows	 = beneficiaryGrid.getDeletedRows(); 
			}
		}
		
		var objParameters = new Object();
		objParameters.itemDelRows = delRows;
		objParameters.itemSetRows = addedRows.concat(modifiedRows);
		objParameters.perilDelRows = delPerilRows;
		objParameters.perilSetRows = addedPerilRows.concat(modifiedPerilRows);
		objParameters.beneficiarySetRows = addedBeneficiaryRows;
		objParameters.beneficiaryDelRows = delBeneficiaryRows;
		objParameters.personnelDelRows = delPersonnelRows;
		objParameters.personnelSetRows = addedPersonnelRows;
		
		var url = "";
		var groupedItemNo = 0;
		if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI || objCLMGlobal.menuLineCd == objLineCds.FI){ 
			url = "/GICLFireDtlController?action=saveClmItemFire";
		}else if(objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC){ // Added by Irwin 09.23.11
			url = "/GICLMotorCarDtlController?action=saveClmItemMotorCar";
		}else if(objCLMGlobal.lineCd == "EN" || objCLMGlobal.lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN) {
			url = "/GICLEngineeringDtlController?action=saveClmItemEngineering";
		}else if(objCLMGlobal.lineCd == "MN" || objCLMGlobal.lineCd == objLineCds.MN || objCLMGlobal.menuLineCd == objLineCds.MN) {// Added by  Irwin 10.4.11
			url = "/GICLCargoDtlController?action=saveClmItemMarineCargo";
		}else if(objCLMGlobal.lineCd == "AV" || objCLMGlobal.lineCd == objLineCds.AV || objCLMGlobal.menuLineCd == objLineCds.AV) {//Added by Irwin 10.11.11
			url = "/GICLAviationDtlController?action=saveClmItemAviation";
		}else if(objCLMGlobal.lineCd == "CA" || objCLMGlobal.lineCd == objLineCds.CA  || objCLMGlobal.menuLineCd == objLineCds.CA || objCLMGlobal.lineCd == "LI" || objCLMGlobal.lineCd == objLineCds.LI){ //added by steven 10/30/2012 // Added by Rey 10.12.2011
			url = "/GICLCasualtyDtlController?action=saveClmItemCasualty";
			groupedItemNo = nvl($F("txtGrpCd"), 0);
		}else if(objCLMGlobal.lineCd == "MH" || objCLMGlobal.lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){//Added by Rey 12.07.2011
			url = "/GICLMarineHullDtlController?action=saveClmItemMarineHull";
		}else if(objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AH || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.lineCd == "AH"  || objCLMGlobal.menuLineCd == "AC"){
			url = "/GICLAccidentDtlController?action=saveClmItemAccident";
			groupedItemNo = nvl($F("txtGrpItemNo"), 0);
		}
		var strParameters = JSON.stringify(objParameters);
		
		for (var i=0; i<addedPerilRows.length; i++){ //added by carlo SR-5900 01-06-2017 start
			 var checkShrPercentage = checkSharePercentage(objCLMGlobal.claimId, JSON.stringify(addedPerilRows[i].perilCd), JSON.stringify(addedPerilRows[i].itemNo));
		}
		
		if (checkShrPercentage == "Y"){
			showMessageBox("Please check underwriting invoice commission.", "E");
			ok = false;
		}else{ //end 5900
			new Ajax.Request(contextPath+url,{
				method: "POST",
				parameters:{
					claimId: 	objCLMGlobal.claimId,
					lineCd: 	objCLMGlobal.lineCd,
					sublineCd: 	objCLMGlobal.sublineCd,
					polIssCd: 	objCLMGlobal.policyIssueCode,
					issueYy: 	objCLMGlobal.issueYy,
					polSeqNo: 	objCLMGlobal.policySequenceNo,
					renewNo: 	objCLMGlobal.renewNo,
					polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
					expiryDate: objCLMGlobal.strExpiryDate2,
					lossDate: 	objCLMGlobal.strLossDate2,
					groupedItemNo : groupedItemNo,
					parameters: strParameters
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);
						if (res.message == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "S");
							changeTag = 0;
							ok = true;
						}else{
							showMessageBox(response.responseText, "E");
							ok = false;
						}
					}else{
						showMessageBox(response.responseText, "E");
						ok = false;
					}
				}	 
			});	
			return ok;
		}
	}catch(e){
		showErrorMessage("saveClmItemPerLine", e);
	}
}