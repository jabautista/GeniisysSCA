function getGicls070LpsDetailsList(evalId){
	try{
		new Ajax.Updater("lpsDtlDiv", "GICLRepairHdrController?action=getGicls070LpsDetailsList", {
			method:			"GET",
			parameters:	{
				evalId: evalId
			},
			evalScripts:	true,
			asynchronous:	false,
			onCreate: function(){
				showLoading('lpsDtlDiv', 'Getting list, please wait...');
			}
		});
	}catch(e){
		showErrorMessage("getGicls070LpsDetailsList",e);
	}
}