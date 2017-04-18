//transferred from quotationListingTable BJGA 12.22.2010
function continueDenyQuotation(qId, quoteNo, reasonCd){ //--rmanalad added input param reasonCd 5.9.2011
	//var qId = getSelectedRowId("row");  -- rmanalad<convertion  to table grid 4.01.2011>
	new Ajax.Request(contextPath+"/GIPIQuotationController?action=denyQuotation", {
		asynchronouse: true,
		evalScripts: true,
		parameters: {
			quoteId: qId,
			reasonCd: reasonCd //--ramanalad 5.9.2011
		},
		onCreate: function() {
			showNotice("Denying quotation, please wait...");
		},
		onComplete: function(response) {
			showMessageBox("The Quotation "+quoteNo+" has been denied.", imgMessage.INFO);
			//deselectRows("quotationListingTable", "row");
			quotationTableGrid.clear();
			quotationTableGrid.refresh();
			selectedIndex = -1;
		}
	});
}