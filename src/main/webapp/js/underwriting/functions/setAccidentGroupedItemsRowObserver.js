/*	Created by	: mark jm 06.06.2011
 * 	Description	: set the observer for row
 * 	Parameters	: row - div
 */
function setAccidentGroupedItemsRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);
		row.observe("click", function(){
			row.toggleClassName("selectedRow");

			if(row.hasClassName("selectedRow")){
				($$("div#accidentGroupedItemsTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");						
				
				var objFilteredArr = objGIPIWGroupedItems.filter(
										function(obj){	
											return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && 
													obj.groupedItemNo == row.getAttribute("grpItem");	});
				
				for(var x=0, y=objFilteredArr.length; x<y; x++){						
					setAccidentGroupedItemForm(objFilteredArr[x], false);
					computeEndtCoverageTotals(row.getAttribute("item"), row.getAttribute("grpItem")); //added by steven 9/06/2012 
					cascadeAccidentGroup(objGIPIWItmperlGrouped, "coverageTable", "coverageListing", objFilteredArr[x].itemNo, objFilteredArr[x].groupedItemNo);
					($$("div#coverageListing div:not([item='" + objFilteredArr[x].itemNo + "'])")).invoke("hide"); // added by: Nica 10.08.2012
					resizeTableBasedOnVisibleRows("coverageTable", "coverageListing");
					cascadeAccidentGroup(objGIPIWGrpItemsBeneficiary, "bBeneficiaryTable", "bBeneficiaryListing", objFilteredArr[x].itemNo, objFilteredArr[x].groupedItemNo);
					computeEndtCoverageTotals(objFilteredArr[x].itemNo, objFilteredArr[x].groupedItemNo);
					// selectAccidentGroupedItemPerilOptionsToShow(objFilteredArr[x].groupedItemNo); // andrew - 01.10.2012 - comment out
					break;
				}						
			}else{
				var reqDivArray = ["coverageInfoDiv","beneficiaryInformationInfo"]; //added by steven 9/5/2012 to clear of the values in all the fields.
				$("cAggregateSw").checked = false;
				for ( var i = 0; i < reqDivArray.length; i++) {
					$$("div#"+reqDivArray[i]+" input[type='text'], div#"+reqDivArray[i]+" textarea, div#"+reqDivArray[i]+" select").each(function (a) {
						$(a).value = "";
					});
				}
				setAccidentGroupedItemForm(null, false);
				cascadeAccidentGroup(objGIPIWItmperlGrouped, "coverageTable", "coverageListing", null, null);
				cascadeAccidentGroup(objGIPIWGrpItemsBeneficiary, "bBeneficiaryTable", "bBeneficiaryListing", null, null);
				cascadeAccidentGroup(objGIPIWItmperlBeneficiary, "benPerilTable", "benPerilListing", null, null);
				
				hideAllGroupedItemPerilOptions();
				showGroupedBasicPerilsOnly();
			}			
		});
	}catch(e){
		showErrorMessage("setAccidentGroupedItemsRowObserver", e);
	}
}