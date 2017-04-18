function clearParCreationFields(){
	$("assuredNo").value = "";
	$("address1").value = "";
	$("address2").value = "";
	$("address3").value = "";
	$("vlineCd").value = "";
	$("vissCd").value = "";
	$("sublineCd").value = "";
	$("linecd").value = "";
	$("sublinecd").value = "";
	$("year").value = $("defaultYear").value;
	$("inputParSeqNo").value = "";
	$("quoteSeqNo").value = "00";
	$("assuredName").value = "";
	$("remarks").value = "";
	//$("isscd").selectedIndex = 0;
	setIssCdToDefault();
	$("linecd").selectedIndex = 0;
	$("basicInformation").hide();
	$("basicInformation").innerHTML = "Basic Information";
}