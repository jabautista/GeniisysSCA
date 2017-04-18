/**
 *Description - searching related policies 
 *			  	based on the given parameters(textfields)
 *				and differs by endorsement number
 *created by  - mosesBC 
 */
function searchRelatedPolicies(){
	new Ajax.Updater("relatedPolDiv","GIPIPolbasicController?action=getRelatedPolicies",{
		method:"get",
		evalScripts: true,
		parameters: {
			lineCd		:$F("txtLineCd"),
			sublineCd	:$F("txtSublineCd"),
			issCd		:$F("txtIssCd"),
			issueYy		:$F("txtIssueYy"),
			polSeqNo	:$F("txtPolSeqNo"),
			renewNo		:$F("txtRenewNo"),
			refPolNo	:$F("txtRefPolNo")
		},
		onCreate: showNotice("Loading, please wait..."),
		onComplete: function(response){
			hideNotice();
		}
	});
}