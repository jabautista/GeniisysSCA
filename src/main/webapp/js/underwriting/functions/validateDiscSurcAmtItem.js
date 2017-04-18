/**
 * Validate Discount/Surcharge amount in Item Discount in GIPIS143
 * @author Jerome Orio 02.04.2011
 * @version 1.0
 * @param 
 * @return 
 */
function validateDiscSurcAmtItem(){
	var result = "0";
	if($F("itemNo") != ""){ //added by steven 10/03/2012
		new Ajax.Request("GIPIParDiscountController?action=validateDiscSurcAmtItem&itemNo="+$F("itemNo"), {
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
	}
	return result;
}