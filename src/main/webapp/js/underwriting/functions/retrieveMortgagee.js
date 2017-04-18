/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	07.20.2011	mark jm			show mortgagee records
 * 								Parameters	: no more explanation :D 
 */
function retrieveMortgagee(parId, itemNo){
	try{
		//var itemNo = ($F("pageName") == "itemInformation" ? itemNo : 0);
		var issCd = (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
		
		new Ajax.Updater("mortgageeTable", contextPath+"/GIPIParMortgageeController?action=getGIPIWMortgageeTableGrid&parId="+parId+"&itemNo="+itemNo+"&issCd="+issCd, {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("mortgageeTable").hide();
			},
			onComplete: function(){
				$("mortgageeTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveMortgagee", e);
	}
}