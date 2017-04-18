function showQuoteTaxChargesLOV(lineCd, issCd, quoteId, notIn){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getGIISTaxChargesLOV",
						lineCd : lineCd,
						issCd : issCd,
						quoteId : quoteId,
						notIn : nvl(notIn, ""),
						page : 1},
		title: "Tax Charges",
		width: 660,
		height: 320,
		columnModel : 	[{	id : "taxCd",
							title: "Tax Code",
							width: '70px'
						},
						{	id : "taxDesc",
							title: "Tax Description",
							width: '250px'
						},
						{	id : "rate",
							title: "Rate",
							width: '100px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id : "lineCd",
							title: "Line",
							width: '72px'
						},
						{	id : "issCd",
							title: "Issue Cd",
							width: '72px'
						},
						{	id : "taxId",
							title: "Tax Id",
							width: '72px'
						},
					],
		draggable: true,
		onSelect: function(row){
			if(row != undefined){
				$("txtTaxCharges").value = unescapeHTML2(row.taxDesc);
				$("txtTaxCharges").writeAttribute("taxCd", row.taxCd);
				$("txtTaxCharges").writeAttribute("taxId", row.taxId);
				$("txtTaxCharges").writeAttribute("lineCd", row.lineCd);
				$("txtTaxCharges").writeAttribute("issCd", row.issCd);
				$("txtTaxCharges").writeAttribute("rate", row.rate);
				$("txtTaxCharges").writeAttribute("primarySw", row.primarySw);
				if(objMKGlobal.packQuoteId != null){
					$("txtTaxValue").value =  computeDefaultTaxAmountForPackQuotation(row.perilSw, row.rate, row.perilCd);
				}
			}
		}
	  });
	
	
}