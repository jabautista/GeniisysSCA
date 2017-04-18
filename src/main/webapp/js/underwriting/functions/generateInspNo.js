function generateInspNo(){
	var inspNo;
	new Ajax.Request(contextPath+"/GIPIInspectionReportController?action=generateInspNo",{
		method: "GET",
		evalScripts: true,
		asynchronous: false,
		onSuccess: function (response){
			if (checkErrorOnResponse(response)){
				inspNo = response.responseText;
			}
		}
	});
	return inspNo;
}