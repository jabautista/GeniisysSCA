<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyReinstatementMainDiv" name="policyReinstatementMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Policy Reinstatement</label>
	   		<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="policyReinstatementBody" name=policyReinstatementBody style="height: 350px;">
		<div class="sectionDiv" style="margin: 100px 0 0 185px; height: 35%; width: 60%;">
			<div style="float: left; width: 420px;">
				<table align="center" style="margin-top: 15px; margin-left: 10px; width: 105%;">
					<tr>
						<td class="rightAligned" width="19%">Policy No.</td>
						<td width="71%">
							<input id="lineCd" class="required" type="text" title="Line Code" style="width: 30px;" maxlength="2"/>
							<input id="sublineCd" class="required" type="text" title="Subline Code" style="width: 60px;" maxlength="7"/>
							<input id="issCd" class="required" type="text" title="Issue Code" style="width: 30px;" maxlength="2"/>
							<input id="issueYy" class="required integerNoNegativeUnformattedNoComma" type="text" title="Issue Year" style="width: 30px;" maxlength="2"/>
							<input id="polSeqNo" class="required integerNoNegativeUnformattedNoComma" type="text" title="Policy Sequence Number" style="width: 60px;" maxlength="7"/>
							<input id="renewNo" class="required integerNoNegativeUnformattedNoComma" type="text" title="Renew Number" style="width: 25px;" maxlength="2"/>
						</td>
						<td>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyLOV" name="searchPolicyLOV" alt="Go" style="float: left;"/>
						</td>
					</tr>
				</table>
			</div>			
			<div style="float: right; width: 110px;">
				<table align="center" style="margin-top: 20px; margin-left: 0px;">
					<tr>
						<td>
							<img src="${pageContext.request.contextPath}/images/misc/history.PNG" id="btnHistory" name="btnHistory" title="View History" onmouseover="this.style.cursor='pointer';"/></td>
						</td>
					</tr>
				</table>
			</div>
			<div style="clear: right; width: 400px; margin-left: 95px; margin-top: 0px;">
				<input type="button" class="button" id="btnReinstate" name="btnReinstate" value="Reinstate" style="width: 150px;" />
				<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 150px;" />
			</div>
			<div>
				<input id="policyId"     type="hidden"/>
				<input id="polSeqNoUnf"  type="hidden"/>
				<input id="renewNoUnf"   type="hidden"/>
				<input id="packPolicyId" type="hidden"/>
				<input id="isCancelled"  type="hidden"/>
				<input id="packPolicyNo" type="hidden"/>
				<input id="vIssCdParam"  type="hidden"/>
				<input id="vHo" 		 type="hidden"/>
				<input id="vRestrict"    type="hidden"/>
				<input id="vSubline"     type="hidden"/>
				<input id="vRenew"       type="hidden"/>
				<input id="polFlag"      type="hidden"/>
				<input id="oldPolFlag"   type="hidden"/>
				<input type="hidden" id="hidAllowSpoil" name="hidAllowSpoil" value="${allowSpoilageRecWrenewal}"/>	<!-- kenneth SR 4753/CLIENT SR 17487 07062015 -->
				<input type="hidden" id="hidAllowCancel" name="hidAllowCancel" value="${allowReinstatementWcancelRenewPol}"/>	<!-- benjo 09.03.2015 UW-SPECS-2015-080 -->
			</div>
		</div>
	</div>
</div>

