function getParSeqNo(riFlag){
	if ($("globalParSeqNoC") != null){
		$("inputParSeqNo").value = $F("globalParSeqNoC");
	}
	$("linecd").disable();
	$("isscd").disable();
	$("year").disable();
	$("quoteSeqNo").disable();
	$("assuredNo").enable();
	$("remarks").enable();
	$("basicInformation").show();
	if ($("linecd").value == objLineCds.SU){
		$("basicInformation").innerHTML = "Bond Basic Information";
	} else {
		$("basicInformation").innerHTML = "Basic Information";
	}
	
	enableParCreationButtons(riFlag);
	if ("Y" == $F("fromQuote")){
		hideOverlay();
	}
	showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
	/*new Ajax.Request(contextPath+"/GIPIPARListController?action=getParSeqNo", {
		method: "POST",
		postBody: Form.serialize("uwParParametersForm"),
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Saving successful, now getting par seq no..."),
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				$("inputParSeqNo").value = response.responseText;
			}
			$("creatPARForm").enable();
			$$("form#creatPARForm input[type='button']").each(
				function(btn){	
					enableButton(btn.getAttribute("id"));								
				}
			);
			$("linecd").disable();
			$("isscd").disable();
			$("year").disable();
			$("quoteSeqNo").disable();
			$("basicInformation").show();
			//("inputParSeqNo").disable();
			hideNotice("SAVING SUCCESSFUL.");
		}
	});*/
}