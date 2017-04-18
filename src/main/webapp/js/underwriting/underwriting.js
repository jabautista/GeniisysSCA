// UNDERWRITING GLOBAL VARIABLES
var updater;  //Attach Media
var renewalIsChanged; //tag if renewal/replacement detail is modified.
var assuredListingFromPAR; // PAR creation tweak
var masterDetail = false;	// mark jm 10.14.2010 for item master-detail changes
var selectedIndex = -1; // added by: nica 02.16.2011 for par and package par listings
var creationFlag = false; // added by: nica 02.17.2011 assign value if PAR is from creation  
var overideAssdNo; //addded by bonok: 01.03.2012 for override overlay
var parentAssuredDisable = 1; //added by bonok: 01.03.2012 for edit assured override and view only
var parCtr = 0; // added by: Patrick Cruz 01.04.2012 checks if page is policy or endt
var lastAssdName; // moved from assured/basicInformation
var showBondSeqNo; // added by: bonok 07.12.2012

//SR 22834 JMM
var objAssdNo = ""; 
var validatePolNo2 = "";
var objAssdName = ""; 
var postValidate = ""; 
var globalAssdNo = "";
var globalAddress1 = "";
var globalAddress2 = "";
var globalAddress3 = "";
var globalRiCd = "";
var globalPolNo = "";
var notEqualRiCd = false;
var validateBond = "";
//END SR 22834
var objUW = new Object(); //object container for UNDERWRITING - jerome orio 11.04.2010
var objUWGlobal = new Object(); // andrew - 10.07.2010 - object for underwriting global parameter
var objUWParList = new Object(); // nica 11.19.2010 - object for par Listing
var objGIPIWPolbas = new Object(); //bryan 12.13.2010 - object for GIPIWPolbas
var objGIPIS100 = {}; // andrew 04.20.2012
var objCurrSelecteQuote = null;
var objGiexs006 = new Object();
objUWGlobal.callingForm = null; //added by steven 01.28.2014

//global variable for GIEXS006 :: by bonok
//var giexs006Report; //04.24.2012 :: stores selected report 
objUWGlobal.giexs006Report; //04.24.2012 :: stores selected report
var giexs006ReportName = ""; //04.25.2012 :: stores the name of the report
var dspPolicyId = "";
var dspPackPolicyId = "";

var objGiiss207 = new Object();//gzelle 12.13.2012 - object for posting limit maintenance

var objG035 = new Object();  //kris 05.23.2013
objG035.currDocList = null;
objG035.lineCd = null;
objG035.sublineCd = null;

var objGipis165 = new Object();
objGipis165.bondSw;
objGipis165.cancellationFlag;

objUWGlobal.module = null;/////////////////////

objUWGlobal.lineCd = null;
objUWGlobal.menuLineCd = null;
// added by: nica 11.19.2010
objUWGlobal.lineName 	= null;
objUWGlobal.parId 		= null;
objUWGlobal.packParId 	= null;
objUWGlobal.issCd 		= null;
objUWGlobal.parStatus 	= null;
objUWGlobal.parNo 		= null;
objUWGlobal.assdNo 		= null;
objUWGlobal.assdName 	= null;
objUWGlobal.parType 	= null;
objUWGlobal.parYy 		= null;
objUWGlobal.remarks 	= null;
objUWGlobal.underwriter = null;
objUWGlobal.packSublineCd = null;
objUWGlobal.packLineCd 	= null;
objUWGlobal.packPolFlag = null;
objUWGlobal.coInsurance = null;
objUWGlobal.coInsSw = null;
objUWGlobal.previousModule = null;

var objGIPIS130 = new Object;
objGIPIS130.details = null;
objGIPIS130.distNo = null;
objGIPIS130.distSeqNo = null;

var objGIUWS015 = new Object;	// shan 08.06.2014
objGIUWS015.filterByParam = false;
objGIUWS015.tempTaggedRecords = [];
objGIUWS015.tempUntaggedRecords = [];

