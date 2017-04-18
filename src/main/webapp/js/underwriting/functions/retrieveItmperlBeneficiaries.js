/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.05.2011	mark jm			show beneficiary perils records
 * 								Parameters	: no more explanation :D 
 * 	10.19.2011	mark jm			added new parameter (beneficiaryNo)
 */
function retrieveItmperlBeneficiaries(parId, itemNo, groupedItemNo, beneficiaryNo){
	try{		
		new Ajax.Updater("grpItemsBenPerilsTable", contextPath+"/GIPIWItmperlBeneficiaryController?action=getItmperlBeneficiaryTableGrid&parId="+parId+
				"&itemNo="+itemNo+"&groupedItemNo="+groupedItemNo+"&beneficiaryNo="+beneficiaryNo+"&refresh=0", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("grpItemsBenPerilsTable").hide();
			},
			onComplete: function(){
				$("grpItemsBenPerilsTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveItmperlBeneficiaries", e);
	}
}