/*
 * Description: To be used only when refreshing Mc eval after save
 * **/
function refreshMcEvaluationReport(){
	try{
		var clmSublineCd =$F("txtClmSublineCd");
		var clmIssCd = $F("txtClmIssCd");
		var clmYy = $F("txtClmYy");
		var clmSeqNo = $F("txtClmSeqNo");
		
		var vDiv = mcEvalFromItemInfo == "Y" ? "basicInformationMainDiv" :  "mainContents"; 
		
		new Ajax.Updater(vDiv, contextPath + "/GICLMcEvaluationController?action=showMcEvaluationReport", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				$("txtClmSublineCd").value = clmSublineCd;
				$("txtClmIssCd").value = clmIssCd;
				$("txtClmYy").value = clmYy;
				$("txtClmSeqNo").value = lpad(clmSeqNo, 7, "0");
				//if(mcEvalFromItemInfo == "Y"){
				getEvalPolInfo(clmSublineCd,clmIssCd,clmYy,clmSeqNo);
				//}
				
			}
		});
	}catch(e){
		showErrorMessage("refreshMcEvaluationReport",e);
	}
}