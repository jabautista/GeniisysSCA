/*	Created by	: BJGA 12.16.2010
 * 	Description	: update variables that delete all perils for the PAR and sets invoice_sw to "Y"
 */
function updateDeleteDiscountVariables(){
	objFormMiscVariables[0].miscNbtInvoiceSw = "Y";
	objFormMiscVariables[0].miscDeletePerilDiscById = "Y";
	objFormMiscVariables[0].miscDeleteItemDiscById = "Y";
	objFormMiscVariables[0].miscDeletePolbasDiscById = "Y";
}