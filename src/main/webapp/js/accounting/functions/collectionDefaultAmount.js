// PROCEDURES
//collection_default_amount or collection_dflt_amt_for_4, depending on the parameter value
function collectionDefaultAmount(tranType) {
	var ok = true;
	
	new Ajax.Request(contextPath+"/GIACPremDepositController?action=collectionDefaultAmount", {
		evalScripts: true,
		asynchronous: true,
		method: "GET",
		parameters: {
			gaccTranId: objACGlobal.gaccTranId,
			transactionType: tranType,
			dspTranYear: $F("txtTranYear"),
			dspTranMonth: $F("txtTranMonth"),
			dspTranSeqNo: $F("txtTranSeqNo"),
			oldItemNo: $F("txtOldItemNo"),
			defaultValue: $F("txtDefaultValue"),
			oldTranId: $F("txtOldTranId"),
			varPckSwtch: $F("varPckSwitch"),
			varPckTotColl: $F("varPckTotColl"),
			varPckTotColl2: $F("varPckTotColl2"),
			varPckGcbaGti: $F("varPckGcbaGti"),
			varPckGcbaIn: $F("varPckGcbaIn")
		},
		onComplete: function(response) {
			if (checkCustomErrorOnResponse(response)) {
				var result = response.responseText.toQueryParams();

				if (result.message != "SUCCESS") {
					showMessageBox(result.message, imgMessage.INFO);
					ok = false;
				}

				$("txtDefaultValue").value = result.defaultValue;
				$("txtOldTranId").value = result.oldTranId;
				$("varPckSwitch").value = result.varPckSwtch;
				$("varPckTotColl").value = result.varPckTotColl;
				$("varPckTotColl2").value = result.varPckTotColl2;
				$("varPckGcbaGti").value = result.varPckGcbaGti;
				$("varPckGcbaIn").value = result.varPckGcbaIn;
			} else{
				showMessageBox(response.responseText, imgMessage.ERROR);
				ok = false;
			}
		}
	});
	return ok;
}