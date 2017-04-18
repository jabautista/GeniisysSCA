function getPackParSeqNo(){
	try{
		if($("globalParSeqNo").value != null && $("parSeqNo") != null){
			$("parSeqNo").value = $("globalParSeqNo").value == "" ? "" : parseInt($("globalParSeqNo").value).toPaddedString(4); 
		}
		$("packBasicInformation").show();
		$("packLineCdSel").disable();
		$("packIssCd").disable();
		$("year").readOnly = true;
		$("btnCreateNew").show();
		enableButton("btnCreateNew");
		$("packParId").value = $("globalPackParId").value;
		
		showMessageBox("Saving Successful.", imgMessage.SUCCESS);
		/*new Ajax.Request(contextPath+"/GIPIPackPARListController?action=getPackParSeqNo", {
			method: "POST",
			postBody: Form.serialize("uwParParametersForm"),
			evalScripts: true,
			asynchronous: true,
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					$("parSeqNo").value = response.responseText;
				}
			}
		}); commented by: nica 01.11.2011*/
	}catch(e){
		showErrorMessage("getPackParSeqNo", e);
	}
}