/**
 * @author rey
 * global inceptDate
 */
objUWGlobal.inceptDate  = null;

/**added by BJGA 01.13.2011 to empty attributes of UWParList object**/
objUWParList.parId 		= null;
objUWParList.lineCd 	= null;
objUWParList.lineName 	= null;
objUWParList.issCd 		= null;
objUWParList.parYy 		= null;
objUWParList.quoteSeqNo = null;
objUWParList.parType 	= null;
objUWParList.assignSw 	= null;
objUWParList.parStatus 	= null;
objUWParList.assdNo 	= null;
objUWParList.remarks 	= null;
objUWParList.assdName 	= null;
objUWParList.underwriter = null;
objUWParList.quoteId 	= null;
objUWParList.parSeqNo 	= null;
objUWParList.parNo 		= null;
objUWParList.packParId 	= null;
objUWParList.packParNo 	= null;
objUWParList.sublineName = null;
objUWParList.packPolFlag = null;
objUWParList.renewNo 	= null;
objUWParList.parSeqNoC 	= null;
objUWParList.status 	= null;
objUWParList.discExists = null;
objUWParList.polFlag 	= null;
objUWParList.sublineCd 	= null;
objUWParList.polSeqNo 	= null;
objUWParList.issueYy 	= null;
objUWParList.opFlag 	= null;
objUWParList.address1 	= null;
objUWParList.address2 	= null;
objUWParList.address3 	= null;
objUWParList.endtPolicyNo = null;

/**added by BJGA 01.13.2011 to empty attributes of objGIPIWPolbas object**/
objGIPIWPolbas.parId = null;
objGIPIWPolbas.lineCd = null;
objGIPIWPolbas.invoiceSw = null;
objGIPIWPolbas.sublineCd = null;
objGIPIWPolbas.polFlag = null;
objGIPIWPolbas.manualRenewNo = null;
objGIPIWPolbas.typeCd = null;
objGIPIWPolbas.address1 = null;
objGIPIWPolbas.address2 = null;
objGIPIWPolbas.address3 = null;
objGIPIWPolbas.credBranch = null;
objGIPIWPolbas.issCd = null;
objGIPIWPolbas.assdNo = null;
objGIPIWPolbas.acctOfCd = null;
objGIPIWPolbas.issueDate = null;
objGIPIWPolbas.placeCd = null;
objGIPIWPolbas.riskTag = null;
objGIPIWPolbas.refPolNo = null;
objGIPIWPolbas.industryCd = null;
objGIPIWPolbas.regionCd = null;
objGIPIWPolbas.quotationPrintedSw = null;
objGIPIWPolbas.covernotePrintedSw = null;
objGIPIWPolbas.packPolFlag = null;
objGIPIWPolbas.autoRenewFlag = null;
objGIPIWPolbas.foreignAccSw = null;
objGIPIWPolbas.regPolicySw = null;
objGIPIWPolbas.premWarrTag = null;
objGIPIWPolbas.premWarrDays = null;
objGIPIWPolbas.fleetPrintTag = null;
objGIPIWPolbas.withTariffSw = null;
objGIPIWPolbas.provPremTag = null;
objGIPIWPolbas.provPremPct = null;
objGIPIWPolbas.inceptDate = null;
objGIPIWPolbas.inceptTag = null;
objGIPIWPolbas.expiryDate = null;
objGIPIWPolbas.expiryTag = null;
objGIPIWPolbas.prorateFlag = null; // condition
objGIPIWPolbas.compSw = null; // +1 -1 ordinary
objGIPIWPolbas.shortRtPercent = null; // for short rate
objGIPIWPolbas.bookingYear = null;
objGIPIWPolbas.bookingMth = null;
objGIPIWPolbas.coInsuranceSw = null;
objGIPIWPolbas.takeupTerm = null;
objGIPIWPolbas.dspAssdName = null;
objGIPIWPolbas.acctOfName = null;
objGIPIWPolbas.designation = null;
objGIPIWPolbas.userId = null;
objGIPIWPolbas.msgAlert = null;
objGIPIWPolbas.renewNo = null;
objGIPIWPolbas.refOpenPolNo = null;
objGIPIWPolbas.samePolnoSw = null;
objGIPIWPolbas.endtYy = null;
objGIPIWPolbas.endtSeqNo = null;
objGIPIWPolbas.updateIssueDate = null;
objGIPIWPolbas.labelTag = null;
objGIPIWPolbas.surchargeSw = null;
objGIPIWPolbas.discountSw = null;
objGIPIWPolbas.surveyAgentCd = null;
objGIPIWPolbas.settlingAgentCd = null;
objGIPIWPolbas.issueYy = null;
objGIPIWPolbas.polSeqNo = null;
objGIPIWPolbas.packParId = null;
objGIPIWPolbas.mortgName = null;
objGIPIWPolbas.validateTag = null;
objGIPIWPolbas.backStat = null;
objGIPIWPolbas.effDate = null;
objGIPIWPolbas.endtExpiryDate = null;
objGIPIWPolbas.cancelType = null;
objGIPIWPolbas.endtExpiryTag = null;
objGIPIWPolbas.oldAssdNo = null;
objGIPIWPolbas.endtIssCd = null;
objGIPIWPolbas.acctOfCdSw = null;
objGIPIWPolbas.oldAddress1 = null;
objGIPIWPolbas.oldAddress2 = null;
objGIPIWPolbas.oldAddress3 = null;
objGIPIWPolbas.annTsiAmt = null;
objGIPIWPolbas.premAmt = null;
objGIPIWPolbas.tsiAmt = null;
objGIPIWPolbas.annPremAmt = null;	
objGIPIWPolbas.planCd = null;
objGIPIWPolbas.planChTag = null;
objGIPIWPolbas.planSw = null;
objGIPIWPolbas.companyCd = null;
objGIPIWPolbas.employeeCd = null;
objGIPIWPolbas.bankRefNo = null;
objGIPIWPolbas.bancTypeCd = null;
objGIPIWPolbas.bancassuranceSw = null;
objGIPIWPolbas.areaCd = null;
objGIPIWPolbas.branchCd = null;
objGIPIWPolbas.managerCd = null;

