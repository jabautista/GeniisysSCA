/** Sets back the values of the fields for Package Par Warranty and Clauses
 *  Module/s : GIPIS024A and GIPIS035A
 *  @author Veronica V. Raymundo
 *  January 20, 2011
 */
function resetWarrAndClauseFormFields(){
	disableButton("btnDelete");
	//$("warrantyTitleDisplay").hide();
	//$("selectWarrantyTitle").show();
	$("btnAdd").value = "Add";
	
	//$("warrantyTitleDisplay").value = "";
	//$("selectWarrantyTitle").value 	= "";
	$("searchWarrantyTitle").show();
	$("hidWcCd").value = "";
	$("txtWarrantyTitle").value = "";
	$("hidOrigWarrantyText").value = "";
	$("inputWarrantyTitle2").value  = "";
	$("inputWarrantyType").value    = "";
	$("inputPrintSeqNo").value 		= "";
	$("inputPrintSwitch").checked 	= false;
	$("inputChangeTag").checked 	= false;
	$("inputWarrantyText").value 	= "";
	$("inputWcRemarks").value		= "";
}