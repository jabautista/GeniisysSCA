/**
 * Reset Peril Listing - if peril is already added in the selectedItem, remove
 * from list -- else, show - REMOVES options that have already been used
 * 
 * @return
 */
function setPerilNameLov(){
	var selectedItemNo = getSelectedRowId("itemRow");
	// check peril list of selected item and REMOVE(not HIDE) perils that have
	// already been added
	var selPerilName = $("selPerilName");
	var perilList = objGIPIQuoteItemPerilSummaryList;
	var aLovPeril = null;
	selPerilName.update("<option></option>");
	
	if(selectedItemNo.blank()){
		selectedItemNo = 0;
	}
	for(var index = 0; index < objItemPerilLov.length; index++){
		aLovPeril = objItemPerilLov[index];
		if(selectedItemNo > 0){ // List is NOT empty , show BASIC only
			if(perilList!=null){ // error prevention only
				if(!quotePerilListIsEmpty()){ // peril list not empty SHOW ALL unless it
					if(!isPerilAlreadyAdded(aLovPeril)){
						addPerilLov(selPerilName,aLovPeril);
					}
				}else{ // list exists but is empty
					if(aLovPeril.perilType!="A"){
						addPerilLov(selPerilName,aLovPeril);
					}
				}
			}
		}else{ // EMPTY LIST show only BASIC PERILS.
			if(aLovPeril.perilType=="B"){
				addPerilLov(selPerilName,aLovPeril);
			}
		}
	}
}