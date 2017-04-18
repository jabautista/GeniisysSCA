/**
 * Validate Discount/Surcharge amount in Peril Discount in GIPIS143
 * @author Jerome Orio 02.07.2011
 * @version 1.0
 * @param 
 * @return 
 */
function validateDiscSurcAmtPeril(){
	var result = "0";
	if($("itemPeril").value != ""){ //added by steven 10/03/2012
		new Ajax.Request("GIPIParDiscountController?action=validateDiscSurcAmtPeril&itemNo="+$F("itemNoPeril")+"&perilCd="+$F("itemPerilCd")+"&toDo="+$F("btnAddDiscountPeril"), { //change by steven 10/01/2012 from:	$F("itemPeril")		to: $F("itemPerilCd") 
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