/** 
 * Prepares content of quote mortgagee row 
 * @param mortgageeObj - JSON Object that contains the quote mortgagee information
 */

function prepareQuoteMortgageeTable(mortgageeObj){
	var mortgName = mortgageeObj.mortgName == null || mortgageeObj.mortgName.empty() ? "---" : unescapeHTML2(mortgageeObj.mortgName);
	var amount 	  = mortgageeObj.amount == null || nvl(mortgageeObj.amount, "") == "" ? "---" : formatCurrency(mortgageeObj.amount);
	var itemNo    = mortgageeObj.itemNo == null || mortgageeObj.itemNo == "" ? "---" : mortgageeObj.itemNo;
	
	var mortgInfo = '<label style="width: 50%; padding-left: 20px;">'+mortgName+'</label>'+
					'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">'+amount+'</label>'+
					'<label style="width: 20%; text-align: center;">'+itemNo+'</label>';
	return mortgInfo;
}