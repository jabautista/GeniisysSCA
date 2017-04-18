/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.01.2011	mark jm			add new item to the list (table grid) and object list
 */
function addParItemTG(){
	try{
		var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
		var newObj = setParItemObj();
		
		if($F("btnAddItem") == "Update"){
			// mark jm 01.20.2012 set miscNbtInvoiceSw to "N" when updating items
			objFormMiscVariables.miscNbtInvoiceSw = "N";
			
			addModifiedJSONObject(objGIPIWItem, newObj);
			//tbgItemTable.updateRowAt(newObj, tbgItemTable.getCurrentPosition()[1]);
			tbgItemTable.updateVisibleRowOnly(newObj, tbgItemTable.getCurrentPosition()[1]);			
		}else{
			tbgItemTable.addBottomRow(newObj);
			addNewJSONObject(objGIPIWItem, newObj);
		}
		
		setParItemFormTG(null);
		clearItemRelatedTableGrid();
		clearItemRelatedDetails();
		
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#additionalItemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#personalAdditionalInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#marineHullAdditionalItemInformation [changed=changed]")).invoke("removeAttribute", "changed");		
		if (lineCd == "FI") {
			$("zoneDiv").removeAttribute("zoned");	//Gzelle 05252015 SR4347
		}		
	}catch(e){
		showErrorMessage("addParItemTG", e);
	}
}