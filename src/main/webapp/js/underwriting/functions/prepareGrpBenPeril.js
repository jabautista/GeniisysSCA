function prepareGrpBenPeril(obj) {	
	try {
		var benPeril = "";
		if(obj != null) {
			var perilName 	= obj.perilName == null ? "---" : escapeHTML2(obj.perilName).truncate(20, "...");
			var tsiAmt		= obj.tsiAmt == null ? "---" : formatCurrency(obj.tsiAmt);
			benPeril = 	'<label style="text-align: left; width: 45%; margin-right: 10px;">'+ perilName +'</label>' +
						'<label style="text-align: right; width: 45%;" class="money">'+ tsiAmt +'</label>';
		}
		return benPeril;
	} catch(e) {
		showErrorMessage("prepareGrpBenPeril", e);
	}
} 