function clearAddDocFields(){
	$("document").selectedIndex 		= 0;
	$("document").enable();
	$("docCd").value					= "";
	$("dateSubmitted").value 			= "";//$("currentDate").value;
	$("user").value 					= $F("defaultUser");
	$("remarks").value 					= "";
	$("postSwitch").checked 			= false;
	$("document").show();
	$("txtDocName").hide();
	("txtDocName").value				= "";
	$("btnAddDocument").value			= "Add";
	disableButton("btnDeleteDocument");
}