/*	Created by	: mark jm 02.22.2011
 * 	Description	: set values on casualty personnel form
 * 	Parameters	: obj - the record object
 */
function setCasualtyPersonnelForm(obj){
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
	}catch(e){
		showMessageBox("setCasualtyPersonnelForm : " + e.message);
	}	
}