var parItemModuleId = new Object();
parItemModuleId.MOTOR_CAR 	= "GIPIS010";
parItemModuleId.FIRE 		= "GIPIS003";
parItemModuleId.ENGINEERING = "GIPIS004";
parItemModuleId.CASUALTY	= "GIPIS011";
parItemModuleId.ACCIDENT 	= "GIPIS012";
parItemModuleId.AVIATION	= "GIPIS019";
parItemModuleId.MARINE_HULL = "GIPIS009";
parItemModuleId.CARGO 		= "GIPIS006";

var endtItemModuleId = new Object();
endtItemModuleId.MOTOR_CAR 	= "GIPIS060";
endtItemModuleId.FIRE 		= "GIPIS039";
endtItemModuleId.ENGINEERING = "GIPIS067";
endtItemModuleId.CASUALTY	= "GIPIS061";
endtItemModuleId.ACCIDENT 	= "GIPIS065";
endtItemModuleId.AVIATION	= "GIPIS082";
endtItemModuleId.MARINE_HULL = "GIPIS081";
endtItemModuleId.CARGO 		= "GIPIS068";

var objGIEXExpiry = new Object();  //robert 11.14.2011 - object for GIEXExpiry
objGIEXExpiry.intmNo = null;
objGIEXExpiry.intmName = null;
objGIEXExpiry.claimSw = null;
objGIEXExpiry.balanceSw = null;
objGIEXExpiry.rangeType = null;
objGIEXExpiry.range = null;
objGIEXExpiry.fmDate = null;
objGIEXExpiry.toDate = null;
objGIEXExpiry.fmMon = null;
objGIEXExpiry.fmYear = null;
objGIEXExpiry.toMon = null;
objGIEXExpiry.toYear = null;
objGIEXExpiry.lineCd = null;
objGIEXExpiry.sublineCd = null;
objGIEXExpiry.issCd = null;
objGIEXExpiry.issueYy= null;
objGIEXExpiry.polSeqNo = null;
objGIEXExpiry.renewNo = null;
var objItmPerl  = new Object(); 
var objItmPerlGrp  = new Object();

