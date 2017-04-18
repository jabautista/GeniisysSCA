function prepareGrpCoverageInfo(obj) {
	try {
		var cRow = "";
		if(obj != null) {
			var grpItemTitle = obj.groupItemTitle == null ? "---" : escapeHTML2(obj.groupedItemTitle).truncate(15, "...");
			var perilName = obj.perilName == null ? "---" : escapeHTML2(obj.perilName).truncate(15, "...");
			var premRt = obj.premRt == null ? "---" : obj.premRt;
			var tsiAmt = obj.tsiAmt == null ? "---" : formatCurrency(obj.tsiAmt);
			var premAmt = obj.premAmt == null ? "---" : formatCurrency(obj.premAmt);
			var noOfDays = obj.noOfDays == null ? "---" : obj.noOfDays;
			var baseAmt = obj.baseAmt == null ? "---" : obj.baseAmt;
			var aggregateSw = obj.aggregateSw == "Y" ? 
					"<img name='checkedImg' class='printCheck' style='width: 10px; height: 10px; text-align: center; display: block; margin-left: 10px;'/>" :
					"<span style='width: 10px; height: 10px; text-align: left; display: block;' ></span>";

			cRow = 	'<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">'+grpItemTitle+'</label>'+
					'<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">'+perilName+'</label>'+
					'<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;" class="moneyRate">'+premRt+'</label>'+
					'<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">'+tsiAmt+'</label>'+
					'<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">'+premAmt+'</label>'+
					'<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;">'+noOfDays+'</label>'+
					'<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">'+baseAmt+'</label>'+
					'<label name="textAggregate" style="width: 3%; text-align: center;">'+aggregateSw+'</label>';
		}
		return cRow;
	} catch(e) {
		showErrorMessage("prepareGrpCoverageInfo", e);
	}		
}