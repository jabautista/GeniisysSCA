function prepareDirectPremCollnInfo(obj) {
	try {
		var directPremCollnInfo = 
			'<label name="lblAssName" style="margin-left: 6px; width: 140px; text-align: left;">' + obj.assdName.truncate(18, "...") + '</label>' +
			'<label name="lbltranType" style="margin-left: 10px; width: 80px; text-align: center;">' + obj.tranType + '</label> ' +
			'<label name="lblIssCd" style="width: 80px; text-align: center; margin-left: 8px;">' + obj.issCd + '</label>' +
			'<label name="lblPremSeqNo" style="width: 90px; text-align: center; margin-left: 8px;">'  + obj.premSeqNo + '</label>' +
			'<label name="lblInstNo" style="width: 70px; text-align: center; margin-left: 7px;">' + obj.instNo + '</label>' +
			'<label name="lblCollAmt" style="width: 125px; text-align: right; margin-left: 8px;">' + formatCurrency(obj.collAmt) + '</label>' +
			'<label name="lblPremAmt" style="width: 125px; text-align: right; margin-left: 5px;">' + formatCurrency(obj.premAmt) + '</label>' +
			'<label name="lblTaxAmt" style="width: 100px; text-align: right; margin-left: 0px; ">' + formatCurrency(obj.taxAmt) + '</label>';
		
		if(obj.incTag == "Y") {
			directPremCollnInfo = directPremCollnInfo +
				'<img class="printCheck" style="width: 10px; height: 10px; text-align: center; display: block; float: right; margin-right: 1px;" src="/Geniisys/css/image_themes/check-darkblue.gif" name="checkedImg">';
		}
			
		return directPremCollnInfo;
	}  catch (e) {
		showErrorMessage("prepareDirectPremCollnInfo", e);
		// showMessageBox("prepareTaxCollectionsInfo" + e.message);
	}
	
}