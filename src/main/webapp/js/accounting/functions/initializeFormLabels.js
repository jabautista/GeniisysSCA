function initializeFormLabels() {
	if (objACGlobal.previousModule == "GIACS003") { // added by steven
													// 04.08.2013
		$("lblOrNo").innerHTML = "JV No:";
		$("lblOrNo").title = "JV No:";
		$("lblOrStatus").innerHTML = "Status:";
		$("lblOrStatus").title = "Status:";
		$("lblOrDate").innerHTML = "Tran Date:";
		$("lblOrDate").title = "Tran Date:";

		/*
		 * $("lblOrNo").innerHTML = "Payt Req No:"; $("lblOrNo").title = "Payt
		 * Req No:"; $("lblOrStatus").innerHTML = "Req Status:";
		 * $("lblOrStatus").title = "Req Status:"; $("lblOrDate").innerHTML =
		 * "Request Date:"; $("lblOrDate").title = "Request Date:";
		 */
	} else if (objACGlobal.previousModule == "GIACS016") {
		$("lblOrNo").innerHTML = "Payt Req No.";
		$("lblOrNo").title = "Payt Req No.";
		$("lblOrStatus").innerHTML = "Req Status";
		$("lblOrStatus").title = "Req Status";
		$("lblOrDate").innerHTML = "Request Date";
		$("lblOrDate").title = "Request Date";
	} else if (objACGlobal.previousModule == "GIACS071") {
		$("lblOrNo").innerHTML = "Memo No:";
		$("lblOrNo").title = "Memo No:";
		$("lblOrStatus").innerHTML = "Status:";
		$("lblOrStatus").title = "Status:";
		$("lblOrDate").innerHTML = "Memo Date:";
		$("lblOrDate").title = "Memo Date:";
	} else if (objACGlobal.previousModule == "GIACS002") {
		$("lblOrNo").innerHTML = "DV No.";
		$("lblOrNo").title = "DV No.";
		$("lblOrStatus").innerHTML = "DV Status";
		$("lblOrStatus").title = "DV Status";
		$("lblOrDate").innerHTML = "DV Date";
		$("lblOrDate").title = "DV Date";
	} else if (objACGlobal.previousModule == "GIACS070"){ //added by shan 08.29.2013
		if (objACGlobal.tranSource == "DV"){
			if (objACGlobal.callingForm == "DISB_REQ"){
				$("lblOrNo").innerHTML = "Payt. Req No.:";
				$("lblOrStatus").innerHTML = "Req Status:";
				$("lblOrDate").innerHTML = "Request Date:";
				$("lblOrNo").title = "Payt. Req No.";
				$("lblOrStatus").title = "Req Status";
				$("lblOrDate").title = "Request Date";
			}else if (objACGlobal.callingForm == "DETAILS"){
				$("lblOrNo").innerHTML = "DV No.:";
				$("lblOrStatus").innerHTML = "DV Status:";
				$("lblOrDate").innerHTML = "DV Date:";
				$("lblOrNo").title = "DV No.";
				$("lblOrStatus").title = "DV Status";
				$("lblOrDate").title = "DV Date";
			}			
		}else if (objACGlobal.tranSource == "JV"){
			$("lblOrNo").innerHTML = "JV No:";
			$("lblOrNo").title = "JV No:";
			$("lblOrStatus").innerHTML = "Status:";
			$("lblOrStatus").title = "Status:";
			$("lblOrDate").innerHTML = "Tran Date:";
			$("lblOrDate").title = "Tran Date:";
		}
	}else {
		if (objACGlobal.opTag == "" || objACGlobal.opTag == null) {
			$("lblOrNo").innerHTML = 'OR No:';
			$("lblOrStatus").innerHTML = 'OR Status:';
			$("lblOrDate").innerHTML = 'OR Date:';
			$("lblAmount").innerHTML = 'Amount:';
			$("lblLocAmt").innerHTML = 'Loc. Amt:';
		} else {
			$("lblOrNo").innerHTML = 'OP No:';
			$("lblOrStatus").innerHTML = 'OP Status:';
			$("lblOrDate").innerHTML = 'OP Date:';
			$("lblAmount").innerHTML = 'Amount:';
			$("lblLocAmt").innerHTML = 'Loc. Amt:';
		}
	}
	if (objACGlobal.calledForm == "") {
		if (objACGlobal.callingForm == 'DETAILS') {
			if (objACGlobal.withPdc == 'N') {
				objACGlobal.callingForm = 'GIACS004';
				objACGlobal.calledForm = 'GIACS007';
			} else {
				objACGlobal.callingForm = 'GIACS004';
				objACGlobal.calledForm = 'GIACS031';
			}
		} else if (objACGlobal.callingForm == 'ACCT_ENTRIES') {
			objACGlobal.callingForm = 'GIACS004';
			objACGlobal.calledForm = 'GIACS030';
		} else if (objACGlobal.callingForm == 'OR_PREVIEW') {
			objACGlobal.callingForm = 'GIACS004';
			objACGlobal.calledForm = 'GIACS025';
		}
	}
}