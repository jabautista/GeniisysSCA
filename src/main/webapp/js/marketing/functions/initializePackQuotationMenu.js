function initializePackQuotationMenu(){
	observeAccessibleModule(accessType.MENU, "GIIMM002", "quoteInformation", showPackQuotationInformation);
	observeAccessibleModule(accessType.MENU, "GIIMM008", "warrantyAndClauses", showPackWarrantiesAndClausesPage);
	observeAccessibleModule(accessType.MENU, "GIIMM009", "quoteCarrierInfo", showPackCarrierInfoPage);
	observeAccessibleModule(accessType.MENU, "GIIMM010", "quoteEngineeringInfo",  showPackQuoteENInfoPage);
	observeAccessibleModule(accessType.MENU, "GIIMM006", "printQuote", printPackageQuotation);
	setPackQuotationMenu();
}