var objGIEXItmPeril = new Array();//new Object(); //joanne 01.20.2014, object for GIEXItmPeril

var objLineCds = new Object();
var objDeductibleListing = new Object();	//moved from deductible.jsp
var objPolbasic = new Object(); 

var addedENPrincipals;
var delENPrincipals;
var objPrintAddtl;		//additional parameters for printing

var overlayEndtList;
var packRiTag = null;

var objGIUTS012 = new Object();
objGIUTS012.exitTag = "N";

var ojbMiniReminder = new Object();
ojbMiniReminder.parId = 0;
ojbMiniReminder.claimId= 0;

var objGIPIS901 = new Object();		//shan 09.03.2013
objGIPIS901.extractId = null;
objGIPIS901.refItem = "FOLDER.STATISTICAL";
objGIPIS901.refItem2 = "OTHERS.MOTOR_STAT";
objGIPIS901.currYear = new Date().getFullYear();
objGIPIS901.asOfSw = "N";
objGIPIS901.rangeValue = 0;
objGIPIS901.incEndt = "N";
objGIPIS901.incExp = "Y";
objGIPIS901.firePerilType = "B";
objGIPIS901.chkboxStat = [];
objGIPIS901.extractPrevParam = [];
objGIPIS901.zone = null;
objGIPIS901.printSw = " ";
objGIPIS901.commitAccumDistShare = null;
objGIPIS901.tableName = null;
objGIPIS901.columnName = null;
objGIPIS901.lineCdFi = null;
objGIPIS901.lineCdMc = null;
objGIPIS901.fireSelectedRow = null;
objGIPIS901.commAccumSw = null;
objGIPIS901.statusSw = "Y";
objGIPIS901.changeTagDetail = 0;
objGIPIS901.riskObjParams = new Object();
objGIPIS901.riskObjParams.setRows = [];
objGIPIS901.riskObjParams.delRows = [];

var objInvoiceInfo = new Object();

var objGIPIS155 = new Object();
objGIPIS155.policyId = null;
objGIPIS155.itemNo = null;
objGIPIS155.blockId = null;

var objGIISS090 = new Object();

objGipis130 = new Object();
objGipis130.lineCd = "";
objGipis130.sublineCd = "";
objGipis130.issCd = "";
objGipis130.issueYy = "";
objGipis130.polSeqNo = ""; 
objGipis130.renewNo = "";
objGipis130.callSw = "";
objGipis130.withQuery = "";
objGipis130.credBranch = "";
objGipis130.filterLineCd = "";
objGipis130.distFlag = "";
objGipis130.dateOpt = "";
objGipis130.dateParams = "";
objGipis130.dateTag = "";
objGipis130.dateAsOf = "";
objGipis130.dateFrom = "";
objGipis130.dateTo = "";

var objGIPIS199 = new Object();

var objGIISS065 = {}; //Added by Jerome 07.25.2016 SR 5552

