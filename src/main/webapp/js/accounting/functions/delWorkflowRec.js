//referenced by GIACS149 - Overriding Commission Voucher
function delWorkflowRec(){
	try{
		var strParams = prepareJsonAsParameter(objGIACS149.checkedVouchers);
		
		new Ajax.Request(contextPath+"/GIACGenearalDisbReportController", {
			method: "POST",
			parameters: {
				action:		"delWorkflowRecGIACS149",
				eventDesc:	"COMMISSION VOUCHER - OVERRIDE",
				//colValue:	objGIACS149.selectedRow == null ? null: objGIACS149.selectedRow.issCd+"-"+objGIACS149.selectedRow.premSeqNo
				checkedVouchers: strParams
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if (objGIACS149.reprint == "N"){
						restoreGpcv(1);
					}else{
						restoreGpcv(0);
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("delWorkflowRec", e);
	}
}