/**
 * Saves Package Quotation Information
 * 
 */

function savePackageQuotation(){
	try{
		if(checkIfAllQuotationItemsHasPerils()){
			
			initializePackQuoteNullObjectListings();
			
			var addedItemRows = getAddedJSONObjectList(objPackQuoteItemList);
			var modifiedItemRows = getModifiedJSONObjects(objPackQuoteItemList);
			var delItemRows = getDeletedJSONObjects(objPackQuoteItemList);
			var setItemRows	= addedItemRows.concat(modifiedItemRows);
	
			var addedPerilRows = getAddedJSONObjectList(objPackQuoteItemPerilList);
			var modifiedPerilRows = getModifiedJSONObjects(objPackQuoteItemPerilList);
			var delPerilRows = getDeletedJSONObjects(objPackQuoteItemPerilList);
			var setPerilRows = addedPerilRows.concat(modifiedPerilRows);
			
			var addedDeductibleRows = getAddedJSONObjectList(objPackQuoteDeductiblesList);
			var modifiedDeductibleRows = getModifiedJSONObjects(objPackQuoteDeductiblesList);
			var delDeductibleRows = getDeletedJSONObjects(objPackQuoteDeductiblesList);
			var setDeductibleRows = addedDeductibleRows.concat(modifiedDeductibleRows);
			
			var addedMortgageeRows = getAddedJSONObjectList(objPackQuoteMortgageeList);
			var modifiedMortgageeRows = getModifiedJSONObjects(objPackQuoteMortgageeList);
			var delMortgageeRows = getDeletedJSONObjects(objPackQuoteMortgageeList);
			var setMortgageeRows = addedMortgageeRows.concat(modifiedMortgageeRows);
			
			var addedInvoiceRows = getAddedJSONObjectList(objPackQuoteInvoiceList);
			var modifiedInvoiceRows = getModifiedJSONObjects(objPackQuoteInvoiceList);
			var delInvoiceRows = getDeletedJSONObjects(objPackQuoteInvoiceList);
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
			for ( var i = 0; i < setItemRows.length; i++) { //added by steven 11/8/2012 - to see if the Car Company is null.
				if(setItemRows[i].lineCd == "MC"){
					if(setItemRows[i].gipiQuoteItemMC.carCompany == "" || setItemRows[i].gipiQuoteItemMC.carCompany == null ){
						var itemNo = removeLeadingZero(setItemRows[i].itemNo);
						customShowMessageBox("Car company is required. Press Show button in Additional Information Block to enter car company for Item No. "+itemNo+ ".", "E", "carCompany");
						return false;
					}
				}
			}
	
			new Ajax.Request(contextPath+"/GIPIPackQuotationInformationController",{
				method: "POST",
				parameters: {
					action: "savePackQuotationInformation",
					parameters: JSON.stringify(objParameters)
				},
				onCreate: function(){
					disableButton("btnEditQuotation");
					disableButton("btnSaveQuotation");
					disableButton("btnPrintQuotation");
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					enableButton("btnEditQuotation");
					enableButton("btnSaveQuotation");
					enableButton("btnPrintQuotation");
					if(checkErrorOnResponse(response)){
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							clearPackQuotationObjects();
							changeTag = 0;
							quotePerilChangeTag = 0; //added by steven 1/30/2013
							loadPackQuoteInvoiceSubpage();
						}else{
							showMessageBox(response.responseText,imgMessage.ERROR);
						} 
					}else{
						showMessageBox(response.responseText,imgMessage.ERROR);
					}
				}
			});
		}
	}catch(e){
		showErrorMessage("savePackageQuotation", e);
	}
}