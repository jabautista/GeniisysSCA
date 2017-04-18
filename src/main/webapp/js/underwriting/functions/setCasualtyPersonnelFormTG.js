/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.13.2011	mark jm			Fill-up fields with values in casualty personnel form
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setCasualtyPersonnelFormTG(obj){
	try{
		$("txtPersonnelNo").value		= obj == null ? getNextAddlInfoSequenceNo(objGIPIWCasualtyPersonnel, $F("itemNo"), "personnelNo") : obj.personnelNo;
		$("txtPersonnelName").value		= obj == null ? "" : unescapeHTML2(obj.personnelName);
		$("txtAmountCoveredP").value	= obj == null ? "" : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
		$("selCapacityCdP").value		= obj == null ? "" : obj.capacityCd;
		$("txtRemarksP").value			= obj == null ? "" : obj.remarks == null ? "" : unescapeHTML2(obj.remarks);

		$("btnAddPersonnel").value		= obj == null ? "Add" : "Update";		
		
		if(obj == null){
			disableButton($("btnDeletePersonnel"));
			$("txtPersonnelNo").removeAttribute("readonly");			
		}else{
			enableButton($("btnDeletePersonnel"));
			$("txtPersonnelNo").setAttribute("readonly", "readonly");			
		}
		
		if($("txtTotalAmountCoveredCasualtyPersonnel") != null && $("txtTotalAmountCoveredCasualtyPersonnel") != undefined){
			$("txtTotalAmountCoveredCasualtyPersonnel").value = computeTotalAmt(objGIPIWCasualtyPersonnel,
					function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == ((objCurrItem != null && objCurrItem.recordStatus != -1) ? objCurrItem.itemNo : 0); }, "amountCovered");
		}
		
		//hideToolbarButtonInTG(tbgCasualtyPersonnel);
		($$("div#personnelInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("setCasualtyPersonnelFormTG", e);
	}	
}