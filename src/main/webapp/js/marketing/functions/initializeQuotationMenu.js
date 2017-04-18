/**
 * Added 04.19.11
 * Irwin Tabisora
 * */
function initializeQuotationMenu(){
	observeAccessibleModule(accessType.MENU, "GIIMM011", "bondPolicyData", showBondPolicyData);
	observeAccessibleModule(accessType.MENU, "GIIMM009", "quoteCarrierInfo", showQuotationCarrierInfoPage);
	observeAccessibleModule(accessType.MENU, "GIIMM010", "quoteEngineeringInfo", showQuotationEngineeringInfo);
	observeAccessibleModule(accessType.MENU, "GIIMM002", "quoteInformation", 
			function(){
				 isMakeQuotationInformationFormsHidden = 0; // added by: Nica 07.18.2012 - to reset isMakeQuotationInformationFormsHidden
		         showQuotationInformation();
		    });
	observeAccessibleModule(accessType.MENU, "GIIMM008", "warrantyAndClauses", showClausesPage);
	observeAccessibleModule(accessType.MENU, "GIIMM012", "discount", showDiscountPage);
	observeAccessibleModule(accessType.MENU, "GIIMM006", "printQuote", printQuotation);
	observeAccessibleModule(accessType.MENU, "GIIMM007", "policyLostBidsReport", policyLostBidsReport);
}