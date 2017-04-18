function prepareAcGroupedItemInfo(obj) {
	try {
		var gRow = "";
		if(obj != null) {
			var gItemNo = obj.groupedItemNo == null ? "---" : obj.groupedItemNo;
			var gItemTitle = (obj.groupedItemTitle == null || obj.groupedItemTitle.empty()) ? "&nbsp" : escapeHTML2(obj.groupedItemTitle).truncate(15, "...");
			var gPrincipal = obj.principalCd == null ? "---" : obj.principalCd;
			var gPackageCd = obj.packageCd == null ? "---" : obj.packageCd;
			var gPaytTerms = obj.paytTermsDesc == null || obj.paytTermsDesc.empty() ? "---" : escapeHTML2(obj.paytTermsDesc).truncate(10, "...");
			var gFromDate = obj.fromDate == null ? "---" : obj.dateFormatted == "Y" ?
							obj.fromDate : dateFormat(obj.fromDate, "mm-dd-yyyy");
			var gToDate = obj.toDate == null ? "---" : obj.dateFormatted == "Y" ?
					obj.toDate : dateFormat(obj.toDate, "mm-dd-yyyy");
			//var gFromDate = obj.fromDate == null ? "---" : obj.fromDate;
			//var gToDate = obj.toDate == null ? "---" : obj.toDate;
			var gTsi = obj.tsiAmt == null ? "---" : formatCurrency(obj.tsiAmt);
			var gPrem = obj.premAmt == null ? "---" : formatCurrency(obj.premAmt);

			gRow = '<label name="textG" id="num" style="text-align: left; width: 10%; margin-right: 2px">'+gItemNo+'</label>' +
				   '<label name="textG2" style="text-align: left; width: 12%; margin-right: 2px;">'+gItemTitle+'</label>' +
				   '<label name="textG" style="text-align: left; width: 11%; margin-right: 0px;">'+gPrincipal+'</label>' +
				   '<label name="textG3" style="text-align: left; width: 8%;  margin-right: 4px;">'+gPackageCd+'</label>' +
				   '<label name="textG2" style="text-align: left; width: 11%; margin-right: 2px;">'+gPaytTerms+'</label>' +
				   '<label name="textG" style="text-align: left; width: 12%; margin-right: 3px;">'+gFromDate+'</label>' +
				   '<label name="textG" style="text-align: left; width: 10%; margin-right: 2px;">'+gToDate+'</label>' +
				   '<label name="textG" style="text-align: left; width: 9%; margin-right: 2px; text-align:right;" class="money">'+gTsi+'</label>' +
				   '<label name="textG" style="text-align: left; width: 14%; margin-right: 2px; text-align:right;" class="money">'+gPrem+'</label>';
		}
		return gRow;
	} catch(e) {
		showErrorMessage("prepareAcGroupedItemInfo", e);
	}
}