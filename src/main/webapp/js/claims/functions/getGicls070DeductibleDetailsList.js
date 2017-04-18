function getGicls070DeductibleDetailsList(){
	try{
		new Ajax.Updater("deductibleDetailsTgDiv", "GICLEvalDeductiblesController?action=getGiclEvalDeductibles", {
			method:			"GET",
			parameters:	{
				evalId: selectedMcEvalObj.evalId
			},
			evalScripts:	true,
			asynchronous:	false,
			onCreate: function(){
				showLoading('deductibleDetailsTgDiv', 'Getting list, please wait...');
			}
		});
	}catch(e){
		showErrorMessage("getGicls070DeductibleDetailsList",e);
	}
}