/*	Created by	: mark jm 10.19.2010
 * 	Description	: loads detail to the screen when a certain record is selected
 * 	Parameter	: rowName - name of row used in table record listing
 * 				: obj - object that holds the record
 */
function setValues(rowName, obj){
	try{
		if(rowName == "rowGroupedItem"){
			$("txtGroupedItemNo").value		= obj == null ? "" : obj.groupedItemNo;
			$("txtGroupedItemTitle").value	= obj == null ? "" : obj.groupedItemTitle;
			$("txtAmountCovered").value		= obj == null ? "" : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
			$("selGroupedItemCd").value		= obj == null ? "" : obj.groupCd;
			$("txtRemarks").value			= obj == null ? "" : obj.remarks == null ? "" : unescapeHTML2(obj.remarks);

			$("btnAddGroupedItems").value	= obj == null ? "Add" : "Update";
			(obj == null) ? disableButton($("btnDeleteGroupedItems")) : enableButton($("btnDeleteGroupedItems"));
			//setUnsetPrimaryKeyFieldsToReadOnly(obj == null ? false : true);
		}else if(rowName == "rowCasualtyPersonnel"){
			$("txtPersonnelNo").value		= obj == null ? null : obj.personnelNo;
			$("txtPersonnelName").value		= obj == null ? null : obj.personnelName;
			$("txtAmountCoveredP").value	= obj == null ? null : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
			$("selCapacityCdP").value		= obj == null ? null : obj.capacityCd;
			$("txtRemarksP").value			= obj == null ? null : obj.remarks == null ? "" : unescapeHTML2(obj.remarks);
	
			$("btnAddPersonnel").value		= obj == null ? "Add" : "Update";
			(obj == null) ? disableButton($("btnDeletePersonnel")) : enableButton($("btnDeletePersonnel"));
			//setUnsetPrimaryKeyFieldsToReadOnly(obj == null ? false : true);
		} else if (rowName == "rowCarrier") { // andrew - 11.18.2010 - added this else if block for carrier listing
			setCarrierForm(obj);
		}
	}catch(e){
		showErrorMessage("setValues", e);
		//showMessageBox("setValues : " + e.message);
	}
}