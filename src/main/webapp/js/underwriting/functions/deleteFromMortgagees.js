/*	Created by	: mark jm 02.04.2011
 * 	Description	: delete mortgagee records on obj list and table list
 * 	Parameters	: itemNo - itemNo to be deleted
 */
function deleteFromMortgagees(itemNo){
	try{
		$$("#mortgageeTable div[item='" + itemNo + "']").each(function(row){			
			if(row.hasClassName("selectedRow")){
				fireEvent(row, "click");
			}

			Effect.Fade(row, {
				duration : .03,
				afterFinish : function(){
					if(objMortgagees != null && (objMortgagees.filter(getRecordsWithSameItemNo)).length > 0){
						var delObj = new Object();

						delObj.parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						delObj.itemNo = itemNo;
						delObj.mortgCd = row.getAttribute("mortgCd");

						addDelObjByAttr(objMortgagees, delObj, "mortgCd");

						delete delObj;							
					}
					
					row.remove();
					checkIfToResizeTable2("mortgageeListing", "rowMortg");
					checkTableIfEmpty2("rowMortg", "mortgageeTable");  
				}
			});
		});	
	}catch(e){
		showErrorMessage("deleteFromMortgagees", e);
	}	
}