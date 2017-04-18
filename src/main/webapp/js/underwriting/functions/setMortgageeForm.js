/*	Created by	: mark jm 11.11.2010
 * 	Description	: set values on mortgagee form
 * 	Parameters	: obj - the record object
 */
function setMortgageeForm(obj){
	try{
		var modId = $("lblModuleId").getAttribute("moduleId"); //kenneth SR 5483 05.26.2016
		//$("mortgageeItemNo").value 	= (obj == null) ? ($("itemNo") == null ? 0 : $F("itemNo")) : obj.itemNo;						
		$("mortgageeName").value 	= (obj == null) ? "" : (obj.mortgCd).replace(" ", "_");
		$("mortgageeAmount").value 	= (obj == null) ? "" : (obj.amount == null ? "" : formatCurrency(obj.amount));
		$("txtMortgageeName").value	= (obj == null)	? "" : unescapeHTML2($("mortgageeName").options[$("mortgageeName").selectedIndex].text);
		$("btnAddMortgagee").value 	= (obj == null) ? "Add" : "Update";		
		if(modId == "GIPIS060" || modId == "GIPIS039"){ //kenneth SR 5483 05.26.2016
			$("chkDeleteSw").checked 	= (obj == null) ? false : (obj.deleteSw == "Y" ? true : false);
		} 
		
		(obj == null) ? disableButton($("btnDeleteMortgagee")) : enableButton($("btnDeleteMortgagee"));
		
		if(obj == null){		
			console.log("triggered");
			$("mortgageeName").show();
			$("txtMortgageeName").hide();
			$("chkDeleteSw").disabled=true; //MarkS SR 5483 09.06.2016
		}else{
			$("mortgageeName").hide();
			$("txtMortgageeName").show();
			$("chkDeleteSw").disabled=false; //MarkS SR 5483 09.06.2016
		}
	}catch(e){
		showErrorMessage("setMortgageeForm", e);
	}
}