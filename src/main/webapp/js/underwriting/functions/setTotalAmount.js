/*	Move by			: mark jm 09.16.2010
 * 	From			: /underwriting/subPages/deductible.jsp
 * 	Description		: Compute total deductible amount in deductible.jsp
 * 	Modification	: Added parameter dedLevel 					
 */
function setTotalAmount(dedLevel, itemNo, perilCd){ // andrew - 09.20.2010 - modified parameters
	try {
		var totalAmount = computeTotalFieldAmountInTable("wdeductibleListing"+dedLevel, "ded"+dedLevel, 5, itemNo, perilCd); // andrew - 09.20.2010 - modified parameters

		//if(totalAmount > 0){
			$("totalDedAmount"+dedLevel).innerHTML = formatCurrency(totalAmount);
			$("totalDedAmountDiv"+dedLevel).setStyle("display: block;");
			var marginRight = (dedLevel == 1 ? "12.5" : (dedLevel == 2 ? "11" : "4"));
			$("totalDedAmount"+dedLevel).setStyle("margin-right: "+marginRight+"%;");
		//}
		
		if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
			if(objDeductibles != null){
				//if(itemNo > 0 && nvl(perilCd, 0) == 0){
				if(itemNo > 0){
					computeDeductibleAmtByItem(itemNo);
				}
			}
		}
	} catch (e){
		showErrorMessage("setTotalAmount", e);
		//showMessageBox("setTotalAmount : " + e.message);
	}
}