var objGIPIS200 = new Object(); //fons 09.16.2013
objGIPIS200.fromDate = "";
objGIPIS200.toDate = "";
objGIPIS200.month = "";
objGIPIS200.year = "";
objGIPIS200.lineCd="";
objGIPIS200.lineName="";
objGIPIS200.sublineCd="";
objGIPIS200.sublineName="";
objGIPIS200.credIss = "S";
objGIPIS200.cred = "Issue Code";
objGIPIS200.issCd = "";
objGIPIS200.issName = "";
objGIPIS200.issueYy = "";
objGIPIS200.intmNo = "";
objGIPIS200.intmName="";
objGIPIS200.paramDate = 2;
objGIPIS200.regPolicySw = "N";
objGIPIS200.distFlag = "B";
objGIPIS200.dspNoOfPolicies = "0";	
objGIPIS200.dspTotalPrem = "0.00";	
objGIPIS200.dspTotalTsi = "0.00";	
objGIPIS200.dspTotalTax = "0.00";	
objGIPIS200.dspTotalCommission = "0.00";


objUW.GIISS203 = new Object();
objUW.GIISS203.intmTypes = "";
objUW.GIISS203.setWhere = "";

objUW.GIISS076 = new Object();
objUW.GIISS076.giisIntm = [];
objUW.GIISS076.vDefault = null;
objUW.GIISS076.vDefaultNo = null;

var objGiris007 = new Object();
objGiris007.shareType = null;
objGiris007.lineCd = "";
objGiris007.trtyYy = "";
objGiris007.shareCd = "";
objGiris007.layerNo = "";
objGiris007.proportionalTreaty = "";

/* created by Cris on 04.26.2010
 * for endorsement Par 
*/
/*
function updateEndtParParameters(){
	new Ajax.Updater("uwEndtParParametersDiv", contextPath+"/GIPIPARListController",{
		method: "GET",
		asynchronous: false,
		parameters: {action: "setEndtParParameters",
					globalEndtParId: $F("globalEndtParId")}
					
	});
	
}*/
//end Cris 04.26.2010

/*function showItemGrpSummaryModal(){
	try{
		Modalbox.show(contextPath+"/GIPIWinvoiceController", {
			title: "Item Group Summary",
			width: 1000,
			params: {globalParId: $F("globalParId"),
					 globalAssdNo: $F("globalAssdNo"),
					 action: "showItemGroupSummary"
			}
		});
	} catch(e){
		showErrorMessage("showItemGrpSummaryModal", e);
		//showMessageBox(e.message);
	}
}
*/

/*function showCreditCardInfoModal(){
	try{
		Modalbox.show(contextPath+"/GIPIWinvoiceController", {
			title: "Credit Card Information",
			width: 450,
			params: {globalParId: $F("globalParId"),
				 	// globalAssdNo: $F("globalAssdNo"),
					 action: "showCreditCardInfo"
				}
		});
	} catch (e){
		showErrorMessage("showCreditCardInfoModal", e);
		//showMessageBox(e.message);
	}
}*/

//function showInstallmentModal(takeupSeqNo){
//	try {
//		Modalbox.show(contextPath+"/GIPIWInstallmentController", {
//			title: "Payment Schedule",
//			width: 1000,
//			params: {globalParId:     $F("globalParId"),
//					 tsNo:				takeupSeqNo,
//					 action:		  "showInstallment"
//			 }
//		});
//	} catch (e){
//		showErrorMessage("showInstallmentModal", e);
//		//showMessageBox(e.message);
//	}
//	
//}

/*function refreshTaxList(takeupSeqNo){
	try	{
		new Ajax.Updater("taxInformationDiv", contextPath+"/GIPIWinvTaxController", {
			method: "GET",
			parameters: {
			//	lineCd: "FI", //$F("lineCd"), - hard coded line cd
			//	parId: "65", //$F("parId"), - hard coded par id
				action: "refreshTaxList",
				takeupSeqNo: takeupSeqNo,
				ajax: "1"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showLoading("taxInformationDiv", "Loading list, please wait...", "30px;"),
			onComplete: function () {
			//	checkTableIfEmpty("row", "taxInformationDiv");
			}
		});
	} catch (e)	{
		showErrorMessage("refreshTaxList", e);
	}	*/

var overlayPolicyNumber = null; // andrew - 05.06.2011 - used for policy number to be endorsed

var overlayPost;  

/**
 * @deprecated
 * @returns {Boolean}
 */
