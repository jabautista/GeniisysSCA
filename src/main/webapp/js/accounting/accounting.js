var objORList = new Object();
var objACGlobal = new Object();
objACGlobal.gaccTranId = null; // 54679; 54813;
objACGlobal.branchCd = null;

objACGlobal.fundCd = null;
objACGlobal.callingForm = null;
objACGlobal.calledForm = null;
objACGlobal.withPdc = null;
objACGlobal.tranSource = null;
objACGlobal.documentName = null;
objACGlobal.implSwParam = null;
objACGlobal.opTag = null;
objACGlobal.orFlag = null;
objACGlobal.orTag = null;
objACGlobal.workflowColVal = null;
objACGlobal.workflowEventDesc = null;
objACGlobal.transaction = null;
objACGlobal.opReqTag = null;
objACGlobal.tranClass = null;
objACGlobal.tranFlagState = null;
objACGlobal.orCancellation = null;
objACGlobal.previousModule = null; // added by steven 04.08.2013
objACGlobal.cancelPrint = null; // to determine if dv/check printing was
								// cancelled from GIACS052
objACGlobal.checkCount = null;
objACGlobal.withOp = null;		//added by shan 08.23.2013
objACGlobal.hidObjGIACS070 = {};	//added by shan 08.28.2013

objACGlobal.groupNo = null; //added john  9.26.2014

var objAC = new Object(); // object container for ACCOUNTING - jerome orio
objAC.orDetailsFlag = false;	//[Gzelle] 01.14.2014
// 10.12.2010
objAC.createORTag = null; // used in determining ir OR to be created is manual
							// or generated in o.r. listing
// M for manual, else generated
objAC.showOrDetailsTag = null;
objAC.paytReqStatTag = null; // Gzelle - 04.05.2013 - for Payment Request
								// Status Inquiry, to determine that GIACS016
// was called from GIACS236 (set to Y)
objAC.fromMenu = null;
var dcpJsonObjectList = null; // direct claim payment list #royencela

var objACModalboxParams = null; // modalbox json obj parameters for dcb - emman
								// 04.28.2011

var orListTableGrid = null; // added by andrew - 03.03.2011 - for OR listing
var invoiceSelectedInvoiceRows = null; // andrew - 05.09.2011 - holder of
										// selected rows for all pages
var acctOverlay = null;

var objORPrinting = new Object();
objORPrinting.dcbNo = null;
objORPrinting.cashierCd = null;
objORPrinting.collectionAmt = null;
objORPrinting.grossAmt = null;
objORPrinting.grossTag = null;

var objGIACApdcPayt = null; // andrew - 10.06.2011

// added by Kris 04.08.2013 - for GIACS071
var objGIAC071 = new Object();
objGIAC071.callingForm = null;
objGIAC071.cancelFlag = null;
objGIAC071.memoNumber = null;
objGIAC071.memoTranNumber = null;
objGIAC071.memoStatus = null;
objGIAC071.memoDate = null;
objGIAC071.memoLocalAmt = null;
objGIAC071.memoLocalCurrency = null;
objGIAC071.memoForeignAmt = null;
objGIAC071.memoForeignCurrency = null;
objGIAC071.memoRecipient = null;
objGIAC071.prevParams = new Object();

var objGIACS002 = new Object();
objGIACS002.fundCd = null;
objGIACS002.branchCd = null;
objGIACS002.cancelDV = "N";
objGIACS002.dvTag = null;
objGIACS002.dvApproval = null;
objGIACS002.checkDVPrint = null;
objGIACS002.allowMultiCheck = null;
objGIACS002.preQuery = false;
objGIACS002.overrideTag = false;
objGIACS002.dvRecordStatus = null;
objGIACS002.gidvCreateRec = "Y";
objGIACS002.gcdbCreateRec = "N";
objGIACS002.lineCd = null;	// shan 09.08.2014
objGIACS002.fromGIACS054 = false;

