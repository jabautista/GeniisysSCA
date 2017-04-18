/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.02.2011	mark jm			fill-up accessory form 
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setAccessoryFormTG(obj){
	try{
		$("accessoryCd").value 		= obj == null ? "" : obj.accessoryCd;
		$("accessoryAmount").value	= obj == null ? "0.00" : (obj.accAmt == null) ? "" : formatCurrency(obj.accAmt);
		$("accessoryDesc").value	= obj == null ? "" : unescapeHTML2(obj.accessoryDesc);
		$("btnAddA").value			= obj == null ? "Add" : "Update";		

		if(obj == null){
			$("hrefAccessory").show();
			disableButton($("btnDeleteA"));
		}else{
			$("hrefAccessory").hide();
			enableButton($("btnDeleteA"));
		}
		
		if($("txtTotalAmountAccessory") != null && $("txtTotalAmountAccessory") != undefined){
			$("txtTotalAmountAccessory").value = computeTotalAmt(objGIPIWMcAcc,
					function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == ((objCurrItem != null && objCurrItem.recordStatus != -1) ? objCurrItem.itemNo : 0); }, "accAmt");
		}
		
		($$("div#accessory [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessageTG("setAccessoryForm", e);
	}	
}