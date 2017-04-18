/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.13.2011	mark jm			Fill-up fields with values in grouped items form
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setGroupedItemsFormTG(obj){
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
		
		if($("txtTotalAmountCoveredGroupedItems") != null && $("txtTotalAmountCoveredGroupedItems") != undefined){
			$("txtTotalAmountCoveredGroupedItems").value = computeTotalAmt(objGIPIWGroupedItems,
					function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == ((objCurrItem != null && objCurrItem.recordStatus != -1) ? objCurrItem.itemNo : 0); }, "amountCovered");
		}		
		
		//hideToolbarButtonInTG(tbgGroupedItems);
		($$("div#groupedItemsInfo [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("setGroupedItemsFormTG", e);
	}
}