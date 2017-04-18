/*	Created by	: mark jm 02.24.2011
 * 	Description	: delete casualty personnel records on obj list and table list
 * 	Parameters	: itemNo - itemNo to be deleted
 */
function deleteFromCasualtyPersonnel(itemNo){
	try{
		$$("div#casualtyPersonnelTable div[item='" + itemNo + "']").each(function(row){
			if(row.hasClassName("selectedRow")){
				fireEvent(row, "click");
			}
			
			Effect.Fade(row, {
				duration : 0.3,
				afterFinish : function(){
					if(objGIPIWCasualtyPersonnel != null && (objGIPIWCasualtyPersonnel.filter(getRecordsWithSameItemNo)).length > 0){
						var delObj = new Object();

						delObj.parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						delObj.itemNo = itemNo;
						delObj.personnelNo = row.getAttribute("personnelNo");

						addDelObjByAttr(objGIPIWCasualtyPersonnel, delObj, "personnelNo");
						
						delete delObj;						
					}
					
					row.remove();
					checkIfToResizeTable2("casualtyPersonnelListing", "rowCasualtyPersonnel");
					checkTableIfEmpty2("rowCasualtyPersonnel", "casualtyPersonnelTable");
					setCasualtyPersonnelForm(null);
				}
			});
		});
	}catch(e){
		showErrorMessage("deleteFromCasualtyPersonnel", e);
	}
}