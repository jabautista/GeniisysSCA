// modified for createPackPar select quotation condition
function getPackParSeqNo2(){
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
		
		if($F("fromPackQuotation") == 'Y'){
			enableButton("btnReturnToQuotation");
			checkIfLineSublineExist();
		}else{
			showMessageBox("Saving Successful.", imgMessage.SUCCESS);
		}	
	}catch(e){
		showErrorMessage("getPackParSeqNo2", e);
	}
}