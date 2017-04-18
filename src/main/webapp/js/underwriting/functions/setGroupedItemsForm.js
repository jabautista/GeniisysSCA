/*	Created by	: mark jm 02.22.2011
 * 	Description	: set values on grouped items form
 * 	Parameters	: obj - the record object
 */
function setGroupedItemsForm(obj){
	try{
		$("txtGroupedItemNo").value		= obj == null ? getNextAddlInfoSequenceNo(objGIPIWGroupedItems, $F("itemNo"), "groupedItemNo") : obj.groupedItemNo;
		$("txtGroupedItemTitle").value	= obj == null ? "" : unescapeHTML2(obj.groupedItemTitle);
		$("txtAmountCovered").value		= obj == null ? "" : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
		$("selGroupedItemCd").value		= obj == null ? "" : obj.groupCd;
		$("txtRemarks").value			= obj == null ? "" : obj.remarks == null ? "" : unescapeHTML2(obj.remarks);

		$("btnAddGroupedItems").value	= obj == null ? "Add" : "Update";		 
		
		if(obj == null){
			disableButton($("btnDeleteGroupedItems"));
			$("txtGroupedItemNo").removeAttribute("readonly");			
		}else{
			enableButton($("btnDeleteGroupedItems"));
			$("txtGroupedItemNo").setAttribute("readonly", "readonly");						
		}
	}catch(e){
		showMessageBox("setGroupedItemsForm : " + e.message);
	}
}