function showEndtItemInfo(){
	var parId	 	= "";
	var lineCd	 	= "";
	var sublineCd	= "";
	var linePage 	= "";
	var triggerForm;
	var formName;
	var parStatus = "";
	
	updateParParameters();
	
	parStatus = $F("globalParStatus");
	if (parStatus.blank() || parStatus == "0") {
		showMessageBox("Please select a policy first.", imgMessage.ERROR);
		return false;
	}
		
	if(parStatus < 3){
		showMessageBox("Page is not accessible due to PAR Status.", imgMessage.ERROR);
		return false;
	}	
	
	parId = $F("globalParId");
	lineCd = $F("globalLineCd");
	
	/* 	
	try{
		$$("form").each(
			function(frm){
				var parIdElem = frm["globalParId"];
				if(parIdElem != null){
					triggerForm = frm;
					formName = triggerForm.getAttribute("id");
					//try{
					//	sublineCd = $F("sublineCd");
					//} catch(a){
					//	var form = $("basicInformationDiv");
					//	var subline = form["sublineCd"];
					//	sublineCd = $F(subline);
					//}
				}				
			}
		);		
	} catch(e){
		showErrorMessage("showEndtItemInfo", e);
		//showMessageBox("Page cannot be displayed right now.", imgMessage.ERROR);
		//return false;
	}
	*/
	
	if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
		linePage = "/GIPIEndtParMCItemInfoController?action=showMotorEndtItemInfo&";
	} else if(objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == objLineCds.FI){
		linePage = "/GIPIWFireItmController?action=showFireItemInfo&";
	} else if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
		linePage = "/GIPIWCargoController?action=showMarineCargoItemInfo&";	
	} else if(objUWGlobal.lineCd == objLineCds.AV || objUWGlobal.menuLineCd == objLineCds.AV){
		linePage = "/GIPIWAviationItemController?action=showAviationItemInfo&";		
	} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA){
		linePage = "/GIPIWCasualtyItemController?action=showCasualtyItemInfo&";		
	} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH){
		linePage = "/GIPIWItemVesController?action=showMarineHullItemInfo&";	
	} else if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
		linePage = "/GIPIWAccidentItemController?action=showAccidentItemInfo&";
	} else if(objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == objLineCds.EN){
		linePage = "/GIPIWEngineeringItemController?action=showENInfo&";
	} else{
		showMessageBox("Page cannot be displayed right now.", imgMessage.ERROR);
		return false;
	}
	
	Effect.Fade("mainContents", {
		duration: .001,
		beforeFinish: function ()	{
		new Ajax.Updater("mainContents", contextPath+linePage+Form.serialize("uwParParametersForm"),{//+"&parType="+parType,{
			parameters : {
				parId : parId,
				lineCd : lineCd,
				sublineCd : sublineCd
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
					var noticeMessage = "";
					if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
						noticeMessage = "Getting Motor Endt Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == objLineCds.FI){
						noticeMessage = "Getting Fire Endt Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
						noticeMessage = "Getting Marine Endt Cargo Item Info, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.AV || objUWGlobal.menuLineCd == objLineCds.AV){
						noticeMessage = "Getting Aviation Endt Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA){
						noticeMessage = "Getting Casualty Endt Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH){
						noticeMessage = "Getting Marine Hull Endt Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
						noticeMessage = "Getting Accident Endt Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == objLineCds.EN){
						noticeMessage = "Getting Engineering Endt Item Information, please wait...";
					}
					showNotice(noticeMessage);
				},
			onComplete: function(){
					hideNotice("");
					Effect.Appear($("mainContents"), {
							duration: .001,
							afterFinish: function (){
								$("parNo").focus();
							}
						});
				}
			});
		}
	});
}

