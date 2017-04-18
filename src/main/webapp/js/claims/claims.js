var objCLM = new Object(); //Object container for Claims
var objCLMGlobal = new Object(); // Object container for Global Values
var objGICLBatchDv = new Object(); // object for Special CSR - irwin 12.8.11
var objBatchCsr = new Object(); // object for Batch Csr - Nica 12.14.2011
var objGICLAdviceList = []; 
var objGICLS032 = null; // json for Generate Advice - andrew - 02.17.2011
objCLMGlobal.claimId    = null; 
objCLMGlobal.recoveryId    = null; 
objCLMGlobal.callingForm   = null; 
objCLMGlobal.branchCd = null; // based from the user. - irwin
objCLMGlobal.riIssCd = null; 
objCLMGlobal.previousModule = null; //Kris 08.05.2013

var objRecPayt = null;

objCLMGlobal.noClaimTypeListSelectedIndex = null;

objCLM.basicInfo = {}; //basic info
var objClmBasicFuncs = {}; // will hold functions of basic info - irwin
var objGICLS055CallingForm  = null;
var objGICLS201 = new Object();	//shan 03.15.2013

var objGICLS051 = new Object();
var objGICLS050 = new Object();

var objGICLS183 = new Object();	//shan 01.21.2014
objGICLS183.exitPage = null;
objGICLS183.remarksChanged = false;

var objGicls039 = new Object();
objGicls039.validateStatusTag = 'N';

/**
 * Tonio 6.17.2011
 * GICLS002 claim Listing
 * @deprecated 
 */
/*function showClaimListing(){
	new Ajax.Updater("dynamicDiv", contextPath + "/GICLClaimsController?action=getClaimTableGridListing", {
		method: "GET",
		parameters: {
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
		}
	});
}*/ //marco - GENQA 5188 - 12.22.2015 - comment out to avoid conflict with showClaimListing.js

var winFCurr;

/* SPECIAL CSR FUNCTIONS*/

/**
@description Special CSR  functions
@author Irwin Tabisora
@date 12.9.11
*/ 
var specialCSR = {};
//var adviceTableURL;
var adviceTGurl="";
var generateAEOverlay;
var objectSelectedAdviceRows = [];
var objNewBatchDV = {};
var selectedTranId;

/**
@description Generate Recovery AE functions
@author D.Alcantara
@date 1.10.11
*/ 
var postRecPaytOverlay;