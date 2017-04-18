<div id="spoilPostedPolicyMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnQuery">Query</a></li>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Spoil Policy/Endorsement</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="groDiv" name="groDiv">
		<div class="sectionDiv" style="height: 105px;">
			<table align="center" style="width: 80%; margin-top: 20px;">
				<tr>
					<td class="rightAligned" width="19%">Policy No.</td>
					<td>
						<input id="lineCd" class="required" type="text" title="Line Code" style="width: 30px;" maxlength="2"/>
						<input id="sublineCd" type="text" title="Subline Code" style="width: 60px;" maxlength="7"/>
						<input id="issCd" type="text" title="Issue Code" style="width: 30px;" maxlength="2"/>
						<input id="issueYy" type="text" title="Issue Year" style="width: 30px;" maxlength="2"/>
						<input id="polSeqNo" type="text" title="Policy Sequence Number" style="width: 60px;" maxlength="7"/>
						<input id="renewNo" type="text" title="Renew Number" style="width: 25px;" maxlength="2"/>
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyLOV" name="searchPolicyLOV" alt="Go" style="float: left;"/>
					</td>
					<td class="rightAligned" width="20%">Endt No.</td>
					<td>
						<input id="endtNo" readonly="readonly" type="text" style="width: 200px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td>
						<input id="assdName" readonly="readonly" type="text" title="Assured Name" style="width: 295px;"/>
					</td>
					<td></td>
					<td class="rightAligned">Accounting Date</td>
					<td>
						<input id="acctEntDate" readonly="readonly" type="text" style="width: 200px;"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="height: 280px;">
			<table align="center" style="width: 80%; margin-top: 30px;">
				<tr>
					<td class="rightAligned" width="20%">Effectivity Date</td>
					<td>
						<input id="effDate" readonly="readonly" type="text" style="width: 220px;"/>
					</td>
					<td class="rightAligned">Expiry Date</td>
					<td>
						<input id="expDate" readonly="readonly" type="text" style="width: 220px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Name</td>
					<td>
						<input id="spldUserId" readonly="readonly" type="text" style="width: 220px;"/>
					</td>
					<td class="rightAligned">Spoiled Date</td>
					<td>
						<input id="spldDate" readonly="readonly" type="text" style="width: 220px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Policy Status</td>
					<td>
						<input id="policyStatus" readonly="readonly" type="text" style="width: 220px;"/>
					</td>
					<td class="rightAligned">Approval</td>
					<td>
						<input id="spldApproval" readonly="readonly" type="text" style="width: 220px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Reason for Spoilage</td>
					<td colspan="3">
						<div id="spoilCdDiv" readonly="readonly" class="sectionDiv" style="float: left; width: 49px; height: 19px; margin-top: 2px; border: 1px solid gray;">
							<input id="spoilCd" readonly="readonly" type="text" maxlength="4" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSpoilCdLOV" name="searchSpoilCdLOV" alt="Go" style="float: right;"/>
						</div>
						<input id="spoilDesc" readonly="readonly" type="text" style="width: 500px; margin-left: 5px;"/>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="text-align: center; margin-top: 45px;">
				<input id="btnSpoilPolicy" type="button" class="button" value="Spoil Policy/Endorsement" style="width: 180px;"/>
				<input id="btnUnspoilPolicy" type="button" class="button" value="Unspoil Policy/Endorsement" style="width: 180px;"/>
				<input id="btnPostSpoilage" type="button" class="button" value="Post Spoilage" style="width: 180px;"/>
			</div>
			<div>
				<input id="policyId" type="hidden"/>
				<input id="spldFlag" type="hidden"/>
				<input id="endtSeqNo" type="hidden"/>
				<input id="polFlag" type="hidden"/>
				<input id="endtExpiryDate" type="hidden"/>
				<input id="prorateFlag" type="hidden"/>
				<input id="compSw" type="hidden"/>
				<input id="shortRtPercent" type="hidden"/>
				<input type="hidden" id="hidAllowSpoil" name="hidAllowSpoil" value="${allowSpoilageRecWrenewal}"/>	<!-- kenneth SR 4753/CLIENT SR 17487 07062015 -->
			</div>
		</div>
	</div>
