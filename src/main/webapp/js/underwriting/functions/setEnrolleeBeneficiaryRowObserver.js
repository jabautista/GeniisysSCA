/*	Created by	: mark jm 06.06.2011
 * 	Description	: set the observer for row
 * 	Parameters	: row - div
 */
function setEnrolleeBeneficiaryRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){					
			row.toggleClassName("selectedRow");

			if(row.hasClassName("selectedRow")){
				($$("div#bBeneficiaryTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");						
				
				var objFilteredArr = objGIPIWGrpItemsBeneficiary.filter(
										function(obj){	
											return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && 
													obj.groupedItemNo == row.getAttribute("grpItem") && obj.beneficiaryNo == row.getAttribute("benNo");	});

				var fk;
				for(var x=0, y=objFilteredArr.length; x<y; x++){						
					setBBenForm(objFilteredArr[x]);
					fk = objFilteredArr[x].itemNo + "_" + objFilteredArr[x].groupedItemNo + "_" + objFilteredArr[x].beneficiaryNo;					
					($$("div#benPerilListing div:not([fk='" + fk + "'])")).invoke("hide");
					($$("div#benPerilListing div([fk='" + fk + "'])")).invoke("show");
					filterLOV3("bpPerilCd", "rowBenPeril", "perilCd", "benNo", objFilteredArr[x].beneficiaryNo);
					resizeTableBasedOnVisibleRows("benPerilTable", "benPerilListing");								
					break;
				}						
			}else{
				setBBenForm(null);
				if(($$("div#benPerilTable .selectedRow")).length > 0){
					fireEvent(($$("div#benPerilTable .selectedRow"))[0], "click");
				}
				$("benPerilTable").hide();
			}					
		});
	}catch(e){
		showErrorMessage("setEnrolleeBeneficiaryRowObserver", e);
	}
}