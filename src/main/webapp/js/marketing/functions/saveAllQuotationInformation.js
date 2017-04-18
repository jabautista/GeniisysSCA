//LOV'S setup 
function saveAllQuotationInformation(){
	if(checkPendingRecordChanges()){ // Patrick 02.14.2012
		var lineCd = getLineCdMarketing();
		// do not include unmodified subpages to parameters when saving to speed up saving
		instantiateNullListings();
	
		var addedItemRows = getAddedJSONObjectList(objGIPIQuoteItemList);
		var modifiedItemRows = getModifiedJSONObjects(objGIPIQuoteItemList);
		var delItemRows = getDeletedJSONObjects(objGIPIQuoteItemList);
		var setItemRows	= addedItemRows.concat(modifiedItemRows);
		
		var proceed = true;
		// CHECK ITEM TYPE
		if(lineCd == "MC"){
			if(hasAdditionalInformation(objGIPIQuoteItemList)){
				proceed = true;
			}else{
				proceed = false;
				// error message
			}
		}
		
		if(proceed){
			var addedPerilRows = getAddedJSONObjectList(objGIPIQuoteItemPerilSummaryList);
			var modifiedPerilRows = getModifiedJSONObjects(objGIPIQuoteItemPerilSummaryList);
			var delPerilRows = getDeletedJSONObjects(objGIPIQuoteItemPerilSummaryList);
			var setPerilRows = addedPerilRows.concat(modifiedPerilRows);
			
			// added by: Nica 09.05.2011
			var addedDeductibleRows = getAddedJSONObjectList(objGIPIQuoteDeductiblesSummaryList);
			var modifiedDeductibleRows = getModifiedJSONObjects(objGIPIQuoteDeductiblesSummaryList);
			var delDeductibleRows = getDeletedJSONObjects(objGIPIQuoteDeductiblesSummaryList);
			var setDeductibleRows = addedDeductibleRows.concat(modifiedDeductibleRows);
			
			var addedMortgageeRows = getAddedJSONObjectList(objGIPIQuoteMortgageeList);
			var modifiedMortgageeRows = getModifiedJSONObjects(objGIPIQuoteMortgageeList);
			var delMortgageeRows = getDeletedJSONObjects(objGIPIQuoteMortgageeList);
			var setMortgageeRows = addedMortgageeRows.concat(modifiedMortgageeRows);
		
			var addedInvoiceRows = getAddedJSONObjectList(objGIPIQuoteInvoiceList);
			var modifiedInvoiceRows = getModifiedJSONObjects(objGIPIQuoteInvoiceList);
			var delInvoiceRows = getDeletedJSONObjects(objGIPIQuoteInvoiceList);
			var setInvoiceRows = addedInvoiceRows.concat(modifiedInvoiceRows);
			
			var objParameters = new Object();
			
			objParameters.setItemRows 		= prepareJsonAsParameter(setItemRows);
			objParameters.delItemRows 		= prepareJsonAsParameter(delItemRows);
			objParameters.setPerilRows		= prepareJsonAsParameter(setPerilRows);
			objParameters.delPerilRows		= prepareJsonAsParameter(delPerilRows);
			objParameters.setDeductibleRows	= prepareJsonAsParameter(setDeductibleRows);
			objParameters.delDeductibleRows	= prepareJsonAsParameter(delDeductibleRows);
			objParameters.setMortgageeRows 	= prepareJsonAsParameter(setMortgageeRows);
			objParameters.delMortgageeRows	= prepareJsonAsParameter(delMortgageeRows);
			objParameters.setInvoiceRows	= prepareJsonAsParameter(setInvoiceRows);
			objParameters.delInvoiceRows	= prepareJsonAsParameter(delInvoiceRows);
			objParameters.gipiQuote			= prepareJsonAsParameter(objGIPIQuote); // added by roy 06/13/2011
			
			new Ajax.Request(contextPath + "/GIPIQuotationInformationController?action=saveQuotationInformationJSON",{	
				method: "POST",		//postBody: Form.serialize("quotationInformationForm"),
				onCreate: function(){
					/* 	disableButton("btnEditQuotation"); disableButton("btnSaveQuotation"); 
						disableButton("btnPrintQuotation"); $("quotationInformationForm").disable(); */
					showNotice("Saving, please wait...");
				},
				parameters:{
					quoteId: 		objGIPIQuote.quoteId,
					parameters : 	JSON.stringify(objParameters),
					lineCd:			getLineCdMarketing()
				},
				onComplete: function(response){
					/*	$("quotationInformationForm").enable();	enableButton("btnEditQuotation");
					enableButton("btnSaveQuotation"); enableButton("btnPrintQuotation"); */ // Patrick 02.14.2012
					if (checkErrorOnResponse(response)){
						hideNotice(response.responseText);
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
							enableButton("btnEditQuotation");
							enableButton("btnSaveQuotation");
							enableButton("btnPrintQuotation");
							quoteInfoSaveIndicator = 1;
							deleteExecutedRecordStats();
							changeTag = 0; // Patrick - 02.14.2012	
							lastAction(); // Patrick - 02.13.2012
							lastAction = "";
						}
					}
					enableQuotationMainButtons();
					showAccordionLabelsOnQuotationMain();
					delRemovedDeductibles();
				}
			});
		}else{ // end of - if(proceed)
		}
	}
}