</div>
<script type="text/Javascript">
try{
	initializeAccordion();
	setModuleId("GIUTS003");
	setDocumentTitle("Spoil Policy/Endorsement");
	$("lineCd").focus();
	var requireReason;
	
	function whenNewFormInstanceGiuts003(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=whenNewFormInstanceGiuts003",{
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					requireReason = res.requireReason;
					/* added by MarkS 5.10.2016 SR-5377 */
					if(requireReason == "Y")
					{
						$("spoilCd").setAttribute("class", "required");
						$("spoilDesc").setAttribute("class", "required");
					}
					/* end SR-5377 */
					if(res.allowSpoilage == "N"){
						showWaitingMessageBox("Batch Accounting Process is currently in progress.  You are not yet allowed to spoil policies.", "I", function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
						});
					}else if(res.clmStatCancel == null){
						$("lineCd").setAttribute("readonly", "readonly");
						$("sublineCd").setAttribute("readonly", "readonly");
						$("issCd").setAttribute("readonly", "readonly");
						$("issueYy").setAttribute("readonly", "readonly");
						$("polSeqNo").setAttribute("readonly", "readonly");
						$("renewNo").setAttribute("readonly", "readonly");
						disableSearch("searchPolicyLOV");
						disableSearch("searchSpoilCdLOV");
						showMessageBox("Record not found in GIIS_PARAMETERS  for param_name GICL_CLAIMS_CLM_STAT_CD_CANCELLED", "I");
					}
				}
			}
		});
	}
	
	whenNewFormInstanceGiuts003();
	$("lineCd").observe("keyup", function(){
		$("lineCd").value = $("lineCd").value.toUpperCase();
	});
	$("sublineCd").observe("keyup", function(){
		$("sublineCd").value = $("sublineCd").value.toUpperCase();
	});
	$("issCd").observe("keyup", function(){
		$("issCd").value = $("issCd").value.toUpperCase();
	});
	
	function validateNumberFields(id, decimal, form){
		if($F(id) != ""){
			if(isNaN($F(id))){
				$(id).clear();
				customShowMessageBox("Field must be of form "+ form + ".", "E", id);
			}else{
				$(id).value = formatNumberDigits($F(id), decimal);
			}
		}
	}
	$("issueYy").observe("change", function(){validateNumberFields("issueYy", 2, "09");});
	$("polSeqNo").observe("change", function(){validateNumberFields("polSeqNo", 6, "099999");});
	$("renewNo").observe("change", function(){validateNumberFields("renewNo", 2, "09");});
	
	function spoilPolicyGiuts003(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=spoilPolicyGiuts003",{
			parameters: {
				policyId : $F("policyId"),
				lineCd : $F("lineCd"),
				sublineCd : $F("sublineCd"),
				issCd : $F("issCd"),
				issueYy : $F("issueYy"),
				polSeqNo : $F("polSeqNo"),
				renewNo : $F("renewNo"),
				endtSeqNo : $F("endtSeqNo"),
				effDate : $F("effDate"),
				acctEntDate : $F("acctEntDate"),
				spldFlag : $F("spldFlag"),
				spoilCd : $F("spoilCd"),
				requireReason : requireReason,
				polFlag : $F("polFlag")
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Spoiling Policy/..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.acctEntDate != null){
						showWaitingMessageBox(res.message, "I", function(){onOkSpoilGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag);});
					}
					onOkSpoilGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag);
				}
				/* if(response.responseText.include("RAE")){
					showMessageBox(response.responseText.substring(14), response.responseText.substring(14,15));	
				}else{
					var res = JSON.parse(response.responseText);
					if(res.acctEntDate != null){
						showWaitingMessageBox(res.message, "I", function(){onOkSpoilGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag);});
					}
					onOkSpoilGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag);
				} */
			}
		});
	}
	
	function onOkSpoilGiuts003(cont, policyStatus, spldDate, spldUserId, spldFlag){
		if(cont == "Y"){
			disableButton("btnSpoilPolicy");
			enableButton("btnUnspoilPolicy");
			enableButton("btnPostSpoilage");
			disableSearch("searchSpoilCdLOV"); // Added by Joms Diago 05112013
			disableInputField("spoilCd"); // Added by Joms Diago 05112013
			$("policyStatus").value = policyStatus;
			$("spldDate").value = spldDate;
			$("spldUserId").value = spldUserId;
			$("spldFlag").value = spldFlag;
			showMessageBox("Policy/Endorsement has been tagged for spoilage.", "I");	
		}
	}
	
	function unspoilPolicyGiuts003(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=unspoilPolicyGiuts003",{
			parameters: {
				issCd : $F("issCd"),
				spldFlag : $F("spldFlag"),
				policyId : $F("policyId")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){ // kris 06.27.2014 for SR 16131 
					//showMessageBox(response.responseText.substring(5), response.responseText.substring(4,5));
				//}else{
					var res = JSON.parse(response.responseText);
					$("policyStatus").value = res.policyStatus;
					enableButton("btnSpoilPolicy");
					disableButton("btnUnspoilPolicy");
					disableButton("btnPostSpoilage");
					enableSearch("searchSpoilCdLOV"); // Added by Joms Diago 05112013
					enableInputField("spoilCd"); // Added by Joms Diago 05112013
					$("spldDate").clear();
					$("spldUserId").clear();
					$("spoilCd").clear();
					$("spoilDesc").clear();
					showMessageBox("The policy/endorsement has been unspoiled.", "I");
				}
			}
		});
	}
	
	function postPolicyGiuts003(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=postPolicyGiuts003",{
			parameters: {
				lineCd : $F("lineCd"),
				sublineCd : $F("sublineCd"),
				issCd : $F("issCd"),
				issueYy : $F("issueYy"),
				polSeqNo : $F("polSeqNo"),
				renewNo : $F("renewNo"),
				effDate : $F("effDate"),
				acctEntDate : $F("acctEntDate"),
				spldFlag : $F("spldFlag"),
				policyId : $F("policyId"),
				endtExpiryDate : $F("endtExpiryDate"),
				prorateFlag : $F("prorateFlag"), 
				compSw : $F("compSw"),
				shortRtPercent : $F("shortRtPercent")
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Posting Spoilage..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){ // kris 06.27.2014 for SR 16131
					//showMessageBox(response.responseText.substring(5), response.responseText.substring(4,5));	
				//}else{
					var res = JSON.parse(response.responseText);
					if(res.claimExist == "Y"){
						showConfirmBox("", "The policy has claims, do you want to continue spoilage?", "Yes", "No",
							function(){
								postPolicy2Giuts003("Y");
						},
							function(){
								postPolicy2Giuts003("N");
						},"");
					}
					if(res.message == "SUCCESS"){
						onOkPostGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag, res.spldApproval);
					}
				}
			}
		});
	}
	
	function postPolicy2Giuts003(alert){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=postPolicy2Giuts003",{
			parameters: {
				lineCd : $F("lineCd"),
				sublineCd : $F("sublineCd"),
				issCd : $F("issCd"),
				issueYy : $F("issueYy"),
				polSeqNo : $F("polSeqNo"),
				renewNo : $F("renewNo"),
				effDate : $F("effDate"),
				acctEntDate : $F("acctEntDate"),
				spldFlag : $F("spldFlag"),
				policyId : $F("policyId"),
				endtExpiryDate : $F("endtExpiryDate"),
				prorateFlag : $F("prorateFlag"), 
				compSw : $F("compSw"),
				shortRtPercent : $F("shortRtPercent"),
				alert : alert,
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Posting Spoilage..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){ // kris 06.27.2014 for SR 16131
					//showMessageBox(response.responseText.substring(5), response.responseText.substring(4,5));	
				//}else{
					var res = JSON.parse(response.responseText);
					if(res.alert == "Y"){
						if(res.acctEntDate != null){
							showWaitingMessageBox(res.message, "I", function(){ onOkPostGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag, res.spldApproval);});
						}
						onOkPostGiuts003(res.cont, res.policyStatus, res.spldDate, res.spldUserId, res.spldFlag, res.spldApproval);
					}
				}
			}
		});
	}
	
	function onOkPostGiuts003(cont, policyStatus, spldDate, spldUserId, spldFlag, spldApproval){
		if(cont == "Y"){
			disableButton("btnSpoilPolicy");
			disableButton("btnUnspoilPolicy");
			disableButton("btnPostSpoilage");
			$("policyStatus").value = policyStatus;
			$("spldDate").value = spldDate;
			$("spldUserId").value = spldUserId;
			$("spldFlag").value = spldFlag;
			$("spldApproval").value = spldApproval;
			showMessageBox("Policy/Endorsement has been spoiled.", "I");	
		}
	}
	
	$("searchPolicyLOV").observe("click", getPolicyGiuts003LOV);
	$("searchSpoilCdLOV").observe("click", getSpoilCdGiuts003LOV);
	
	//kenneth SR 4753/CLIENT SR 17487 07062015
	function checkExpiryTable(policyId){	
		var expiryTable = false;
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			parameters: {
				action	   : "checkPolicyIdGiexs006",
				policyId   : policyId
			},
			evalScripts:	true,
			asynchronous:	false,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					var res = response.responseText;
					if(res == "Y"){
						expiryTable = true;
					}
				}
			}
		});
		return expiryTable;
	}
	
	function checkAllowSpoil(polId, onOk){
		if(checkExpiryTable(polId)){
			if($F("hidAllowSpoil") == "Y"){
				showConfirmBox("Confirmation", "The policy has been extracted/processed for renewal. Spoiling of record will cause the deletion of records in renewal tables.", "Yes", "No", onOk , "");
			}else{
				showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
			}
		}else{
			onOk();
		}
	}
	
	//modified by kenneth SR 4753/CLIENT SR 17487 07062015
	$("btnSpoilPolicy").observe("click", function(){
		if(requireReason == "Y"){
			if($F("spoilCd") == ""){
				customShowMessageBox("Please specify reason for spoilage.", "E", "spoilCd");
			}else{
				checkAllowSpoil($F("policyId"), spoilPolicyGiuts003);
			}
		}else{
			checkAllowSpoil($F("policyId"), spoilPolicyGiuts003);
		} 
	});
	
	$("btnUnspoilPolicy").observe("click", unspoilPolicyGiuts003);
	//$("btnPostSpoilage").observe("click", postPolicyGiuts003);//changed by kenneth SR 4753/CLIENT SR 17487 07062015
	$("btnPostSpoilage").observe("click", function(){
		checkAllowSpoil($F("policyId"), postPolicyGiuts003);
	});
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	observeReloadForm("reloadForm", showSpoilPostedPolicy);
	observeReloadForm("btnQuery", showSpoilPostedPolicy);
	disableButton("btnSpoilPolicy");
	disableButton("btnUnspoilPolicy");
	disableButton("btnPostSpoilage");
	
	var prevSpoilCd = "";
	var prevSpoilDesc = "";
	$("spoilCd").observe("keyup", function(){
		$("spoilCd").value = $("spoilCd").value.toUpperCase();	
	});
	$("spoilCd").observe("focus", function(){
		prevSpoilCd = $F("spoilCd");
		prevSpoilDesc = $F("spoilDesc");
	});
	$("spoilCd").observe("change", function(){
		if($F("spoilCd") == ""){
			$("spoilDesc").clear();
		}else{
			new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=validateSpoilCdGiuts003",{
				parameters: {
					spoilCd : $F("spoilCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("spoilCd").value = prevSpoilCd;
						$("spoilDesc").value = prevSpoilDesc;
						getSpoilCdGiuts003LOV();
					}else{
						$("spoilDesc").value = response.responseText;
					}
				}
			});	
		}
	});
} catch(e){
	showMessageBox("Error in spoilPostedPolicy.jsp page: " + e, "E");
}
</script>