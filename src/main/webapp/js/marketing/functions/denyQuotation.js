//transferred from quotationListingTable BJGA 12.22.2010
function denyQuotation(qId, quoteNo, reasonCd){ //--rmanalad added input param reasonCd 5.9.2011
	showConfirmBox(/*"Deny Confirmation"*/ "Confirmation",	// changed by shan 07.07.2014 
		   	   //"Deny Quotation No. <br />" + $("row" +qId).down("input", 1).value+"?", -- rmanalad<convertion  to table grid 4.01.2011>
			   "Deny Quotation No. <br />" +quoteNo+" ?", 
		   	   "Yes", "No",  function () {continueDenyQuotation(qId, quoteNo, reasonCd);}, 
		   	   function(){
		   		   if(objUWGlobal.setSelectedIndexGIIMM001 != null || objUWGlobal.setSelectedIndexGIIMM001 != undefined){
			   		   objUWGlobal.setSelectedIndexGIIMM001(); // bonok :: set selectedIndex to 0 when cancelled because it is set to -1 when chooseReasonOverlay overlay is displayed :: 05.07.2014
		   		   };
		   	   });
}