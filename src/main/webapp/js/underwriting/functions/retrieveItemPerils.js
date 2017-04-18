/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	07.20.2011	mark jm			retrieve/show itemperil records
 * 								Parameters	: no more explanation :D 
 */
function retrieveItemPerils(parId, itemNo){
	try{
		var lineCd = objUWParList.lineCd;
		var sublineCd = objUWParList.sublineCd;
		var issCd = (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
		
		new Ajax.Updater("parItemPerilTable", contextPath+"/GIPIWItemPerilController?action=getGIPIWItemPerilTableGrid&parId="+parId+"&itemNo="+itemNo+"&lineCd="+lineCd+"&sublineCd="+sublineCd+"&issCd="+issCd+"&lineCd="+objUWParList.lineCd, {
			method : "POST",
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("parItemPerilTableGrid").hide();
			},
			onComplete : function(){
				$("parItemPerilTableGrid").show();
				deleteParItemTG(tbgPerilDeductible);				
			}
		});		
	}catch(e){
		showErrorMessage("retrieveItemPerils", e);
	}
}