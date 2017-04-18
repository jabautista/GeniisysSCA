/*	Created by	: mark jm 12.17.2010
 * 	Description	: set values on accessory form
 * 	Parameters	: obj - the record object
 */
function setAccessoryForm(obj){
	try{
		$("selAccessory").value 	= obj == null ? "" : obj.accessoryCd;
		$("accessoryAmount").value	= obj == null ? "0.00" : (obj.accAmt == null) ? "" : formatCurrency(obj.accAmt);
		$("txtAccessoryName").value	= obj == null ? "" : $("selAccessory").options[$("selAccessory").selectedIndex].text;
		$("btnAddA").value			= obj == null ? "Add" : "Update";

		obj == null ? disableButton($("btnDeleteA")) : enableButton($("btnDeleteA"));

		if(obj == null){
			$("selAccessory").show();
			$("txtAccessoryName").hide();
		}else{
			$("selAccessory").hide();
			$("txtAccessoryName").show();
		}
	}catch(e){
		showErrorMessage("setAccessoryForm", e);
	}	
}