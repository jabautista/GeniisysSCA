/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.04.2011	mark jm			show grouped items beneficiary records
 * 								Parameters	: no more explanation :D 
 */
function retrieveGrpItemsBeneficiaries(parId, itemNo, groupedItemNo){
	try{		
		new Ajax.Updater("grpItemsBeneficiaryTable", contextPath+"/GIPIWGrpItemsBeneficiaryController?action=getGrpItemsBeneficiaryTableGrid&parId="+parId+
				"&itemNo="+itemNo+"&groupedItemNo="+groupedItemNo+"&refresh=0", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("grpItemsBeneficiaryTable").hide();
			},
			onComplete: function(){
				$("grpItemsBeneficiaryTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveGrpItemsBeneficiaries", e);
	}
}