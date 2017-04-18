function clearSelectedPackDiv(){
	try{
		$("packQuoteId").value = '';
		$("selectedPackQuoteId").value = '';
		$("selectedIssCd").value = '';
		$("selectedLineCd").value = '';
		$("selectedSublineCd").value = '';
		$("selectedQuotationYy").value = '';
		$("selectedQuotationNo").value = '';
		$("selectedProposalNo").value = '';
		$("selectedAssdNo").value = '';
		$("selectedAssdName").value = '';
		$("selectedAssd").value = '';
		$("selectedAssdActiveTag").value = '';
		$("selectedValidDate").value = '';
	}catch(e){
		showErrorMessage("clearSelectedPackDiv", e);
	}	
}