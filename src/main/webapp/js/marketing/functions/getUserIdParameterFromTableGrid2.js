/**
 * @author rey
 * @date 07-14-2011
 * @returns {String}
 */
function getUserIdParameterFromTableGrid2(){
	var userId = "";
	var currentContent = "";
	try{
		userId = quotationTableGridListing.geniisysRows[selectedQuoteListingIndex2].userId;
	}catch (e){
		userId = "CPI"; // #cheatFix
	};
	return userId;
}