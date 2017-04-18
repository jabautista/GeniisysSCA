function showMortgageeInfoModal(parId, itemNo){
	var itemNo = ($F("pageName") == "itemInformation" ? 1 : 0);
	var issCd = (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd")); // modified by andrew - 03.18.2011
	new Ajax.Updater("mortgageeInfo", contextPath+"/GIPIParMortgageeController?action=getItemParMortgagee&parId="+parId+"&itemNo="+itemNo+"&issCd="+issCd, {
		method: "GET",
		asynchronous: true,
		evalScripts: true,
		onCreate: function(){
			//showNotice("Retrieving mortgagee, please wait...");
		},
		onComplete: function(){
			hideNotice("Retrieving complete!");
		}
	});
	
	/*Modalbox.show(contextPath+"/GIPIParMortgageeController?action=getItemParMortgagee&parId="+parId+"&itemNo="+itemNo, {
		title: "Mortgagee Information",
		width: 600
	});*/
}