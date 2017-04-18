/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	07.21.2011	mark jm			retireve/show deductible records
 * 								Parameters	: no more explanation :D 
 */
function retrieveDeductibles(parId, itemNo, dedLevel, perilCd){	
	try{
		var url = "";
		var table = "";
		
		if(dedLevel == 1){
			table = "policyDeductibleTable";
			url = "/GIPIWDeductibleController?action=getPolicyDeductibleTableGrid&parId="+parId+"&itemNo="+itemNo+"&dedLevel="+dedLevel;
		}else if(dedLevel == 2){
			table = "itemDeductibleTable";
			url = "/GIPIWDeductibleController?action=getItemDeductibleTableGrid&parId="+parId+"&itemNo="+itemNo+"&dedLevel="+dedLevel;
		}else if(dedLevel == 3){
			table = "perilDeductibleTable";
			url = "/GIPIWDeductibleController?action=getPerilDeductibleTableGrid&parId="+parId+"&itemNo="+itemNo+"&dedLevel="+dedLevel+"&perilCd="+perilCd;
		}
		
		new Ajax.Updater(table, contextPath+url, {
			method : "GET",
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){				
				$(table).hide();
			},
			onComplete : function(){				
				$(table).show();				
			}
		});		
	}catch(e){
		showErrorMessage("retrieveItemDeductibles", e);
	}
}