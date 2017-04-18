/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.29.2011	mark jm			show beneficiary records
 * 								Parameters	: no more explanation :D 
 */
function retrieveBeneficiaries(parId, itemNo){
	try{		
		new Ajax.Updater("beneficiaryTable", contextPath+"/GIPIWBeneficiaryController?action=getGIPIWBeneficiaryTableGrid&parId="+parId+"&itemNo="+itemNo+"&refresh=0", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("beneficiaryTable").hide();
			},
			onComplete: function(){
				$("beneficiaryTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveBeneficiaries", e);
	}
}