/*	mark jm 05.25.10
** 	for endorsement basic information
**	used for date field validation

function checkDateFieldsForChanges(){		
	if($F("parType") == "E"){
		if($F("doi") != $F("varEffOldDte")){			
			$("recordStatus").value = "1";
			validateInceptExpiryDate("INCEPT_DATE");
			$("varEffOldDte").value = $F("doi");
		} else if($F("doe") != $F("varExpOldDte")){			
			$("recordStatus").value = "1";
			validateInceptExpiryDate("EXPIRY_DATE");
			$("varExpOldDte").value = $F("doe");			
		} else if($F("endtEffDate") != $F("varOldDateEff")){				
			$("recordStatus").value = "1";
			validateEndtEffDate();
			$("varOldDateEff").value = $F("endtEffDate");
		} else if($F("endtExpDate") != $F("varOldDateExp")){				
			$("recordStatus").value = "1";
			validateEndtExpiryDate();
			$("varOldDateExp").value = $F("endtExpDate");
		} else if($F("issueDate") != ($F("b540IssueDate")).substr(0,10)){			
			$("recordStatus").value = "1";
			validateEndtIssueDate();
			$("b540IssueDate").value = $F("issueDate");
		}
	}
}
*/
/*	mark jm 05.25.10
** 	for endorsement basic information
**	used for date field validation

function validateInceptExpiryDate(fieldName){	
		
	if($F("recordStatus") == "1" && 
			($F((fieldName == "INCEPT_DATE" ? "varEffOldDte" : "varExpOldDte")) != $F((fieldName == "INCEPT_DATE" ? "doi" : "doe")))){
		$("varAddTime").value = "0";
		showMessageBox("Please change due dates of the previous endorsement/policy", imgMessage.INFO);
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtInceptExpiryDate",{
				method : "GET",
				parameters : {					
					inceptDate : $F("doi"),
					effDate : $F("endtEffDate"),
					expiryDate : $F("doe"),
					parId : $F("globalParId"),
					lineCd : $F("globalLineCd"),
					sublineCd : $F("globalSublineCd"),
					issCd : $F("globalIssCd"),
					issueYY : $F("b540IssueYY"),
					polSeqNo : $F("b540PolSeqNo"),
					renewNo : $F("b540RenewNo"),
					fieldName : fieldName
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : showNotice("Validating date, please wait..."),
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
						var result = response.responseText.toQueryParams();
						
						if(result.msgAlert != "" && result.msgAlert != undefined){
							showMessageBox(result.msgAlert, imgMessage.WARNING);
						}
					}
				}
			});
	}	
}
*/
//function validateEndtEffDate(){	
//	if($F("prorateSw") == "1" /*&& $F("prorateFlag") != "2" */ && $F("varOldDateEff") != $F("endtEffDate")){
//		$("parProrateCancelSw").value = "Y";
//	}
//
//	if($("nbtPolFlag").checked){
//		if($F("recordStatus") == "1"){
//			new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtEffDate",{
//				method : "GET",
//				parameters : {
//					vOldDateEff : $F("varOldDateEff"),
//					parId : $F("globalParId"),
//					lineCd : $F("globalLineCd"),
//					sublineCd : $F("globalSublineCd"),
//					issCd : $F("globalIssCd"),
//					issueYY : $F("b540IssueYY"),
//					polSeqNo : $F("b540PolSeqNo"),
//					renewNo : $F("b540RenewNo"),
//					endtExpiryDate : $F("endtExpDate"),
//					compSw : $F("b540CompSw"),
//					polFlag : $F("nbtPolFlag"),
//					expChgSw : $F("varExpChgSw"),
//					vMaxEffDate : $F("varMaxEffDate"),
//					pFirstEndtSw : $F("parFirstEndtSw"),
//					vExpiryDate : $F("varExpiryDate"),
//					effDate : $F("endtEffDate"),
//					inceptDate : $F("doi"),
//					expiryDate : $F("doe"),
//					endtYY : $F("b540EndtYY"),
//					sysdateSw : $F("parSysdateSw"),
//					cgBackEndtSw : $F("globalCg$BackEndt"),
//					pBackEndtSw : $F("parBackEndtSw")
//				},
//				asynchronous : true,
//				evalScripts : true,
//				onCreate : showNotice("Validating endt effitivity date, please wait..."),
//				onComplete : function(response){
//					if (checkErrorOnResponse(response)) {
//						hideNotice("Done!");
//						//var result = response.responseText.toQueryParams();
//						//showMessage();
//					}
//				}
//			});
//		}
//	}
//}

