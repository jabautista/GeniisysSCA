function updateListByReassign(row){
	try{
		quotationTableGrid.setValueAt(row.userId, quotationTableGrid.getColumnIndex("userId"), selectedQuoteListingIndex, true);		
		quotationTableGrid.geniisysRows[selectedQuoteListingIndex].userId = row.userId;
		
		if((objGIPIQuoteArr.filter(function(obj){ return obj.quoteId == quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId;	})).length > 0){
			for(var i=0, length=objGIPIQuoteArr.length; i < length; i++){
				if(objGIPIQuoteArr[i].quoteId == quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId){
					objGIPIQuoteArr.splice(i, 1, quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
				}
			}
		}else{
			objGIPIQuoteArr.push(quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
		}
		changeTag = 1;
		quotationTableGrid.modifiedRows.push(quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);			
	}catch(e){
		showErrorMessage("updateListByReassign", e);
	}
}