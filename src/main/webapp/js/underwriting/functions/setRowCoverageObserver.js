/*	Created by	: mark jm 05.12.2011
 * 	Description	: set the observer for coverage record
 * 	Parameters	: row - record
 */
function setRowCoverageObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){					
			row.toggleClassName("selectedRow");

			if(row.hasClassName("selectedRow")){
				($$("div#coverageTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");						
				
				var objFilteredArr = objGIPIWItmperlGrouped.filter(
										function(obj){	
											return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && 
													obj.groupedItemNo == row.getAttribute("grpItem") && obj.perilCd == row.getAttribute("perilCd");	});
				
				for(var x=0, y=objFilteredArr.length; x<y; x++){						
					setCoverForm(objFilteredArr[x]);
					//cascade(objGIPIWGrpItemsBeneficiary, "bBeneficiaryTable", "bBeneficiaryListing", objFilteredArr[x].itemNo, objFilteredArr[x].groupedItemNo);
					break;
				}						
			}else{
				setCoverForm(null);
				//cascade(objGIPIWGrpItemsBeneficiary, "bBeneficiaryTable", "bBeneficiaryListing", null, null);
				//if(($$("div#bBeneficiaryTable .selectedRow")).length > 0){
				//	fireEvent(($$("div#bBeneficiaryTable .selectedRow"))[0], "click");
				//}
				//$("bBeneficiaryTable").hide();
			}					
		});
	}catch(e){
		showErrorMessage("setRowCoverageObserver", e);
	}
}