<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="packageReinstatementMainDiv" name="packageReinstatementMainDiv">
	<div id="packageReinstatementMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Package Policy Reinstatement</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="packageReinstatementMainSectionDiv" >
		<div class="sectionDiv" id="packageReinstatementMainBody" style="width: 70%; margin: 80px 138px 40px 138px;">
			<div class="sectionDiv" id="packagePolicyNoDiv" style="width: 76%; height:100px; margin: 8px 8px 8px 8px;">
				<table align="center" style="margin-left: 10px; margin-top: 10px; margin-bottom: 0px;">
					<tr>
						<td class="rightAligned">Package Policy No.</td>
						<td>
							<input id="lineCd" class="required" type="text" title="Line Code" style="width: 30px;" maxlength="2"/>
							<input id="sublineCd" class="required" type="text" title="Subline Code" style="width: 60px;" maxlength="7"/>
							<input id="issCd" class="required" type="text" title="Issue Code" style="width: 30px;" maxlength="2"/>
							<input id="issueYy" class="required" type="text" title="Issue Year" style="width: 30px;" maxlength="2"/>
							<input id="polSeqNo" class="required" type="text" title="Policy Sequence Number" style="width: 60px;" maxlength="7"/>
							<input id="renewNo" class="required" type="text" title="Renew Number" style="width: 25px;" maxlength="2"/>
						</td>
						<td>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyLOV" name="searchPolicyLOV" alt="Go" style="float: left;"/>
						</td>
					</tr>
				</table>
				<div id="ButtonsDiv" name="ButtonsDiv" class="buttonsDiv">
					<input type="button" class="button" id="btnReinstate" name="btnReinstate" value="Reinstate" style="width:90px;" />
				</div>
			</div>
			<div class="sectionDiv" id="packagePolicyNoDiv" style="width: 19%; height:100px; margin: 8px 0px 8px 0px;">
				<table align="center" style="margin-top: 25px; margin-left: 35px; margin-bottom: 10px;">
					<tr>
						<td>
							<img src="${pageContext.request.contextPath}/images/misc/history.PNG" id="btnHistory" name="btnHistory" title="View History" onmouseover="this.style.cursor='pointer';"/></td>
						</td>
					</tr>
				</table>
			</div>
			<div>
				<input type="hidden" id="packPolicyId" />
				<input type="hidden" id="polSeqNoUnf" />
				<input type="hidden" id="renewNoUnf" />
				<input type="hidden" id="hidAllowSpoil" name="hidAllowSpoil" value="${allowSpoilageRecWrenewal}"/>	<!-- kenneth SR 4753/CLIENT SR 17487 07062015 -->
				<input type="hidden" id="hidAllowCancel" name="hidAllowCancel" value="${allowReinstatementWcancelRenewPol}"/>	<!-- benjo 09.03.2015 UW-SPECS-2015-080 -->
				<input type="hidden" id="hidRestrictAcct" name="hidAllowCancel" value="${restrictSpoilWacctEntDate}"/>	<!-- benjo 09.03.2015 UCPBGEN-SR-19862 -->
			</div>
		</div>
	</div>
