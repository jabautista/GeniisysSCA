function getInspItemInformation(selectedInspNo){
	new Ajax.Updater("inspItemInfoContainer", contextPath+"/GIPIInspectionReportController",{
		method: "POST",
		evalScripts: true,
		asynchronous: false,
		parameters: {
			action: "getInspItemInformation",
			inspNo: nvl(selectedInspNo, 0)
		},
		onCreate: function (){
			
		},
		onSuccess: function (response){
			/*if (checkErrorOnResponse(response)){
				clearInspItemInformation();
			}*/
		}
	});
}