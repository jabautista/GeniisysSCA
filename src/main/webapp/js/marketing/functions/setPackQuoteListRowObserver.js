/**
 * Sets observer for Package quote listing row
 * @param row - row to be observe
 */

function setPackQuoteListRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			resetAllPackQuotationInformationForms();
			($$("div#quoteItemTable div[name='row']")).invoke("removeClassName", "selectedRow");
			$("itemPerilTable").hide();
			
			if(row.hasClassName("selectedRow")){												
				($$("div#packQuotationListDiv div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				$$("div#additionalItemInformation input[type='text'], div#additionalItemInformation textarea, div#additionalItemInformation select").each(function (a) { //added by steve 11/8/2012 - para ma-clear ung value nung mga fields sa Additional Info. na block.
					$(a).value = "";
				});
				($$("div#quoteItemTable div[name='row']")).invoke("show");				
				($$("div#quoteItemTableContainer div:not([quoteId='" + row.getAttribute("quoteId") + "'])")).invoke("hide");
				
				resizeTableBasedOnVisibleRows("quoteItemTable", "quoteItemTableContainer");
				 //added by steven 11/8/2012 if the selected sub-quotation is Marine Cargo this menu should be enabled
				disableMenu("quoteCarrierInfo");
				if (row.getAttribute("menuLineCd") == "MN" ||row.getAttribute("menuLineCd") == "MR" 
					|| row.getAttribute("lineCd") == "MN" ||row.getAttribute("lineCd") == "MR" ){	// added lineCd condition : shan 07.04.2014
					enableMenu("quoteCarrierInfo");
				}
				//added by shan 07.04.2014 if the selected sub-quotation is Engineering this menu should be enabled
				disableMenu("quoteEngineeringInfo");
				if (row.getAttribute("menuLineCd") == "EN" ||row.getAttribute("lineCd") == "EN" ){	
					enableMenu("quoteEngineeringInfo");
				}
				for(var i=0; i<objPackQuoteList.length; i++){
					if(objPackQuoteList[i].quoteId == row.getAttribute("quoteId")){
						objCurrPackQuote = objPackQuoteList[i];
						showPackQuoteAdditionalInfoPage(objPackQuoteList[i].lineCd, objPackQuoteList[i].menuLineCd);
					}
				}
				
			}else{
				$("quoteItemTable").hide();
				objCurrPackQuote = null;
			}
			showPackQuoteAccordionHeaders();
			computeTotalItemTsiandPremAmount("txtTotalTsiAmount", "txtTotalPremiumAmount");
		});
	}catch(e){
		showErrorMessage("setPackQuoteListRowObserver", e);
	}
}