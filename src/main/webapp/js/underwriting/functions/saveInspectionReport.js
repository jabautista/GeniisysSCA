function saveInspectionReport(){
	try{
		var params = unescapeInspectionReport(JSON.stringify(inspectionReportObj)); //added by steven 11/27/2012
		new Ajax.Request(contextPath+"/GIPIInspectionReportController",{
			method: "POST",
			parameters: {
				action: "saveInspectionReport",
				parameters: params
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function (){
				showNotice("Saving inspection report. Please wait...");
			},
			onComplete: function (response){ //fixed
				hideNotice("");
			if (checkErrorOnResponse(response)){
					hideNotice("");
					cleanUpInspectionReportObj();
					changeTag = 0;
					inspData1Obj.inspCd = $F("inspectorCd");
					inspData1Obj.assdName = escapeHTML2($F("assuredName")); // added by irwin 9.4.2012
					inspData1Obj.inspName = escapeHTML2($F("inspector"));
					inspData1Obj.intmNo = $F("txtIntmNo");
					inspData1Obj.assdNo = $F("assuredNo");
					inspData1Obj.intmName = escapeHTML2($F("txtIntmName"));
					inspData1Obj.inspNo = $F("inspNo");
					inspData1Obj.dateInsp = $F("dateInspected");
					inspData1Obj.status = $("approvedTag").checked ? "Y" : "N";
					inspData1Obj.remarks = (escapeHTML2($F("remarks"))).replace(/\n/g,"&#8629;"); //removed - irwin  //uncommented by steven 09.20.2013
					inspData1Obj.approvedBy = $("approvedTag").checked ? ($F("approvedBy") == "" ? $F("currentUser") : $F("approvedBy")) : "";
					inspData1Obj.dateApproved = $("approvedTag").checked ? ($F("dateApproved") == "" ? '${currentDate' : $F("dateApproved")) : "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						showInspectionReport(inspData1Obj);
					})
					//showMessageBox(objCommonMessage.SUCCESS, "S");
				}
			}
		});
	} catch (e){
		showErrorMessage("saveInspectionReport", e);
	}
}