</div>
<script type="text/Javascript">
	setModuleId("GIUTS028A");
	setDocumentTitle("Package Policy Reinstatement");
	$("lineCd").focus();
	var historySw = "N";
	var vIssCdParam;
	var vHo;
	var vRestrict;
	var vSubline;
	var vRenew;
	
	//kenneth SR 4753/CLIENT SR 17487 07062015
	function checkPackExpiryTable(packPolicyId){	
		var expiryTable = false;
		new Ajax.Request(contextPath+"/GIEXPackExpiryController",{
			parameters: {
				action			: "checkPackPolicyIdGiexs006",
				packPolicyId	: packPolicyId
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
		//reinstatePackageGIUTS028A();//kenneth SR 4753/CLIENT SR 17487 07062015
		/* if(checkPackExpiryTable($F("packPolicyId"))){
			if($F("hidAllowSpoil") == "Y"){
				showConfirmBox("Confirmation", "The policy has been extracted/processed for renewal. Spoiling of record will cause the deletion of records in renewal tables.", "Yes", "No", reinstatePackageGIUTS028A , "");
			}else{
				showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
			}
		}else{
			reinstatePackageGIUTS028A();
		} */ //benjo 09.03.2015 comment out
		
		/* benjo 09.03.2015 UW-SPECS-2015-080 */
		new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
			parameters: {
				action	 : "checkPackOrigRenewStatus",
				packPolicyId : $F("packPolicyId")
			},
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					/* if(res.vInvalidOrig == 'Y'){
						showMessageBox("The original policy of this renewal has been canceled/spoiled. Unable to proceed with the reinstatement.", "I");
					}else */ //marco - UCPB SR 21097 - 12.07.2015 - removed condition
					if(res.vValidRenew == 'Y' || res.vCancelRenew == 'Y'){
						if(checkPackExpiryTable($F("packPolicyId"))){
							if(res.vCancelRenew == 'Y'){
								if($F("hidAllowCancel") == "N"){
									showMessageBox("Reinstatement of a policy with cancelled renewal record is not allowed since it will cause deletion of records in renewal tables.", "I");
								}else if($F("hidAllowSpoil") == "N"){
									showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
								}else{
									validateGIUTS028AOverride();
								}
							}else{
								if($F("hidAllowSpoil") == "Y"){
									showConfirmBox("Confirmation", "The policy has been extracted/processed for renewal. Spoiling of record will cause the deletion of records in renewal tables.", "Yes", "No", reinstatePackageGIUTS028A, "");
								}else{
									showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
								}
							}
						}else{
							reinstatePackageGIUTS028A();
						}
					}else {
						reinstatePackageGIUTS028A();
					}
				}
			}
		});
	});
	
	/* benjo 09.03.2015 UW-SPECS-2015-080 */
	function validateGIUTS028AOverride(){
		if (giacValidateUserFn("RP") == "FALSE") {
			showConfirmBox("Confirmation", "Current user is not allowed to reinstate a policy with cancelled renewal record."+ 
					" Would you like to override?","Yes","No", 
			   function(){
				override("RP", i);
			}, function(){
				return false;
			});
		} else {
			reinstatePackageGIUTS028A();
		}
	}
	
	function reinstatePackageGIUTS028A(){
		try {
			new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
				method: "POST",
				parameters : {action : "reinstatePackageGIUTS028A",
					lineCd:         $F("lineCd"),
					sublineCd:		$F("sublineCd"),
					issCd:			$F("issCd"),
					issueYy:		$F("issueYy"),
					polSeqNo:		$F("polSeqNoUnf"),
					renewNo: 		$F("renewNoUnf"),
					packPolicyId:   $F("packPolicyId"),
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Validating Package, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(response.responseText.include("RAE")){
						if(response.responseText.include("EPNYC")){
							showMessageBox("The entire package is not yet cancelled. Reinstate individual subpolicies using the non-package Reinstatement utility." , "I");
						}
						if(response.responseText.include("NCER")){
							showMessageBox("No cancellation endorsement record found to reinstate this policy." , "I");
						}
						if(response.responseText.include("PBCX")){
							showMessageBox("Parameter BRANCH_CD does not exist in GIAC_PARAMETERS." , "I");
						}
						if(response.responseText.include("ISX")){
							showMessageBox($F("issCd") + " issuing source does not exist in maintenance." , "I");
						}
						if(response.responseText.include("REINA")){
							showMessageBox("Reinstatement is not allowed for " + $F("issCd") + " policies.", "I");
						}
						if(response.responseText.include("REIA")){
							showMessageBox("This policy / endorsement has already been reinstated.", "I");
						}
						if(response.responseText.include("EONG")){
							showMessageBox("Policy cannot be reinstated, creation of endorsement connected to this record is on going.", "I");
						}
						if(response.responseText.include("REEXISTR")){
							showMessageBox("Reinstatement of policy with existing renewal not allowed.", "I");
						}
					/* benjo 09.03.2015 replaced if -> else if */
					}else if (response.responseText.include("MOP")){
						showMessageBox(response.responseText.substring(11), "I");
					}else if (response.responseText.include("Please reverse the payment") || response.responseText.include("Policy has collection(s)")){
						showMessageBox(response.responseText.substring(11), "I");
					}else if (response.responseText.include("collections from FACUL Reinsurers,")){
						showMessageBox(response.responseText.substring(11), "I");
					}else if (response.responseText.include("Policy has been considered in Accounting")){
						showMessageBox(response.responseText.substring(11), "I");
					}else if (response.responseText.include("The sub-policies of this package policy")){ //benjo 09.03.2015 UCPBGEN-SR-19862
						if ($F("hidRestrictAcct") == "Y"){ 
							showMessageBox(response.responseText.substring(11), "I");
						} else {
							showWaitingMessageBox(response.responseText.substring(11), "I", postGIUTS028AReinstate);
						}
					} else {
						/* var res = JSON.parse(response.responseText);
						if (res.vSubpolCheck == 'Y'){
							if (giacValidateUserFn("RP") == "FALSE") {
								showConfirmBox("Confirmation", "Current user is not allowed to reinstate a policy with cancelled renewal record."+ 
										" Would you like to override?","Yes","No", 
								   function(){
									override("RP", i);
								}, function(){
									return false;
								});
							} else {
								postGIUTS028AReinstate();
							}
						} */ //benjo 09.03.2015 comment out
						postGIUTS028AReinstate(); //benjo 09.03.2015 UW-SPECS-2015-080
					}
				}
			});
		} catch (e) {
			showErrorMessage("reinstatePackageGIUTS028A",e);
		}		
	}
	
	function giacValidateUserFn(funcCode){
		try{
			var isOk;
			new Ajax.Request(contextPath+"/SpoilageReinstatementController", {
				method: "POST",
				parameters: {action : "validateUserFunc",
					funcCode: funcCode,
					moduleName: "GIUTS028A"},
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
			showErrorMessage("postGIUTS028AReinstate", e);
		}
	}
	
	function override(funcCd, y){
		showGenericOverride(
				"GIUTS028A",
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
							//postGIUTS028AReinstate(); //benjo 09.03.2015 comment out
							reinstatePackageGIUTS028A(); //benjo 09.03.2015 UW-SPECS-2015-080
						}
						ovr.close();
						delete ovr;
					}
				},
				""
		);
	}
	
	function postGIUTS028AReinstate(){
		try {
			new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
				method: "POST",
				parameters : {action : "postGIUTS028AReinstate",
					lineCd:         $F("lineCd"),
					sublineCd:		$F("sublineCd"),
					issCd:			$F("issCd"),
					issueYy:		$F("issueYy"),
					polSeqNo:		$F("polSeqNoUnf"),
					renewNo: 		$F("renewNoUnf"),
					packPolicyId:   $F("packPolicyId"),
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Reinstating Package, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(response.responseText.include("RAE")){
						if(response.responseText.include("NCERF")){
							showMessageBox("No cancellation endorsement record found to reinstate this policy." , "I");
						}
					} else {
						disableButton("btnReinstate");
						showMessageBox("Package Policy has been reinstated.", imgMessage.SUCCESS);
					}
				}
			});
		} catch (e) {
			showErrorMessage("postGIUTS028AReinstate",e);
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
			Overlay.show(contextPath+"/GIPIPackPolbasicController", {
				urlContent: true,
				urlParameters: {action : "showReinstateHistory",																
								ajax : "1",
								packPolicyId : $F("packPolicyId")
				},
			    title: "Package Policy Reinstatement History",
			    height: 300,
			    width: 470,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("Overlay Error: " , e);
		}
	}
	
	$("searchPolicyLOV").observe("click", function(){
		getGIUTS028APolicyLOV();
	});
	
	function getGIUTS028APolicyLOV(){
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIUTS028APolicyLOV",
					lineCd : $F("lineCd"),
					sublineCd : $F("sublineCd"),
					issCd : $F("issCd"),
					issueYy : $F("issueYy"),
					polSeqNo : $F("polSeqNo"),
					renewNo : $F("renewNo")
				},
				title : "Package Policy Listing",
				width : 500,
				height : 400,
				autoSelectOneRecord: false,
				columnModel : [ {
					id : "packPolicyNo",
					title : "Pack Policy No.",
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
						$("polSeqNo").value = formatNumberDigits(row.polSeqNo, 6);
						$("renewNoUnf").value = row.renewNo;
						$("renewNo").value = formatNumberDigits(row.renewNo, 2);
						$("packPolicyId").value = row.packPolicyId;
						historySw = "Y";
					}
					
					if (row.packPolFlag == '4' || row.vSubcancel == 'Y'){
						enableButton("btnReinstate");
					} else {
						disableButton("btnReinstate");
					}
					
					if (row.vHist == 'Y'){
						historySw = "Y";
					} else {
						historySw = "N";
					}
					
				}
			});
		} catch (e) {
			showErrorMessage("getGIUTS028APolicyLOV", e);
		}
	}
	
	function whenNewFormInstanceGIUTS028A(){
		new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=whenNewFormInstanceGIUTS028A",{
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
						vIssCdParam = res.vIssCdParam;
						vHo = res.vHo;
						vRestrict = res.vRestrict;
						vSubline = res.vSubline;
						vRenew = res.vRenew;
					}
				}
			}
		});
	}
	
	$("lineCd").observe("keyup", function(){
		$("lineCd").value = $("lineCd").value.toUpperCase();
	});
	
	$("sublineCd").observe("keyup", function(){
		$("sublineCd").value = $("sublineCd").value.toUpperCase();
	});
	
	$("issCd").observe("keyup", function(){
		$("issCd").value = $("issCd").value.toUpperCase();
	});
	
	function validateNumberFields(id, decimal, element, format){
		if($F(id) != ""){
			if(isNaN($F(id))){
				$(id).clear();
				customShowMessageBox("Invalid Package " + element + ". Valid value should be from " + format + ".", "I", id);
			}else{
				$(id).value = formatNumberDigits($F(id), decimal);
			}
		}
	}
	$("issueYy").observe("change", function(){validateNumberFields("issueYy", 2, "Issue Year", "00 to 99");});
	$("polSeqNo").observe("change", function(){validateNumberFields("polSeqNo", 6, "Pol Seq No", "0000000 to 9999999");});
	$("renewNo").observe("change", function(){validateNumberFields("renewNo", 2, "Renew Number", "00 to 99");});
	
	disableButton("btnReinstate");
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	observeReloadForm("reloadForm", showGIUTS028A);
	
	initializeAll();
	whenNewFormInstanceGIUTS028A();
</script>
