/**
 * @author rencela
 * @return
 */
function getUserIdParameterFromTableGrid(){
	var userId = "";
	var currentContent = "";
	try{
		userId = quotationTableGrid.geniisysRows[selectedQuoteListingIndex].userId;
	}catch (e){
		userId = "CPI";
	};
	return userId;
}