<script type="text/Javascript">
	initializeAll();
	setModuleId("GIUTS028");
	setDocumentTitle("Policy Reinstatement");
	$("lineCd").focus();
	var historySw = "N";
	var vCancelPolicy;
	var vAcctEntDate;
	var vSpldFlag;
	var vMaxEndt;
	var vSw;
	var vAlert;
	
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
	
	$("btnReinstate").observe("click", function(){
		//validateGIUTS028EndtRecord();//kenneth SR 4753/CLIENT SR 17487 07062015
		/* if(checkExpiryTable($F("policyId"))){
			if($F("hidAllowSpoil") == "Y"){
				showConfirmBox("Confirmation", "The policy has been extracted/processed for renewal. Spoiling of record will cause the deletion of records in renewal tables.", "Yes", "No", validateGIUTS028EndtRecord , "");
			}else{
				showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
			}
		}else{
			validateGIUTS028EndtRecord();
		} */ //benjo 09.03.2015 comment out
		
		/* benjo 09.03.2015 UW-SPECS-2015-080*/
		new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
			parameters: {
				action	 : "checkOrigRenewStatus",
				policyId : $F("policyId")
			},
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.vInvalidOrig == 'Y' && nvl('${allowReinstateWCancelledOrig}','N') == 'N'){ //nvl('${allowReinstateWCancelledOrig}','N') == 'N' - Added by Jerome Bautista SR 21390 01.28.2016
						showMessageBox("The original policy of this renewal has been canceled/spoiled. Unable to proceed with the reinstatement.", "I");
					}else if(res.vValidRenew == 'Y' || res.vCancelRenew == 'Y'){
						if(checkExpiryTable($F("policyId"))){
							if(res.vCancelRenew == 'Y'){
								if($F("hidAllowCancel") == "N"){
									showMessageBox("Reinstatement of a policy with cancelled renewal record is not allowed since it will cause deletion of records in renewal tables.", "I");
								}else if($F("hidAllowSpoil") == "N"){
									showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
								}else{
									validateGIUTS028Override();
								}
							}else{
								if($F("hidAllowSpoil") == "Y"){
									showConfirmBox("Confirmation", "The policy has been extracted/processed for renewal. Spoiling of record will cause the deletion of records in renewal tables.", "Yes", "No", validateGIUTS028EndtRecord, "");
								}else{
									showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
								}
							}
						}else{
							validateGIUTS028EndtRecord();
						}
					}else {
						validateGIUTS028EndtRecord();
					}
				}
			}
		});
	});
	
	function validateGIUTS028EndtRecord(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=validateGIUTS028EndtRecord",{
			parameters: {
				lineCd:			$F("lineCd"),	
				sublineCd:		$F("sublineCd"),
				issCd:			$F("issCd"),
				issueYy:		$F("issueYy"),
				polSeqNo:		$F("polSeqNoUnf"),
				renewNo: 		$F("renewNoUnf"),
				policyId:       $F("policyId")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.vCancelPolicy == "" || res.vCancelPolicy == null){
						showMessageBox("No cancellation endorsement record found to reinstate this policy.", "I");
						return false;
					} else {
						vCancelPolicy = res.vCancelPolicy;
						vAcctEntDate = res.vAcctEntDate;
						vSpldFlag = res.vSpldFlag;
						vMaxEndt = res.vMaxEndt;
						vSw = res.vSw;
						validateGIUTS028IssCd();
					}
				}
			}
		});
	}
	
	function validateGIUTS028IssCd(){
		if($F("vIssCdParam") == null || $F("vIssCdParam") == ""){
			showMessageBox("Parameter BRANCH_CD does not exist from GIAC_PARAMETERS.", "I");
			return false;
		}
		
		if($F("issCd") !=  $F("vIssCdParam") && $F("vIssCdParam") == $F("vHo")){
			if(vSw == 'X'){
				showMessageBox($F("issCd") + " issuing source does not exists from the maintenance.", "I");
				return false;
			}
			
			if(vSw == 'N'){
				showMessageBox("Reinstatement is not allowed for " + $F("issCd") + " policies.", "I");
				return false;
			}
		}
		
		if($F("issCd") != $F("vIssCdParam") && $F("vIssCdParam") != $F("vHo")){
			showMessageBox("Reinstatement is not allowed for " + $F("issCd") + " policies.", "I");
			return false;
		}
		
		validateGIUTS028CheckPaid();
	}
	
	function validateGIUTS028CheckPaid(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=validateGIUTS028CheckPaid", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				vCancelPolicy : vCancelPolicy,
				issCd : $F("issCd"),
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					if(result.vMsgAlert3 == 'TRUE' || result.vMsgAlert3 == 'FALSE'){
						showMessageBox(result.vMsgAlert1, result.vMsgAlert2);
						return result.vMsgAlert3;
					}
					validateGIUTS028CheckRIPayt();
				}
			}
		});
	}
	
	function validateGIUTS028CheckRIPayt(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=validateGIUTS028CheckRIPayt", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				vCancelPolicy : vCancelPolicy,
				lineCd : $F("lineCd"),
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					if(result.vMsgAlert3 == 'TRUE' || result.vMsgAlert3 == 'FALSE'){
						showMessageBox(result.vMsgAlert1, result.vMsgAlert2);
						return result.vMsgAlert3;
					}
					//validateGIUTS028RenewPol(); //benjo 09.03.2015 comment out
					validateGIUTS028CheckAcctEntDate(); //benjo 09.03.2015 UW-SPECS-2015-080
				}
			}
		});
	}
	
	function validateGIUTS028RenewPol(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=validateGIUTS028RenewPol", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				lineCd : $F("lineCd"),
				sublineCd : $F("sublineCd"),
				issCd : $F("issCd"),
				issueYy : $F("issueYy"),
				polSeqNo : $F("polSeqNo"),
				renewNo : $F("renewNo"),
				vRenew : $F("vRenew")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					/* var result = response.responseText.toQueryParams();
					if (result.vAlert == 'N'){
						showMessageBox("Reinstatement of policy with existing renewal not allowed.", "I");
						return false;
					}
					vAlert = result.vAlert;
					validateGIUTS028CheckAcctEntDate(); */ //benjo 09.03.2015 comment out
					processGIUTS028Reinstate(); //benjo 09.03.2015 UW-SPECS-2015-080
				}
			}
		});
	}
	
	function validateGIUTS028CheckAcctEntDate(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=validateGIUTS028CheckAcctEntDate", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				vAcctEntDate : vAcctEntDate,
				vRestrict : $F("vRestrict")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					if(result.vMsgAlert3 == "TRUE" || result.vMsgAlert3 == "FALSE"){
						showWaitingMessageBox(result.vMsgAlert1, result.vMsgAlert2, 
								function(){
									if(result.vMsgAlert3 == "TRUE"){
										if ($F("sublineCd") == $F("vSubline")){
											checkMrn();	
										}
										
										if(vSpldFlag == '3'){
											showMessageBox("This policy / endorsement has already been reinstated.", "I");
											return false;
										} else {
											checkEndtOnProcess();
										}
									}
								}
						);
					} else {
						if ($F("sublineCd") == $F("vSubline")){
							checkMrn();	
						}
						
						if(vSpldFlag == '3'){
							showMessageBox("This policy / endorsement has already been reinstated.", "I");
							return false;
						} else {
							checkEndtOnProcess();
						}
					}
				}
			}
		});
	}
	
	var stopMrn;
	function checkMrn(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=checkMrn",{
			parameters: {
				lineCd:         $F("lineCd"),
				sublineCd:		$F("sublineCd"),
				issCd:			$F("issCd"),
				issueYy:		$F("issueYy"),
				polSeqNo:		$F("polSeqNoUnf"),
				renewNo: 		$F("renewNoUnf")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.vExist == 'Y'){
						showMessageBox("MOP Policy / Endorsement has been used by another declaration policy (" + res.vSubline + ").", "I");
					}
				}
			}
		});
	}
	
	function checkEndtOnProcess(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=checkEndtOnProcess",{
			parameters: {
				lineCd:         $F("lineCd"),
				sublineCd:		$F("sublineCd"),
				issCd:			$F("issCd"),
				issueYy:		$F("issueYy"),
				polSeqNo:		$F("polSeqNoUnf"),
				renewNo: 		$F("renewNoUnf"),
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.vExist == 'Y'){
						showMessageBox("Policy cannot be reinstated, creation of endorsement connected to this record is on going.", "I");
						return false;
					}
					//validateGIUTS028Override(); //benjo 09.03.2015 comment out
					validateGIUTS028RenewPol(); //benjo 09.03.2015 UW-SPECS-2015-080
				}
			}
		});
	}
	
	function validateGIUTS028Override(){
		//if(vAlert == 'Y'){ //benjo 09.03.2015 comment out
			if (giacValidateUserFn("RP") == "FALSE") {
				showConfirmBox("Confirmation", "Current user is not allowed to reinstate a policy with cancelled renewal record."+ 
						" Would you like to override?","Yes","No", 
				   function(){
					override("RP", i);
				}, function(){
					return false;
				});
			} else {
				//processGIUTS028Reinstate(); //benjo 09.03.2015 comment out
				validateGIUTS028EndtRecord(); //benjo 09.03.2015 UW-SPECS-2015-080
			}
		//}
	}
	
	function override(funcCd, y){
		showGenericOverride(
				"GIUTS028",
				funcCd,
				function(ovr, userId, result){
					if(result == "FALSE"){
						showWaitingMessageBox("User " + userId + " is not allowed to process override.", imgMessage.ERROR, 
								function(){
									override("RP", i);
								}
						); 
					}else {
						if(result == "TRUE"){
							//processGIUTS028Reinstate(); //benjo 09.03.2015 comment out
							validateGIUTS028EndtRecord(); //benjo 09.03.2015 UW-SPECS-2015-080
						}
						ovr.close();
						delete ovr;
					}
				},
				""
		);
	}
	
	function giacValidateUserFn(funcCode){
		try{
			var isOk;
			new Ajax.Request(contextPath+"/SpoilageReinstatementController", {
				method: "POST",
				parameters: {action : "validateUserFunc",
					funcCode: funcCode,
					moduleName: "GIUTS028"},
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						isOk = response.responseText;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
			return isOk;
		}catch(e){
			showErrorMessage("giacValidateUserFn", e); //replaced by jdiago 08.14.2014 from getOutFaculTotAmt to giacValidateUserFn : inform users the correct function called.
		}
	}
	
	function processGIUTS028Reinstate(){
		if (stopMrn != "Y"){
			try {
				new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
					method: "POST",
					parameters : {action : "processGIUTS028Reinstate",
						vCancelPolicy:  vCancelPolicy,
						oldPolFlag:     $F("oldPolFlag"),
						lineCd:         $F("lineCd"),
						sublineCd:		$F("sublineCd"),
						issCd:			$F("issCd"),
						issueYy:		$F("issueYy"),
						polSeqNo:		$F("polSeqNoUnf"),
						renewNo: 		$F("renewNoUnf"),
						policyId:       $F("policyId"),
						vMaxEndt:       vMaxEndt
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice("Reinstating, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							showMessageBox("Policy has been reinstated.", imgMessage.SUCCESS);
							disableButton("btnReinstate");
						}
					}
				});
			} catch (e) {
				showErrorMessage("processGIUTS028Reinstate",e);
			}		
		}
	}
	
	$("btnHistory").observe("click", function(){
		if(historySw == "Y"){
			showReinstateHistory();
		}
	});
	
	function showReinstateHistory() {
		try {
		overlayReinstatementHistory = 
			Overlay.show(contextPath+"/GIPIPolbasicController", {
				urlContent: true,
				urlParameters: {action : "showReinstateHistory",																
								ajax : "1",
								policyId : $F("policyId")
				},
			    title: "Policy Reinstatement History",
			    height: 300,
			    width: 470,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("Overlay Error: " , e);
		}
	}
	
	$("searchPolicyLOV").observe("click", function(){
		getGIUTS028PolicyLOV();
	});
	
	function whenNewRecordInstanceGIUTS028(){
		if($F("polFlag") == "4"){
			enableButton("btnReinstate");
		} else {
			disableButton("btnReinstate");
		}
		
		if($F("packPolicyId") != ""){
			if($F("isCancelled") == 'Y'){
				disableButton("btnReinstate");
				showMessageBox("The package " + $F("packPolicyNo") + " for this subpolicy is already cancelled. Use the package Reinstatement utility to reinstate.", "I");
			} else {
				enableButton("btnReinstate");
			}
		}
	}
	
	function getGIUTS028PolicyLOV(){
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIUTS028PolicyLOV",
					lineCd : $F("lineCd"),
					sublineCd : $F("sublineCd"),
					issCd : $F("issCd"),
					issueYy : $F("issueYy"),
					polSeqNo : $F("polSeqNo"),
					renewNo : $F("renewNo")
				},
				title : "Policy Listing",
				width : 500,
				height : 400,
				autoSelectOneRecord: false,
				columnModel : [ {
					id : "policyNo",
					title : "Policy No.",
					width : '165px',
				}, 
				{
					id : "assdName",
					title : "Assured Name",
					width : '320px'
				}
				],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						$("lineCd").value = row.lineCd;
						$("sublineCd").value = row.sublineCd;
						$("issCd").value = row.issCd;
						$("issueYy").value = row.issueYy;
						$("polSeqNoUnf").value = row.polSeqNo;
						$("polSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
						$("renewNoUnf").value = row.renewNo;
						$("renewNo").value = formatNumberDigits(row.renewNo, 2);
						$("policyId").value = row.policyId;
						$("packPolicyId").value = row.packPolicyId;
						$("isCancelled").value = row.isCancelled;
						$("packPolicyNo").value = row.packPolicyNo;
						$("polFlag").value = row.polFlag;
						$("oldPolFlag").value = row.oldPolFlag;
						historySw = "Y";
						whenNewRecordInstanceGIUTS028();
					}
				}
			});
		} catch (e) {
			showErrorMessage("getGIUTS028PolicyLOV", e);
		}
	}
	
	function whenNewFormInstanceGIUTS028(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=whenNewFormInstanceGIUTS028",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.allowSpoilage == "N"){
						showWaitingMessageBox("Batch Accounting Process is currently in progress.  You are not yet allowed to reinstate cancelled policies.", "I", function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
						});
					} else {
						$("vIssCdParam").value = res.vIssCdParam;
						$("vHo").value = res.vHo;
						$("vRestrict").value = res.vRestrict;
						$("vSubline").value = res.vSubline;
						$("vRenew").value = res.vRenew;
					}
				}
			}
		});
	}
	
	whenNewFormInstanceGIUTS028();
	
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
	
	disableButton("btnReinstate");

	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	observeReloadForm("reloadForm", showGIUTS028);
</script>
