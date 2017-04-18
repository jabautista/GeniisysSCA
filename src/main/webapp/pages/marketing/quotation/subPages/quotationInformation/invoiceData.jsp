<script>
	// An Array of invoices containing an array of invTaxes
	objGIPIQuoteInvoiceList	= JSON.parse('${invoiceList}'.replace(/\\/g, '\\\\'));
	invoiceTaxLov 	= JSON.parse('${invoiceTaxLov}'.replace(/\\/g, '\\\\'));
	intermediaryLov = JSON.parse('${intermediaryLov}'.replace(/\\/g, '\\\\'));
	invoiceSequence = JSON.parse('${invoiceSequence}'.replace(/\\/g, '\\\\'));
	initializeRecordStatus(objGIPIQuoteInvoiceList);
	setInvoiceLovOptions();
	
</script>