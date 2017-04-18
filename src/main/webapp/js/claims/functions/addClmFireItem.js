/**
 * Add new fire item info record
 * 
 * @author Niknok Orio
 * @param
 */
function addClmFireItem(){
	try{
		if (objCLMItem.selected != {} || objCLMItem.selected != null) if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
		//if (nvl(objCLMItem.ora2010Sw,"N") == "Y"){ // comment ko muna - nok }
													// &&
													// (itemGrid.getModifiedRows().length
													// != 0 ||
													// itemGrid.getNewRowsAdded().length
													// != 0)){
			if (nvl(objCLMGlobal.districtNo,"") != $F("txtDistrictNo") || nvl(objCLMGlobal.blockNo,"") != $F("txtBlockNo")){
				if (!checkBlockDistrictNo()) return false;
			}else{
				addClmItem();
			}
		/*}else{
			addClmItem();
		}*/ //if block commented by angelo 03.26.2014 to allow validation
	}catch(e){
		showErrorMessage("addClmFireItem", e);
	}
}