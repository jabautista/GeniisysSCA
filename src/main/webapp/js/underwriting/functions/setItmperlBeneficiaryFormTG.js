/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.05.2011	mark jm			set values on beneficiary peril form (tablegrid version)
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setItmperlBeneficiaryFormTG(obj){
	try {		
		$("bpPerilCd").value	= obj == null ? "" : obj.perilCd;
		$("bpPerilName").value	= obj == null ? "" : unescapeHTML2(obj.perilName);
		$("bpTsiAmt").value		= obj == null ? "" : obj.tsiAmt == "" ? "" : formatCurrency(obj.tsiAmt);
		
		if(obj == null){
			disableButton($("btnDeleteBeneficiaryPerils"));
			$("btnAddBeneficiaryPerils").value = "Add";
			$("hrefBPPeril").show();
		}else{
			enableButton($("btnDeleteBeneficiaryPerils"));
			$("btnAddBeneficiaryPerils").value = "Update";
			$("hrefBPPeril").hide();
		}
		
		($$("div#grpItemsBenPerilsInfo [changed=changed]")).invoke("removeAttribute", "changed");
	} catch(e) {
		showErrorMessage("setItmperlBeneficiaryFormTG", e);
	}
}