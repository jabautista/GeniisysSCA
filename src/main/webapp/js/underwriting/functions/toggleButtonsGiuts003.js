function toggleButtonsGiuts003(){
	if($F("spldFlag") == 1){
		enableButton("btnSpoilPolicy");
		disableButton("btnUnspoilPolicy");
		disableButton("btnPostSpoilage");
	}else if($F("spldFlag") == 3){
		disableButton("btnSpoilPolicy");
		disableButton("btnUnspoilPolicy");
		disableButton("btnPostSpoilage");
	}else{
		disableButton("btnSpoilPolicy");
		enableButton("btnUnspoilPolicy");
		enableButton("btnPostSpoilage");
	}
	$("lineCd").setAttribute("readonly", "readonly");
	$("sublineCd").setAttribute("readonly", "readonly");
	$("issCd").setAttribute("readonly", "readonly");
	$("issueYy").setAttribute("readonly", "readonly");
	$("polSeqNo").setAttribute("readonly", "readonly");
	$("renewNo").setAttribute("readonly", "readonly");
	$("spoilCd").removeAttribute("readonly");
}