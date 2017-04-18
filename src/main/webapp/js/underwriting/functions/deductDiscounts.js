function deductDiscounts(){
	var itemNo = $F("itemNo");
	$("deldiscSw").value = "Y";
	$("discExists").value = "N";
	new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=deleteDiscounts&globalParId="+$F("globalParId")+"&itemNo="+itemNo,{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Deleting discounts..."),
		onComplete:function(response){
			if (checkErrorOnResponse(response)) {
				var amt = response.responseText;
				var amts = amt.split(",");
				$("masterPremAmt"+itemNo).value = formatCurrency(amts[0]);
				$("masterAnnPremAmt"+itemNo).value = formatCurrency(amts[1]);
				$("itemInformationForm").enable();
				loadPerilListingTable();
				disableButton("btnDeleteDiscounts");
				$("discDeleted"+itemNo).value = "Y";
				$("tempItemNumbers").value = $F("tempItemNumbers") + itemNo + " ";
				//saveWItemPerilPageChanges(1);
			}
		}
	});
}