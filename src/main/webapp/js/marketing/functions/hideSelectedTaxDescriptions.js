/*
 * Hides the already selected TAX DESCRIPTIONS from the options to prevent the
 * user from selecting it again
 */
function hideSelectedTaxDescriptions(){
	try{
		var taxDescriptionOptions = $("selInvoiceTax").options;
		$$("div[name='invoiceTaxRow']").pluck("id").findAll(function(a){
			for(var i = 0; i < taxDescriptionOptions.length; i++){
				if(a.substring(13) == taxDescriptionOptions[i].value){
					taxDescriptionOptions[i].hide();
				}
			}
		});
	}catch(e){
		showErrorMessage("hideSelectedTaxDescriptions", e);
	}
}