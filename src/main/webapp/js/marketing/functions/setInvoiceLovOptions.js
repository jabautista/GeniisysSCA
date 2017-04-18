function setInvoiceLovOptions(){
	var selTaxInvoice	= $("selInvoiceTax");
	var selTaxId		= $("selTaxId");
	var selRateInv		= $("selRateInv");
	var selIntermediary = $("selIntermediary");	
	
	var invTaxObj;
	selTaxInvoice.update("<option></option>");
	for(var i=0; i<invoiceTaxLov.length; i++){
		invTaxObj = invoiceTaxLov[i];
		var invTaxOpt 	= new Element("option");
		var taxIdOpt	= new Element("option");
		var rateInvOpt	= new Element("option");

		invTaxOpt.setAttribute("perilSw", 	invTaxObj.perilSw);
		invTaxOpt.setAttribute("primarySw", invTaxObj.primarySw);
		invTaxOpt.setAttribute("rate",  	invTaxObj.rate);
		invTaxOpt.setAttribute("taxCd", 	invTaxObj.taxCd);
		invTaxOpt.setAttribute("value", 	invTaxObj.taxCd);
		invTaxOpt.innerHTML = invTaxObj.taxDesc;
		
		taxIdOpt.setAttribute("value",	invTaxObj.taxId);
		taxIdOpt.innerHTML = invTaxObj.taxId;
		
		rateInvOpt.setAttribute("value", invTaxObj.rate);
		rateInvOpt.innerHTML =	invTaxObj.rate;

		selTaxInvoice.insert(invTaxOpt);
		selTaxId.insert(taxIdOpt);
		selRateInv.insert(rateInvOpt);
	}
	
	selInvoiceTaxObj	= $("selInvoiceTax");
	selTaxIdObj			= $("selTaxId");
	selRateInvObj		= $("selRateInv");
	
	var intm;
	selIntermediary.update("<option></option>");
	for(var i=0; i<intermediaryLov.length; i++){
		var intermedOpt = new Element("option");
		intm = intermediaryLov[i];
		intermedOpt.setAttribute("value", intm.intmNo);
		intermedOpt.innerHTML = "" + intm.intmNo.toPaddedString(3) + " - " + intm.intmName;
		selIntermediary.insert(intermedOpt);
	}
	selIntermediaryObj = $("selIntermediary"); // makes the element accessible to invoice.js
}