/**
* Populate quote item mortgagee form with values.
* @param mortgageeObj - JSON Object that contains the quote item mortgagee information. Set mortgageeObj
* 				        to null to reset quote item mortgagee form. 
*/

function setQuoteMortgageeInfoForm(mortgageeObj){
	$("selMortgagee").value 		= mortgageeObj == null ? "" : unescapeHTML2(mortgageeObj.mortgCd);
	$("txtMortgageeAmount").value 	= mortgageeObj == null ? "" : mortgageeObj.amount == null ? "" :formatCurrency(mortgageeObj.amount);
	$("txtMortgageeDisplay").value 	= $("selMortgagee").options[$("selMortgagee").selectedIndex].text; 
	
	$("btnAddMortgagee").value = mortgageeObj == null ? "Add Mortgagee" : "Update Mortgagee";
	(mortgageeObj == null ? disableButton($("btnDeleteMortgagee")) : enableButton($("btnDeleteMortgagee")));
	
	if(mortgageeObj != null){
		$("selMortgagee").hide();
		$("txtMortgageeDisplay").show();
	}else{
		$("selMortgagee").show();
		$("txtMortgageeDisplay").hide();
	}
}