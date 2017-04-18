function makeRecordEditable(className) {
	$$("."+className).each(function (i) {
		if(!(i.hasClassName("acctAmt"))) {
			i.readOnly = false;
			if (i instanceof HTMLSelectElement) {
				i.disabled=false;
			}
		}	
	});
	
	$("oscmBillCmNo").setStyle({display: 'block'});
	$("oscmInstNo").setStyle({display: 'block'});
}