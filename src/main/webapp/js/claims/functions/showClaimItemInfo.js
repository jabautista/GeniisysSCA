/**
 * Getting claim item information
 * 
 * @author Niknok Orio
 * 
 */
/**
 * modified by andrew - 04.23.2012 - added conditions to consider the menuLineCd
 */
function showClaimItemInfo(){
	var claimId = objCLMGlobal.claimId;
	var lineCd = objCLMGlobal.lineCd;
	var linePage = "";
	var noticeMsg = "Item Information";
	objCLMGlobal.driverInfoPopulateSw = "N"; // Added by J. Diago 10.11.2013 for driver block sw of populating MC Driver Info.
	objCLMGlobal.currMcItem = null; // Added by J. Diago 10.11.2013 holds temp row of item grid, used to repopulate item info with driver info.
	if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.menuLineCd == "FI" || lineCd == objLineCds.FI) {	
		linePage = "/GICLFireDtlController?action=getFireDtl";
		noticeMsg = "Fire Item Information";		
	}else if(objCLMGlobal.lineCd == "MC" || objCLMGlobal.menuLineCd == "MC" || lineCd == objLineCds.MC) {
		linePage = "/GICLMotorCarDtlController?action=getMotorCarItemDtl";
		noticeMsg = "Motorcar Item Information";
	}else if(objCLMGlobal.lineCd == "CA" || objCLMGlobal.menuLineCd == "CA" || lineCd == objLineCds.CA || objCLMGlobal.lineCd == "LI" || lineCd == objLineCds.LI){//added by steven 10/30/2012
		linePage = "/GICLCasualtyDtlController?action=getCasualtyDtl";
		noticeMsg = "Casualty Item Information";
	}else if(objCLMGlobal.lineCd == "EN" || objCLMGlobal.menuLineCd == "EN" || lineCd == objLineCds.EN) {
		linePage = "/GICLEngineeringDtlController?action=getEngineeringDtl";
		noticeMsg = "Engineering Item Information";
	}else if(objCLMGlobal.lineCd == "MN" || objCLMGlobal.menuLineCd == "MN" || lineCd == objLineCds.MN) {
		linePage = "/GICLCargoDtlController?action=getCargoDtl";
		noticeMsg = "Marine Cargo Item Information";
	}else if(objCLMGlobal.lineCd == "AV" || objCLMGlobal.menuLineCd == "AV" || lineCd == objLineCds.AV) {
		linePage = "/GICLAviationDtlController?action=getAviationItemDtl";
		noticeMsg = "Aviation Item Information";
	}else if(objCLMGlobal.lineCd == "MH" || objCLMGlobal.menuLineCd == "MH" || lineCd == objLineCds.MH){//Rey 11-28-2011
		linePage = "/GICLMarineHullDtlController?action=getMarineHullDtl";
		noticeMsg = "Marine Hull Item Information"; 
	}else if(objCLMGlobal.lineCd == 'PA' || objCLMGlobal.menuLineCd == "AC"|| lineCd == objLineCds.AC){
		linePage = "/GICLAccidentDtlController?action=getAccidentItemDtl";
		noticeMsg = "Personal Accident Item Information";
	}else{
		showMessageBox("Page cannot be displayed right now.", "E");
		return false;
	}
	
	new Ajax.Updater("basicInformationMainDiv", contextPath+linePage,{
		parameters : {
			claimId : claimId,
			ajax: '1'
		},
		asynchronous: false,
		evalScripts: true,
		onCreate : function() {
			showNotice("Getting "+noticeMsg+", please wait...");
		},
		onComplete: function (response){
			if (checkErrorOnResponse(response)) {
				updateClaimParameters(); // added because some properties became null in basic info. - irwin - 04.30.2012
				clearAllObjOnItem();
				getClaimsMenuProperties(true);
				objGIPIS100.callingForm = getClaimItemModuleId(objCLMGlobal.lineCd); // andrew - 04.23.2012 - for view policy information
			}	
		}
	});		
}