// added by Shan 04.23.2013 - for GIACS230
var objGIACS230 = new Object();
objGIACS230.fieldVals = [];
objGIACS230.from_date = null;
objGIACS230.to_date = null;
objGIACS230.dt_basis = null;
objGIACS230.sl_exists = 0;
objGIACS230.glTransURL = null;
objGIACS230.slSummaryURL = null;
objGIACS230.multiSort = null;
objGIACS230.msortOrder = [];

// jomsdiago 08.01.2013
var objGIACS202 = new Object();
objGIACS202.columnNo = "";
objGIACS202.multiSort = null;
objGIACS202.msortOrder = [];
objGIACS202.agingSortURL = null;

// jomsdiago 08.02.2013
var objGIACS203 = new Object();
objGIACS203.multiSort = null;
objGIACS203.msortOrder = [];
objGIACS203.agingSortURL = null;
objGIACS203.currentForm = null;

// jomsdiago 08.05.2013
var objGIACS204 = new Object();
objGIACS204.multiSort = null;
objGIACS204.msortOrder = [];
objGIACS204.agingSortURL = null;
objGIACS204.currentForm = null;

// jomsdiago 08.06.2013
var objGIACS207 = new Object();
objGIACS207.multiSort = null;
objGIACS207.msortOrder = [];
objGIACS207.agingSortURL = null;
objGIACS207.currentForm = null;

// jomsdiago 08.06.2013
var objGIACS207AssdList = new Object();
objGIACS207AssdList.multiSort = null;
objGIACS207AssdList.msortOrder = [];
objGIACS207AssdList.agingSortURL = null;

var objGiacs351 = new Object();
objGiacs351.repCd = null;
objGiacs351.repTitle = null;

// Gzelle
var objGiacs044 = new Object();
objGiacs044.fromMenu = false;

var objGlobalGIACS237 = new Object();
objGlobalGIACS237.fieldVals = [];
objGlobalGIACS237.dvStatusURL = null;
objGlobalGIACS237.fundCd = null;
objGlobalGIACS237.branchCd = null;

var objSOA = new Object();
objSOA.prevParams = null;

// added by Shan 05.27.2013
var objGIACS410 = new Object();
objGIACS410.postGL = null;

var objGIACS049 = new Object();
objGIACS049.gaccTranId = null;

//added by shan 08.07.2013
var objGIACS149 = new Object();
objGIACS149.intmNo = null;
objGIACS149.intmName = null;
objGIACS149.coIntmType = null;
objGIACS149.gfunFundCd = null;
objGIACS149.fund = null;
objGIACS149.gibrBranchCd = null;
objGIACS149.branch = null;
objGIACS149.fromDate = null;
objGIACS149.toDate = null;
objGIACS149.docName = "OCV";
objGIACS149.selectedRow = null;
objGIACS149.fromMainMenu = true;
objGIACS149.callingForm = null;
objGIACS149.reprint = null;
objGIACS149.voucherNo = null;
objGIACS149.voucherDate = null;
objGIACS149.voucherPrefSuf = null;
objGIACS149.gpcvSelect = [];
objGIACS149.url = null;
objGIACS149.reportFromDate = null;
objGIACS149.reportToDate = null;
objGIACS149.reportInclItems = null;
objGIACS149.selectedCommDue = null;
objGIACS149.selectedNetCommDue = null;
objGIACS149.ocvNo = null;
objGIACS149.ocvPrefSuf = null;
objGIACS149.checkedVouchers = [];
objGIACS149.ocvBranch = null;

//added by shan 08.27.2013
var objGIACS070 = new Object();
objGIACS070.company = null;
objGIACS070.branch = null;
objGIACS070.fromMainMenu = null;
objGIACS070.taxFieldInfo = null;
objGIACS070.retrievedOR = null;
objGIACS070.dest = null;

