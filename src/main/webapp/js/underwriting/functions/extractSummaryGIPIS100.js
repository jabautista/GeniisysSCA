/**
 * Extract Summary for GIPIS100
 * 
 */
function extractSummaryGIPIS100(){
	try {
		new Ajax.Request(contextPath+"/GIPIPolbasicController",{
			method: "POST",
			parameters: {
				action		: "gipis100ExtractSummary",
				lineCd		: $F("txtLineCd"),
				sublineCd	: $F("txtSublineCd"),
				issCd		: $F("txtIssCd"),
				issueYy		: $F("txtIssueYy"),
				polSeqNo	: $F("txtPolSeqNo"),
				renewNo		: $F("txtRenewNo"),
				refPolNo	: $F("txtRefPolNo")
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: showNotice("Extracting Summarize Data, please wait..."),
			onComplete: function (response) {
				hideNotice();
				if(checkErrorOnResponse(response)){
					var json = JSON.parse(response.responseText);
					objGIPIS100.extractId = nvl(json.extractId, null);
					showPolicySummaryPage();
					$("polMainInfoDiv").show();
					$("viewPolInfoMainDiv").hide();	
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	} catch (e){
		showErrorMessage("extractSummaryGIPIS100", e);
	}
}