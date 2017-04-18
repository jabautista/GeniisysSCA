function validateTsiAmt2(){
	var result = true;
	var itemNo = $F("itemNo");
	var tsiAmt = $F("perilTsiAmt").replace(/,/g, "");
	tsiAmt = (tsiAmt == "") ? 0.00 : parseFloat(tsiAmt);
	var perilRate = $("perilRate").value;
	var perilExistsForCurrentItem = false;
	var highestAlliedTsiAmt = getHighestAlliedTsiAmt(itemNo);
	var highestBasicTsiAmt = getHighestBasicTsiAmt(itemNo);
	
	
	
	if (tsiAmt < 0.00 || tsiAmt > 99999999999999.99) {
		$("perilTsiAmt").focus();
		$("perilTsiAmt").value = "";
		showMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
		result = false;
	} else { //if TSI value input is valid
		var bascPerlCd = $("bascPerlCd").value;
		var perilType = $("perilType").value;
		if (bascPerlCd == ""){
			if (perilType == "A"){
				if (tsiAmt > highestBasicTsiAmt){
					result = false;
					$("perilTsiAmt").value = "";
					$("perilTsiAmt").focus();
					showMessageBox("TSI Amount must not be greater than "+formatCurrency(highestBasicTsiAmt)+".", imgMessage.ERROR);
				}
			}
		} else { //if chosen peril has a basic peril
			$$("div[name='row2']").each(function(row){
				if (row.getAttribute("item") == itemNo){
					if (row.getAttribute("peril") == bascPerlCd){
						var bascPerlTsiAmt = parseFloat(row.down("input", 5).value.replace(/,/g, ""));
						if (tsiAmt > bascPerlTsiAmt){
							showMessageBox("TSI Amount must not be greater than "+formatCurrency(bascPerlTsiAmt)+".", imgMessage.ERROR);
							result = false;
							$("premiumAmt").value = ""; 
							$("perilTsiAmt").value = "";
							$("perilTsiAmt").focus();
						} 
					}	
				} 
			});
		}
	}
	return result;
}