/*	mark jm 06.10.10
** 	for endorsement basic information
**	used for date field validation

function validateEndtExpiryDate(){	
	new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtExpiryDate",{
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				recordStatus : $F("recordStatus"),
				lineCd : $F("globalLineCd"),
				sublineCd : $F("globalSublineCd"),
				expiryDate : $F("doe"),
				effDate : $F("endtEffDate"),
				endtExpiryDate : $F("endtExpDate"),
				varOldDateExp : $F("varOldDateExp"),
				compSw : $("b540CompSw").value,
				varAddTime : $F("varAddTime")					
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Validating date, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Done!");
					var result = response.responseText.toQueryParams();
					
					if(result.msgAlert != "" && result.msgAlert != undefined){
						showMessageBox(result.msgAlert, imgMessage.WARNING);
						$("endtExpDate").value = result.varOldDateExp;
					}else{
						$("varAddTime").value = result.varAddTime;
						$("prorateFlag").value = result.prorateFlag;
						$("varMplSwitch").value = result.varMplSwitch;
						$("parConfirmSw").value = result.parConfirmSw;
						//$("prorateDays").value = result.prorateDays;
					}
				}
			}
		});	
}
*/
/*	mark jm 06.11.10
** 	for endorsement basic information
**	used for date field validation

function validateEndtIssueDate(){	
	new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtIssueDate",{
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				parVarVdate : $F("parVarVdate"),
				issueDate : $F("issueDate"),
				effDate : $F("endtEffDate")				
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Validating date, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Done!");
					var result = response.responseText.toQueryParams();
					
					if(result.msgAlert != "" && result.msgAlert != undefined){
						showMessageBox(result.msgAlert, imgMessage.WARNING);						
					}else{
						$("parVarIdate").value = result.parVarIdate;						
						$("bookingMonth").selectedIndex = getIndexInSelectList("bookingMonth", result.bookingYear + " - " + result.bookingMonth);
					}
				}
			}
		});	
}
*/

// whofeih - commented because unsed - whofeih
/*function updateGipiPackQuote() {
	new Ajax.Request(contextPath+"/GIPIPackQuoteController", {
		method: "GET",
		onCreate: showNotice("Updating package quote status..."),
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
			}
		},
		parameters: {
			action: "updateGipiPackQuote",
			quoteId: $F("quoteId")
		}
	});
}*/
//whofeih

var winRoadMap;

/**
 * Shows inspection report page
 *  @author angelo
 */

var inspectionReportObj = new Object();
var giis197parameters = new Object();
var inspData1Obj = new Object();
inspectionReportObj.currentItems = new Array();
inspectionReportObj.addedItems = new Array();
inspectionReportObj.deletedItems = new Array();//Rey for the delete item
inspectionReportObj.insertedWcObjects = new Array();
inspectionReportObj.deletedWcObjects = new Array();
inspectionReportObj.otherDtls = new Object();

/**
 * Checks what overlay to display before printing
 * Module: GIEXS006 - Print Expiry Reports/Documents
 * @author Bonok
 */

var reasonSw;//DISPLAY_REASON_FOR_NR
var renewSw;//DISPLAY_REASON_FOR_RENEWAL
var infoSw;//DISPLAY_CONTACT_INFO
var objTempAssured = {};
var reports = [];
var policyList =[]; //kenneth 11.24.2014

var objPolicy = new Object(); // SR-5931 JET FEB-20-2017
objPolicy.lineCd = null;
objPolicy.policyNo = null;
objPolicy.parNo = null;