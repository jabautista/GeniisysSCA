/**
 * 	quotation-packs.js 
 *  Contains functions for quotation package
 *  Created By Irwin Tabisora, 4.14.11 
 * */
var packQuotationTableGrid = null;
var selectedPackQuoteListingIndex = -1;
var objGIPIPackQuote = new Object(); // gipipackquote object for gipi pack quote. irwin 4.14.11
var objGIPIPackQuotations = new Array(); // Contains the basic quotations for PACKAGE quotation 

// pack quotation mortgagee objects
var strParametersPackMortg; //pack quote mortgage obj string parameter
var objPackQuoteMortgagee = new Array();
//end

// pack engineering basic info
var objQuoteENDetailList = new Array();
var	objQuotePrincipalList = new Array();
//

objGIPIPackQuote.packQuoteId = null;
objGIPIPackQuote.lineCd = null;
objGIPIPackQuote.lineName = null;
objGIPIPackQuote.sublineCd = null;
objGIPIPackQuote.sublineName = null;
objGIPIPackQuote.issCd = null;
objGIPIPackQuote.issName = null;
objGIPIPackQuote.quotationYy = null;
objGIPIPackQuote.quotationNo = null;
objGIPIPackQuote.quoteNo = null;
objGIPIPackQuote.proposalNo = null;
objGIPIPackQuote.assdNo = null;
objGIPIPackQuote.assdName = null;
objGIPIPackQuote.inceptDate = null;
objGIPIPackQuote.expiryDate = null;
objGIPIPackQuote.credBranch = null;
objGIPIPackQuote.credBranchName = null;
objGIPIPackQuote.userId = null;
objGIPIPackQuote.address1 = null;
objGIPIPackQuote.address2 = null;
objGIPIPackQuote.address3 =null;
objGIPIPackQuote.acctOfCd = null;
objGIPIPackQuote.underwriter = null;
objGIPIPackQuote.inceptTag = null;
objGIPIPackQuote.expiryTag = null;
objGIPIPackQuote.header = null;
objGIPIPackQuote.footer = null;
objGIPIPackQuote.remarks = null;
objGIPIPackQuote.reasonCd = null;
objGIPIPackQuote.compSw = null;
objGIPIPackQuote.prorateFlag =null;
objGIPIPackQuote.shortRatePercent = null;
objGIPIPackQuote.bankRefNo = null;
objGIPIPackQuote.validDt = null;
objGIPIPackQuote.acceptDate = null;

var objMKGlobal = new Object(); // Marketing global Object. irwin
objMKGlobal.packQuoteId = null;
objMKGlobal.lineCd = null;
objMKGlobal.lineName = null;
objMKGlobal.sublineCd = null;
objMKGlobal.sublineName = null;
objMKGlobal.issCd = null;
objMKGlobal.issName = null;
objMKGlobal.quotationYy = null;
objMKGlobal.quotationNo = null;
objMKGlobal.quoteNo = null;
objMKGlobal.proposalNo = null;
objMKGlobal.assdNo = null;
objMKGlobal.assdName = null;
objMKGlobal.inceptDate = null;
objMKGlobal.expiryDate = null;
objMKGlobal.credBranch = null;
objMKGlobal.credBranchName = null;
objMKGlobal.userId = null;
objMKGlobal.address1 = null;
objMKGlobal.address2 = null;
objMKGlobal.address3 =null;
objMKGlobal.acctOfCd = null;
objMKGlobal.underwriter = null;
objMKGlobal.inceptTag = null;
objMKGlobal.expiryTag = null;
objMKGlobal.header = null;
objMKGlobal.footer = null;
objMKGlobal.remarks = null;
objMKGlobal.reasonCd = null;
objMKGlobal.compSw = null;
objMKGlobal.prorateFlag =null;
objMKGlobal.shortRatePercent = null;
objMKGlobal.bankRefNo = null;
objMKGlobal.acceptDate = null;
objMKGlobal.validDate = null;