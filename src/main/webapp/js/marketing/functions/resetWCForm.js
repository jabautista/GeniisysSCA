// reset/clear fields of warranties and clauses form
function resetWCForm(){
	//$("warrantyTitle").show();
	//$("warrantyTitle").selectedIndex = 0; emsy 11.17.2011 
	$("warratyTitleDisplay").value = "";
	$("warrantyClauseType").value = "";
	$("printSwitch").checked = false;
	$("changeTag").checked = false;
	$("warrantyTitle2").value = "";
	$("printSeqNumber").value = getNewPrintSeqNo();//""; generates a new print seq no. BRY 12.23.2010
	// grace 10.6.10 remove all references to SWC No.
	//$("swcNo").value = "";
	$("warrantyText").value = "";
	//$("warrantyTitleDisplay").hide(); // compute default value 
	//$("warrantyTitle").show(); emsy 11.22.2011
	$("warratyTitleDisplay").hide();
	$("warratyTitleDisplay").show();
	$("warratyTitleDisplay").clear();
	$("btnDelete").disable();
	$("btnAdd").value = "Add";
	disableButton("btnDelete");
	//checkIfToResizeTable("wcDiv", "row");//added row resize table when over 5 BJGA12.23.2010
	//checkTableIfEmpty("row", "wcDiv");//added row resize table when over 5 BJGA12.23.2010
	($$("div#cwDivAndFormDiv [changed=changed]")).invoke("removeAttribute", "changed"); // added irwin
}