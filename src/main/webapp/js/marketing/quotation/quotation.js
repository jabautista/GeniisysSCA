// quotation global variables
var objMKTG = new Object(); // object container for MARKETING - jerome orio
var quoteIdToEdit = 0;
var perilAddActionIndicator = 0;
var quoteInfoSaveIndicator = 0;
var quotationList = "";
var refreshed = 0;
var isMakeQuotationInformationFormsHidden = 0;
var enggBasicInfoExitCtr = 0; // Engineering Basic Info Counter - Patrick
var carrierInfoExitCtr = 0; // Carrier Information Counter - Patrick
var assuredMaintainExitCtr = 0; // Maintain Assured Counter - Patrick
var assuredMaintainGimmExitCtr = 0; // for Maintain Assured Exit - Patrick
var clausesExitCtr = 0; // for Clauses Exit - Patrick
var bondPolicyDataCtr = 0;
var updater;
var counter = 0;
var itemNo = 0;
var objGIPIQuoteArr = []; // mark jm @UCPBGEN don't delete. used in reassigning quotation
var jsonWarrCla = null; // Udel 03282012
var viewQuotationStatus = "";
objMKTG.giimm001QouteInfo = {}; //added by steven 12/04/2012
objMKTG.giimm001QouteInfo.toPopulateQuoteInfo = false; //added by steven 12/04/2012


var objGIIMM001 = new Object; // Jerome 08.18.2016
objGIIMM001.chkboxSW = 1;

var objGIIMM001A = new Object; // Jerome 08.18.2016
objGIIMM001A.chkboxSW = 1;
//var invoiceFirstRun = true; // checks if invoice page has been loaded

/* <JSON object>.recordStatus
 *  -2 : unedited object -- ignore when saving quotation
 * -1 : deleted object
 *  0 : new added object
 *  1 : modified object
 *  2 : copied object (for item)
 */

var invoiceLoadResponder = {
	onCreate: function() {
	},
	onComplete: function() {
		if(Ajax.activeRequestCount == 0){
			if(objGIPIQuoteInvoiceList==null){
				objGIPIQuoteInvoiceList = new Array();
				var invoiceToBeDisplayed = showDefaultInvoiceValues();
				if(invoiceToBeDisplayed !=null){
					displayInvoice(invoiceToBeDisplayed);
				}
			}
		}
	 }
};

var quoteItemModuleId = new Object();
quoteItemModuleId.MOTOR_CAR 	= "GIIMM017";
quoteItemModuleId.FIRE 			= "GIIMM021";
quoteItemModuleId.ENGINEERING 	= "GIIMM026";//
quoteItemModuleId.CASUALTY		= "GIIMM025";
quoteItemModuleId.ACCIDENT 		= "GIIMM023";
quoteItemModuleId.AVIATION		= "GIIMM024";
quoteItemModuleId.MARINE_HULL 	= "GIIMM028";
quoteItemModuleId.CARGO 		= "GIIMM027";
 
/* invoice listing declaration is in invoice.js */

var entryPass = true; // prevents js from running twice
var marineVessels = ""; // marineVessels JSON

var quotationTableGrid = null;
var selectedQuoteListingIndex = -1;
/**
 * @author rey
 * @date 07-14-2011
 */
var quotationTableGrid2=null;
var selectedQuoteListingIndex2 = -1;
// used in reassign quotation
var lovUnderwriter;

var fromReassignQuotation = 0;

/*function distributeItemPremiums(){
	var listLength = $("perilAnnPremAmtSelect"+ $("txtItemNo").value).length;
	var annPremAmts = $("txtItemNo").options[$("txtItemNo").selectedIndex].getAttribute("annPremAmt");
	var newPerilAmt = 0;
	for (var i=1; i<listLength; i++) {
		newPerilAmt = ($("perilAnnPremAmtSelect"+ $("txtItemNo").value).options[i].value / annPremAmts)* parseInt($F("discountAmtItem").replace(/,/g, "")) + parseFloat(surchargeAmt.replace(/,/g, ""));
		$("perilPremAmtSelect"+ $("txtItemNo").value).options[i].value = $("perilPremAmtSelect"+ $("txtItemNo").value).options[i].value - newPerilAmt;
		$("perilPremAmtSelect"+ $("txtItemNo").value).options[i].value = $("perilPremAmtSelect"+ $("txtItemNo").value).options[i].text - newPerilAmt;
	}
}*/

/**
 * quotationMainResponder definition
 * this variable has been declared in common.js
 * @author rencela
 */
quotationMainResponder = {
	onCreate: function() {
	   disableButton("btnEditQuotation");
	   disableButton("btnSaveQuotation");
	   disableButton("btnPrintQuotation");
	   showNotice("Processing Information...");
	   hideAccordionLabelsOnQuotationMain();
	},
	onComplete: function() {
	   enableButton("btnEditQuotation");
	   enableButton("btnSaveQuotation");
	   enableButton("btnPrintQuotation");
	   hideNotice("SUCCESS");
	   Effect.Fade("notice", {			
		   duration : .001
	   });
	   showAccordionLabelsOnQuotationMain();
	 }
};