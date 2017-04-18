/**
 * Created By Irwin Tabisora. 4.25.2011
 * */
function setPackQuotationGlobalParameters(obj){
	objMKGlobal.packQuoteId 	= obj.packQuoteId; //added by steven 10/31/2012 - unescapeHTML2
	objMKGlobal.lineCd 			= obj.lineCd;
	objMKGlobal.lineName 		= unescapeHTML2(obj.lineName);
	objMKGlobal.sublineCd 		= obj.sublineCd;
	objMKGlobal.sublineName 	= unescapeHTML2(obj.sublineName);
	objMKGlobal.issCd 			= obj.issCd;	
	objMKGlobal.issName 		= unescapeHTML2(obj.issName);
	objMKGlobal.quotationYy 	= obj.quotationYy;
	objMKGlobal.quotationNo 	= obj.quotationNo;
	objMKGlobal.quoteNo 		= obj.quoteNo;
	objMKGlobal.proposalNo		= obj.proposalNo;
	objMKGlobal.assdNo 			= obj.assdNo;
	objMKGlobal.assdName 		= unescapeHTML2(obj.assdName);
	objMKGlobal.inceptDate 		= obj.inceptDate;
	objMKGlobal.expiryDate 		= obj.expiryDate;
	objMKGlobal.credBranch 		= obj.credBranch;
	objMKGlobal.credBranchName 	= unescapeHTML2(obj.credBranchName);
	objMKGlobal.userId 			= obj.userId;
	objMKGlobal.address1 		= unescapeHTML2(obj.address1);
	objMKGlobal.address2 		= unescapeHTML2(obj.address2);
	objMKGlobal.address3 		= unescapeHTML2(obj.address3);
	objMKGlobal.acctOfCd 		= obj.acctOfCd;
	objMKGlobal.underwriter 	= obj.underwriter;
	objMKGlobal.inceptTag 		= obj.inceptTag;
	objMKGlobal.expiryTag 		= obj.expiryTag;
	objMKGlobal.header 			= obj.expiryTag;
	objMKGlobal.footer 			= unescapeHTML2(obj.footer);
	objMKGlobal.remarks 		= unescapeHTML2(obj.remarks);
	objMKGlobal.reasonCd 		= obj.reasonCd;
	objMKGlobal.compSw 			= obj.compSw;
	objMKGlobal.prorateFlag 	= obj.prorateFlag;
	objMKGlobal.shortRatePercent= obj.shortRatePercent;
	objMKGlobal.bankRefNo 		= obj.bankRefNo;
	objMKGlobal.validDate 		= obj.validDate;
	objMKGlobal.acceptDate 		= obj.acceptDt;
}