//shan 12.04.2013
var objGIACS213 = new Object();
objGIACS213.policyId  = null;
objGIACS213.lineCd = null;
objGIACS213.sublineCd = null;
objGIACS213.issCd = null;
objGIACS213.issueYy = null;
objGIACS213.polSeqNo = null;
objGIACS213.endtSeqNo = null;
objGIACS213.endtType = null;
objGIACS213.assdName = null;
objGIACS213.premSeqNo = null;

objGIPIS203 = new Object();

var objGtqs = new Object();
var objTreaty = new Object();

objACGlobal.objGIACS314 = {};
objACGlobal.objGIACS314.calledByGiacs314 = null;
objACGlobal.objGIACS314.moduleId = null;
objACGlobal.objGIACS314.moduleName = null;
objACGlobal.objGIACS314.functionCode = null;
objACGlobal.objGIACS314.functionName = null;
objACGlobal.objGIACS314.functionDesc = null;

var objGIACS020 = new Object();	// shan 09.18.2014
objGIACS020.notIn = null;

var objGIACS054 = new Object();	// shan 09.26.2014
objGIACS054.tempTaggedRecords = [];

//john 10.15.2014
objGIAC032 = {};

var objGIACS040 = new Object();

var modalPageNo2 = 1;

/**
 * Displays Direct Premium Collections
 * 
 * @return
 */
/*
 * function showDirectPremiumCollns(){ new Ajax.Updater("transBasicInfoSubpage",
 * contextPath +
 * "/GIACDirectPremCollnsController?action=showDirectPremiumColln&" +
 * Form.serialize("itemInformationForm") ,{ method: "POST", parameters: {
 * gaccTranId: objACGlobal.gaccTranId }, asynchronous: true, evalScripts: true,
 * onCreate: function() { showNotice("Loading Direct Premium Collections
 * Information. Please wait... </br> " + contextPath); }, onComplete:
 * function(){ hideNotice(""); } }); }
 */

/*
 * Shows foreign currency div TONIO Sept 8, 2010
 * 
 * function showForeignCurrDtls(){ Effect.Appear("foreignCurrMainDiv", {
 * duration: .001 }); $("fCurrCd").value =
 * jsonDirectPremCollnsHiddenInfo.currCd; //$F("currCd"); modified by alfie
 * 12.09.2010 $("fCurrRt").value =
 * formatCurrency(jsonDirectPremCollnsHiddenInfo.currRt);//$F("currRt"));
 * modified by alfie 12.09.2010 $("fCurrCdDesc").value = $F("transCurrDesc");
 * $("fCurrAmt").value = formatCurrency(unformatCurrency("premCollectionAmt") /
 * parseFloat(jsonDirectPremCollnsHiddenInfo.currRt));//$F("currRt"))); modified
 * by alfie 12.09.2010 }
 */

modalPageNo2 = 1;
modalPageNo2 = 1;
modalPageNo2 = 1;

var pdcId = "";
var postDatedChecksDtlsObj = new Object();
var tempChkClassObj = new Object();
var lovListing = new Object();

var giacs090variables = new Object();
var tempApdcPaytDtlObj = new Array();
var pdcReplaceObjectList = new Array();

/*function showPrintCollectionLetter() {
	// var refresh = (objSOA.prevParams != null && objSOA.prevParams.prevPage ==
	// "printCollectionLetter") ? "1" : "0";
}*/

/*function hideAccountingMainMenus(){
	$("home").hide();
	$("cashReceipts").hide();
	$("generalDisbursements").hide();
	$("generalLedger").hide();
	$("endOfMonth").hide();
	$("creditAndCollection").hide();
	$("uploading").hide();
}*/

//bonok :: 07.19.2013 :: GIACS110
/*function showGIACS110(){
	new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
	    parameters : {action : "showGIACS110"},
	    onCreate: showNotice("Loading Print Taxes Withheld from Payees page.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}catch (e){
				showErrorMessage("Convert File", e);
			}
		}
	});
}*/