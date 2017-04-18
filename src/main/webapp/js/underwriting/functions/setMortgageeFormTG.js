/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	xx.xx.xxxx	mark jm			set values on mortgagee form
 * 	11.18.2011	mark jm			remove changed attribute by invoking 
 */
function setMortgageeFormTG(obj){
	try{
		$("mortgageeName").value 	= (obj == null) ? "" : unescapeHTML2(obj.mortgName);
		$("mortgageeAmount").value 	= (obj == null) ? "" : (obj.amount == null ? "" : formatCurrency(obj.amount));		
		
		if($("mortgCd") != null){
			$("mortgCd").value		= (obj == null) ? "" : obj.mortgCd;
		}
		
		if($("mortgageeRemarks") != null){
			$("mortgageeRemarks").value	= (obj == null) ? "" : unescapeHTML2(obj.remarks);
		}
		
		$("btnAddMortgagee").value 	= (obj == null) ? "Add" : "Update";		
		
		$("chkDeleteSw").checked = obj == null ? false : obj.deleteSw == "Y" ? true : false; //kenneth SR 5483 05.26.2016
		
		if(obj == null){				
			$("hrefMortgagee").show();
			disableButton($("btnDeleteMortgagee"));
			$("chkDeleteSw").disabled=true; //MarkS SR 5483 09.06.2016
		}else{			
			$("hrefMortgagee").hide();
			enableButton($("btnDeleteMortgagee"));
			$("chkDeleteSw").disabled=false; //MarkS SR 5483 09.06.2016
		}
		
		($$("div#mortgageeInfo [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("setMortgageeForm", e);
	}
}