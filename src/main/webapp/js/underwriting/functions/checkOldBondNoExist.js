function checkOldBondNoExist(forSaving){
	var forSaving = forSaving || false;
	var ok = false;
	new Ajax.Request(contextPath+"/GIPIParBondInformationController", {
		method: "GET",
		parameters: {action: 			"checkOldBondNoExist",
					 parId:				$F("globalParId"),
					 lineCd:			$F("globalLineCd"),
					 assuredNo:			$F("assuredNo"),
					 wpolnrepSublineCd:	$F("wpolnrepSublineCd"),
					 wpolnrepIssCd: 	$F("wpolnrepIssCd"),
					 wpolnrepIssueYy: 	$F("wpolnrepIssueYy"),
					 wpolnrepPolSeqNo:	$F("wpolnrepPolSeqNo"),
					 wpolnrepRenewNo:	$F("wpolnrepRenewNo"),
					 polFlag:			$F("policyStatus")
					 },
		asynchronous : false,
		evalScripts : true,			 
		onCreate: function(){
			showNotice("Checking Old Bond No.,please wait...");
			},							 
		onComplete: function (response) {
			var text = response.responseText;
			var arr = text.split(',-de-_limit_-er-,');
			if (!isNaN(parseFloat(arr[0]) *1)) {
				$("oldPolicyId").value = arr[0];
				if (($("wpolnrepOldPolicyId").value != "") && ($("oldPolicyId").value != $("wpolnrepOldPolicyId").value)){
					$("deleteWPolnrep").value = "Y";
				} else {
					$("deleteWPolnrep").value = "N";
				}
				$("address1").value = arr[1];
				$("address2").value = arr[2];
				$("address3").value = arr[3];
				$("referencePolicyNo").value = arr[4];
				$("mortG").selectedIndex = 0;
				$("mortG").value = arr[5];	
				ok = true;
			} else {
				if (arr[0] == "That policy has an existing claim." ||
					arr[0] == "At least one PAR is already endorsing or renewing that policy."){
					if (!forSaving) {showMessageBox(arr[0], imgMessage.INFO);}
					if ($("oldPolicyId").value == ""){
						if (!isNaN(parseFloat(arr[1]) *1)) {
							$("oldPolicyId").value = arr[1];
						}
					}
					ok = true;
				}else{
					showMessageBox(arr[0], imgMessage.ERROR);
					$("oldPolicyId").value = "";
					$("wpolnrepIssCd").value = "";
					$("wpolnrepIssueYy").value = "";
					$("wpolnrepPolSeqNo").value = "";
					$("wpolnrepRenewNo").value = "";
					$("samePolnoSw").checked = false;
					return false;
				}	
			}
			Effect.Appear("notice", {
				duration: .001,
				afterFinish: function () {
					hideNotice("Done!");	
				}
			});
		}
	});		
	return ok;
}