function getEvalDepList(evalId){
	try{
		new Ajax.Updater("depDtlDiv", "GICLEvalDepDtlController?action=getEvalDepList", {
			method:			"GET",
			parameters:	{
				evalId: evalId
			},
			evalScripts:	true,
			asynchronous:	false,
			onCreate: function(){
				showLoading('depDtlDiv', 'Getting list, please wait...');
			}
		});
	}catch(e){
		showErrorMessage("getEvalDepList",e);
	}
}