function showGIACS149Page(intmNo, gfunFundCd, gibrBranchCd, fromDate, toDate, workflowColVal){
	try{
		new Ajax.Request(contextPath+"/GIACGenearalDisbReportController", {
			parameters: {
				action:				"showGIACS149Page",
				intmNo:				intmNo,
				gfunFundCd:			gfunFundCd,
				gibrBranchCd:		gibrBranchCd,
				fromDate:			fromDate,
				toDate:				toDate,
				workflowColValue:	workflowColVal
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: showNotice("Loading Overriding Commission Voucher page, please wait..."),
			onComplete: function(response){
				hideNotice();
				$("mainContents").update(response.responseText);
				//$("mainNav").hide();
				hideAccountingMainMenus();
				$("acExit").hide();
				$("txtTaggedTotalPrem").value = formatCurrency('${taggedPrem}');
				$("txtTaggedTotalComm").value = formatCurrency('${taggedComm}');
				$("txtGrandTotalPrem").value = formatCurrency('${grandPrem}');
				$("txtGrandTotalComm").value = formatCurrency('${grandComm}');
			}
		});
	}catch(e){
		showErrorMessage("showGIACS149Page", e);
	}
}