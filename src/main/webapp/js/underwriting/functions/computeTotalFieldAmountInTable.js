/*	Move by			: mark jm 09.16.2010
 * 	From			: /underwriting/subPages/deductible.jsp
 * 	Modification	: Added compareValue parameter to filter selected item record
 */
function computeTotalFieldAmountInTable(tableId, rowName, fieldIndex, itemNo, perilCd){ // andrew - 09.20.2010 - modified parameters
	try {
		var total = 0;
		$$("div#"+tableId+" div['"+rowName+"']").each(
			function(row){				
				//if(row.getAttribute("item") == compareValue){				
				//if(row.down("input", 0).value == itemNo && row.down("input", 2).value == perilCd){ //andrew - 09.20.2010 - modified the condition
				if(row.getAttribute("item") == itemNo && row.getAttribute("perilCd") == perilCd){
					var amount = row.down("input", fieldIndex).value.replace(/,/g, "");
					total+= parseFloat(nvl(amount, "0"));
				}				
			});
		return total;
	} catch (e){
		showErrorMessage("computeTotalFieldAmountInTable", e);
		//showMessageBox("computeTotalFieldAmountInTable : " + e.message);		
	}
}