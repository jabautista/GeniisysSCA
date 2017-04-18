function getFireTariff(){
	try {
		new Ajax.Request(contextPath+"/GIPIWFireItmController", {
			method: "GET",
			parameters: {action: 		"getFireTariff",
						 globalParId:	$F("globalParId"),
						 itemNo: 		itemNo},
			onCreate: function (){
				setCursor("wait");
				//$("endtPerilForm").disable();
				showNotice("Retrieving fire tariff, please wait...");
			},
			onComplete: function(response) {
				setCursor("default");
				hideNotice("");										
				var resultArr = response.responseText.split("--");
				//$("endtPerilForm").enable();				
				
				if (resultArr[0] == "SUCCESS"){
					$("inputPremiumRate").value = formatToNineDecimal(resultArr[1]);
				} else {
					showMessageBox(response.responseText);
				}																				
			}						
		});
	} catch (e){
		showErrorMessage("getFireTariff", e);
		//showMessageBox("getFireTariff : " + e.message);
	}
}	