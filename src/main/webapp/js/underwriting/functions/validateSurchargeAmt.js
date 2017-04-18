/**
 * Validate surcharge amount in Policy Discount in GIPIS143
 * @author Jerome Orio 01.31.2011
 * @version 1.0
 * @param id - surcharge amount/rate field id 
 * @return 
 */
function validateSurchargeAmt(id){
	var result = "0";
	new Ajax.Request("GIPIParDiscountController?action=validateSurchargeAmt", {
		method: "POST",
		postBody: Form.serialize("billDiscountForm"),
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			//showNotice("Validating amount, please wait...");
		},
		onComplete: function (response)	{
			//hideNotice();
			if (checkErrorOnResponse(response)) {
				if (response.responseText != ""){
					result = response.responseText;
					return;
				}
			}	
		}
	});
	return result;
}