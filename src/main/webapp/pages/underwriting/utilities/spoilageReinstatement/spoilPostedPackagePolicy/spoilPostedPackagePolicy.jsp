<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="spoilPackagePolicyMainDiv">
	<div id="uwReportsMenuDiv" name="uwReportsMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnQuery" name="btnQuery">Query</a></li>
					<li><a id="btnExit" name="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Spoil Package Policy/Endorsement</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="packPolicyDiv" class="sectionDiv" style="width: 100%; height: 460px; border: none;">
		<div id="packPolicyInfoDiv" name="packPolicyInfoDiv" class="sectionDiv" style="width: 100%; height: 150px;">
			<table id="packPolicyInfoTbl" align="center" style="margin-top: 40px">
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Policy No.</td>
					<td class="leftAligned" style="width: 350px;">
						<input type="text" id="txtPolLineCd" title="Line Code" class="required" style="float: left; width: 30px; margin-right: 3px;" maxlength="2"/>
						<input type="text" id="txtPolSublineCd" title="Subline Code" style="float: left; width: 70px; margin-right: 3px;" maxlength="7"/>
						<input type="text" id="txtPolIssCd" title="Issue Code" style="float: left; width: 30px; margin-right: 3px;" maxlength="2"/>
						<input type="text" id="txtPolIssueYy" title="Issue Year" class="integerNoNegativeUnformattedNoComma" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2"/>
						<input type="text" id="txtPolPolSeqNo" title="Policy Sequence Number" class="integerNoNegativeUnformattedNoComma" style="float: left; width: 70px; margin-right: 3px; text-align: right;" maxlength="7"/>
						<input type="text" id="txtPolRenewNo" title="Renew Number" class="integerNoNegativeUnformattedNoComma" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2"/>
						<img id="searchPolicyNoLOV" alt="Policy No" style="height: 20px; margin-top: 3px; cursor: pointer;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</td>
					<td class="rightAligned" style="padding: 0 7px 0 15px;">Endt No.</td>
					<td><input id="txtEndtNo" name="txtEndtNo" readonly="readonly" type="text" style="width: 170px;"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Assured Name</td>
					<td class="leftAligned"><input id="txtAssdName" name="txtAssdName" type="text" readonly="readonly"style="width: 315px;"></td>
					<td class="rightAligned" style="padding: 0 7px 0 15px;">Accounting Date</td>
					<td><input id="txtAcctEntDate" name="txtAcctEntDate" type="text" readonly="readonly" style="width: 170px;"></td>
				</tr>
			</table>
		</div>
		
		<div id="packPolicyDetailsDiv" name="packPolicyDetailsDiv" class="sectionDiv" style="width: 100%; height: 340px;">
			<table id="packPolicyDetailsTbl" align="center" style="margin-top: 60px;">
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Effectivity Date</td>
					<td><input id="txtEffDate" name="txtEffDate" type="text" readonly="readonly" style="width: 200px;"></td>
					<td class="rightAligned" style="padding: 0 7px 0 70px;">Expiry Date</td>
					<td><input id="txtEndtExpiryDate" name="txtEndtExpiryDate" type="text" readonly="readonly" style="width: 200px;"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">User Name</td>
					<td><input id="txtSpldUserId" name="txtSpldUserId" type="text" readonly="readonly" style="width: 200px;"></td>
					<td class="rightAligned" style="padding: 0 7px 0 70px;">Spoiled Date</td>
					<td><input id="txtSpldDate" name="txtSpldDate" type="text" readonly="readonly" style="width: 200px;"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Policy Status</td>
					<td>
						<input id="txtSpldFlag" type="hidden">
						<input id="txtMeanPolFlag" name="txtMeanPolFlag" type="text" readonly="readonly" style="width: 200px;">
					</td>
					<td class="rightAligned" style="padding: 0 7px 0 70px;">Approval</td>
					<td><input id="txtSpldApproval" name="txtSpldApproval" type="text" readonly="readonly" style="width: 200px;"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Reason for Spoilage</td>
					<td colspan="3">
						<div id="spoilCdDiv" readonly="readonly" class="sectionDiv" style="float: left; width: 70px; height: 21px; margin-right: 7px; border: 1px solid gray;">
							<input id="txtSpoilCd" readonly="readonly" type="text" maxlength="2" style="float: left; height: 13px; width: 44px; margin: 0px; border: none;">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSpoilCdLOV" name="searchSpoilCdLOV" alt="Go" style="float: right;"/>
						</div>							
						<input id="txtSpoilDesc" name="txtSpoilDesc" type="text" maxlength="100" readonly="readonly" style="float: left; width: 485px; margin: 0px;">				
					</td>
				</tr>
			</table>
			
			<div id="buttonsDiv" name="buttonsDiv" align="center" class="buttonsDiv" style="margin-top: 50px;">
				<input id="btnSpoil" name="btnSpoil" type="button" class="button" value="Spoil Policy/Endorsement" style="width: 180px;">
				<input id="btnUnspoil" name="btnUnspoil" type="button" class="button" value="Unspoil Policy/Endorsement" style="width: 180px;">
				<input id="btnPost" name="btnPost" type="button" class="button" value="Post Spoilage" style="width: 180px;">
			</div>
			<input type="hidden" id="hidAllowSpoil" name="hidAllowSpoil" value="${allowSpoilageRecWrenewal}"/>	<!-- kenneth SR 4753/CLIENT SR 17487 07062015 -->
		</div>
	</div>
</div>

<script type="text/javascript">
	initializeAccordion();
	initializeAll();
	setModuleId("GIUTS003A");
	setDocumentTitle("Spoil Package Policy/Endorsement");
	
	$("txtPolLineCd").focus();
	
	objGiuts003a.start = 0;
	objGiuts003a.packPolicyId = null;
	
	observeReloadForm("reloadForm", showSpoilPostedPackagePolicy);
	observeReloadForm("btnQuery", showSpoilPostedPackagePolicy);

	disableButton("btnSpoil");
	disableButton("btnUnspoil");
	disableButton("btnPost");
	
	whenNewFormInstanceGiuts003a();
	
	
	function whenNewFormInstanceGiuts003a(){
		try{
			new Ajax.Request(contextPath+"/SpoilageReinstatementController?action=whenNewFormInstanceGiuts003a",{
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						objGiuts003a.reqSplReason = obj.reqSplReason;
						
						if (obj.allowSpoilage == "N"){
							showWaitingMessageBox("Batch Accounting Process is currently in progress. You are not yet allowed to spoil policies.", "I", function(){
								goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
							});
						}else if(obj.clmStatCancel == null){
							$("txtPolLineCd").setAttribute("readonly", "readonly");
							$("txtPolSublineCd").setAttribute("readonly", "readonly");
							$("txtPolIssCd").setAttribute("readonly", "readonly");
							$("txtPolIssueYy").setAttribute("readonly", "readonly");
							$("txtPolPolSeqNo").setAttribute("readonly", "readonly");
							$("txtPolRenewNo").setAttribute("readonly", "readonly");
							disableSearch("searchPolicyNoLOV");
							disableSearch("searchSpoilCdLOV");
							showMessageBox("Record not found in GIIS_PARAMETERS for param_name GICL_CLAIMS_CLM_STAT_CD_CANCELLED", "I");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("whenNewFormInstanceGiuts003a", e);
		}
	}
		
		
	$("txtPolLineCd").observe("keyup", function(){
		$("txtPolLineCd").value = $("txtPolLineCd").value.toUpperCase();	
	});
	
	$("txtPolSublineCd").observe("keyup", function(){
		$("txtPolSublineCd").value = $("txtPolSublineCd").value.toUpperCase();	
	});
	
	$("txtPolIssCd").observe("keyup", function(){
		$("txtPolIssCd").value = $("txtPolIssCd").value.toUpperCase();	
	});
	
	$("txtPolPolSeqNo").observe("blur", function(){
		$("txtPolPolSeqNo").value = formatNumberDigits($F("txtPolPolSeqNo"), 7);
	});
	
	$("txtPolRenewNo").observe("blur", function(){
		$("txtPolRenewNo").value = formatNumberDigits($F("txtPolRenewNo"), 2);
	});
	
	$("searchPolicyNoLOV").observe("click", function(){
		showPackPolicyGiuts003aLOV();
	});
	
	$("searchSpoilCdLOV").observe("click", function(){
		showSpoilageReasonGiuts003aLOV();
	});
	
	
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
	
	function checkAllowPackSpoil(packPolId, onOk){
		if(checkPackExpiryTable(packPolId)){
			if($F("hidAllowSpoil") == "Y"){
				showConfirmBox("Confirmation", "The policy has been extracted/processed for renewal. Spoiling of record will cause the deletion of records in renewal tables.", "Yes", "No", onOk , "");
			}else{
				showMessageBox("The policy has been extracted/processed for renewal. Spoiling of record is not allowed since it will cause the deletion of records in renewal tables.", "I");
			}
		}else{
			onOk();
		}
	}
	
	$("btnSpoil").observe("click", function(){
		//chkPackPolicyForSpoilageGiuts003a();//kenneth SR 4753/CLIENT SR 17487 07062015
		//checkAllowPackSpoil(objGiuts003a.packPolicyId, chkPackPolicyForSpoilageGiuts003a);
		if (objGiuts003a.reqSplReason == "Y"){
			if ($F("txtSpoilCd") == ""){
				showWaitingMessageBox("Please specify reason for spoilage", "E",function(){return false;});
				return false;
			}else{
				checkAllowPackSpoil(objGiuts003a.packPolicyId, chkPackPolicyForSpoilageGiuts003a);
			}
		}else{
   			checkAllowPackSpoil(objGiuts003a.packPolicyId, chkPackPolicyForSpoilageGiuts003a);
		}
	});
	
	
	$("btnUnspoil").observe("click", function(){
		if($F("txtSpldFlag") == 2){
			unspoilPackGiuts003a();
		}else{
			showMessageBox("Policy / Endorsement is not tagged for spoilage. Not Unspoiled.", "E");
		}
	});
	
	
	$("btnPost").observe("click", function(){
		function proceedPostingSpoil(){
			objGiuts003a.continueSpoilage = null;
			objGiuts003a.start = 0;
			chkPackPolicyPostGiuts003a();
		}
		
		checkAllowPackSpoil(objGiuts003a.packPolicyId, proceedPostingSpoil);
	});
	
	
	$("btnExit").observe("click", function(){
		//objGiuts033a.pack_policy_id = $F("txtPackPolicyId");
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	
	function showSpoilageReasonGiuts003aLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: { action: "getSpoilageReasonGiuts003aLOV",
							 moduleId: "GIUTS003A"
			},
			title: "Reason for Spoilage",
			width: 400,
			height: 320,
			columnModel: [
			              {
			            	  id: "spoilCd",
			            	  title: "Spoil Cd",
			            	  width: '85px',
			            	  filterOption: true
			              },
			              {
			            	  id: "spoilDesc",
			            	  title: "Description",
			            	  width: '300px',
			            	  filterOption: true
			              }
			             ],
			draggable: true,
			onSelect: function(row){
				if($F("txtSpldFlag") != 3){
					$("txtSpoilCd").value = row.spoilCd;
					$("txtSpoilDesc").value = unescapeHTML2(row.spoilDesc);
				}				
			}
		});
	}
	
	
	function showPackPolicyGiuts003aLOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: { action: 		"getGiuts003aPackPolicyLOV",
							 moduleId:		"GIUTS003A",
							 packPolicyId:	objGiuts003a.packPolicyId,
							 lineCd:		$F("txtPolLineCd"),	
							 sublineCd:		$F("txtPolSublineCd"),
							 issCd:			$F("txtPolIssCd"),
							 issueYy:		$F("txtPolIssueYy"),
							 polSeqNo:		$F("txtPolPolSeqNo"),
							 renewNo: 		$F("txtPolRenewNo"),
							 page: 			1 
			},
			title: "Policy Listing",
			width: 910,
			height: 400,
			filterVersion: "2",
			columnModel: [
			              {
			            	id: "packPolicyId",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "packParId",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "lineCd",
			            	title: "Line Cd",
			            	width: "0px",
			            	visible: false,
			            	//filterOption: true
			              },
			              {
			            	id: "sublineCd",
			            	title: "Subline Cd",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "issCd",
			            	title: "Issue Cd",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "issueYy",
			            	title: "Issue Year",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "polSeqNo",
			            	title: "Pol. Seq No.",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "renewNo",
			            	title: "Renew No",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "endtIssCd",
			            	title: "Endt Iss Cd",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "endtYy",
			            	title: "Endt Year",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "endtSeqNo",
			            	title: "Endt Seq No.",
			            	width: "0px",
			            	visible: false,
			            	filterOption: true
			              },
			              {
			            	id: "assdNo",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "effDate",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "expiryDate",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "endtExpiryDate",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "spldDate",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "spldFlag",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "meanPolFlag",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "spoilCd",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "spoilDesc",
			            	width: "0px",
			            	visible: false
			              },
			              {
			            	id: "policyNo",
			            	title: "Policy No.",
			            	width: "180px"
			              },
			              {
			            	id: "assdName",
			            	title: "Assured Name",
			            	width: "220px",
			            	filterOption: true
			              },
			              {
			            	id: "endtNo",
			            	title: "Endt. No.",
			            	width: "160px"
			              },
			              {
			            	id: "acctEntDate",
			            	title: "Accounting Date",
			            	width: "139px",
			            	filterOption: true
			              },
			              {
		            	  	id: "policyStatus",
		            	  	title: "Policy Status",
		            	  	width: "150px"
			              }
			            ],
			draggable: true,
			onSelect: function(row){
				if (row != undefined){
					populatePackPolicyFieldsGiuts003a(row);					
					toggleButtonsGiuts003a(row.spldFlag);
				}
			}
		});
	}
	
	function populatePackPolicyFieldsGiuts003a(row){
		objGiuts003a.packPolicyId = row.packPolicyId;
		objGiuts003a.packParId = row.packParId;
		$("txtPolLineCd").value = unescapeHTML2(row.lineCd);
		$("txtPolSublineCd").value = unescapeHTML2(row.sublineCd);
		$("txtPolIssCd").value = unescapeHTML2(row.issCd);
		$("txtPolIssueYy").value = unescapeHTML2(row.issueYy);
		$("txtPolPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
		$("txtPolRenewNo").value = formatNumberDigits(row.renewNo, 2);		
		$("txtEndtNo").value = unescapeHTML2(row.endtNo);
		$("txtAssdName").value = unescapeHTML2(row.assdName);
		$("txtAcctEntDate").value = formatDateToDefaultMask(row.acctEntDate);
		
		$("txtEffDate").value = formatDateToDefaultMask(row.effDate);
		if(row.endtExpiryDate == null){
			$("txtEndtExpiryDate").value = formatDateToDefaultMask(row.expiryDate);
		}else{
			$("txtEndtExpiryDate").value = formatDateToDefaultMask(row.endtExpiryDate);
		}		
		$("txtSpldUserId").value = unescapeHTML2(row.spldUserId);
		$("txtSpldDate").value = row.spldDate == null ? null : dateFormat(row.spldDate, 'dd-mmm-yyyy');
		$("txtSpldFlag").value = row.spldFlag;
		$("txtMeanPolFlag").value = unescapeHTML2(row.policyStatus);
		$("txtSpldApproval").value = row.spldApproval;
		$("txtSpoilCd").value = row.spoilCd;
		$("txtSpoilDesc").value = unescapeHTML2(row.spoilDesc);
		
		toggleButtonsGiuts003a(row.spldFlag);
	}
	
	function toggleButtonsGiuts003a(spldFlag){
		if (spldFlag == 1){		//not spoiled
			enableButton("btnSpoil");
			disableButton("btnUnspoil");
			disableButton("btnPost");
			enableSearch("searchSpoilCdLOV");
		}else if(spldFlag == 2){	//tagged for spoilage
			disableButton("btnSpoil");
			enableButton("btnUnspoil");
			enableButton("btnPost");
// 			enableSearch("searchSpoilCdLOV");
			disableSearch("searchSpoilCdLOV");//added by steven 05.16.2013 base on PHILFIRE SR 0013091
		}else if(spldFlag == 3){	//spoiled
			disableButton("btnSpoil");
			disableButton("btnUnspoil");
			disableButton("btnPost");
			disableSearch("searchSpoilCdLOV");
		}
		$("txtPolLineCd").setAttribute("readonly", "readonly");
		$("txtPolSublineCd").setAttribute("readonly", "readonly");
		$("txtPolIssCd").setAttribute("readonly", "readonly");
		$("txtPolIssueYy").setAttribute("readonly", "readonly");
		$("txtPolPolSeqNo").setAttribute("readonly", "readonly");
		$("txtPolRenewNo").setAttribute("readonly", "readonly");
	}
	
	function getPackPolicyDetailsGiuts003a(){
		try{
			new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
				method: "GET",
				parameters: {
					action: 		"getPackPolicyDetailsGiuts003a",
					moduleId:		"GIUTS003A",
					packPolicyId:	objGiuts003a.packPolicyId,
					lineCd:			$F("txtPolLineCd"),	
					sublineCd:		$F("txtPolSublineCd"),
					issCd:			$F("txtPolIssCd"),
					issueYy:		$F("txtPolIssueYy"),
					polSeqNo:		$F("txtPolPolSeqNo"),
					renewNo: 		$F("txtPolRenewNo"),
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						populatePackPolicyFieldsGiuts003a(obj);
					}
				}
			});
		}catch(e){
			showErrorMessage("getPackPolicyDetailsGiuts003a", e);
		}
	}
	
	function chkPackPolicyForSpoilageGiuts003a(){
		try{
			new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
				method: "GET",
				parameters: {
					action:			"chkPackPolicyForSpoilageGiuts003a",
					issCd:			$F("txtPolIssCd"),
					packPolicyId:	objGiuts003a.packPolicyId
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: showNotice("Checking of policy in process..."),
				onComplete: function(response){
					hideNotice();
					try{
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
							//var obj = JSON.parse(response.responseText);
							
							/*for (var i=0; i<obj.length; i++){
								if (obj[i].MSG_CONSIDERED != null){
									showMessageBox(obj[i].MSG_CONSIDERED, "I");
								}						
								if(obj[i].MSG_SPOILED != null){
									showMessageBox(obj[i].MSG_SPOILED, "E");
								}	
							}	*/		

							//apollo cruz 11.13.2015 sr#20906
							if(response.responseText != "")
								showWaitingMessageBox(response.responseText, imgMessage.INFO, spoilPackGiuts003a);
							else
								spoilPackGiuts003a();
						}
					}catch(e){
						showErrorMessage("chkPackPolicyForSpoilageGiuts003a - onComplete", e);	
					}
					
				}
			});
		}catch(e){
			showErrorMessage("chkPackPolicyForSpoilageGiuts003a", e);
		}
	}
	
	function spoilPackGiuts003a(){
		try{
			if($F("txtSpldFlag") == 1){
				/* if (objGiuts003a.reqSplReason == "Y"){
					if ($F("txtSpoilCd") == ""){
						showWaitingMessageBox("Please specify reason for spoilage", "E",function(){return false;});
						return false;
					}
				} */
				
				disableButton("btnSpoil");
				enableButton("btnUnspoil");
				enableButton("btnPost");
				$("txtSpldFlag").value = "2";
				
				new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
					method: "GET",
					parameters: {
						action: 		"spoilPackGiuts003a",
						spoilCd:		$F("txtSpoilCd"),
						spldFlag:		$F("txtSpldFlag"),
						packPolicyId:	objGiuts003a.packPolicyId
					},
					asynchronous: true,
					evalScripts: true,
					onCreate: showNotice("Spoilage in process..."),
					onComplete: function(response){
						hideNotice();
						
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText);
							getPackPolicyDetailsGiuts003a();			
							showMessageBox(obj.message, "I");
						}
					}
				});				
			}
		}catch(e){
			showErrorMessage("spoilPackGiuts003a", e);
		}
	}
	
	function unspoilPackGiuts003a(){
		try{
			new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
				method: "GET",
				parameters: {
					action:			"unspoilPackGiuts003a",
					issCd:			$F("txtPolIssCd"),
					spldFlag:		$F("txtSpldFlag"),
					packPolicyId:	objGiuts003a.packPolicyId
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: showNotice("Unspoiling the policy / endorsement in process..."),
				onComplete: function(response){
					hideNotice();
					try{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText);
							getPackPolicyDetailsGiuts003a();	
							showMessageBox(obj.message, "I");
						}
					}catch(e){
						showErrorMessage("unspoilPackGiuts003a - onComplete", e);
					}
				}
			});
		}catch(e){
			showErrorMessage("unspoilPackGiuts003a", e);
		}
	}
	
	
	function chkPackPolicyPostGiuts003a(){
		try{
			new Ajax.Request(contextPath+"/SpoilageReinstatementController",{
				method: "GET",
				parameters: {
					action:				"chkPackPolicyPostGiuts003a",
					moduleId:			"GIUTS003A",
					lineCd:				$F("txtPolLineCd"),
					issCd:				$F("txtPolIssCd"),
					packPolicyId:		objGiuts003a.packPolicyId,
					continueSpoilage:	objGiuts003a.continueSpoilage,
					start:				objGiuts003a.start
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: showNotice("Posting Spoilage..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						if (obj.finalMsg != "SUCCESS"){
							if (obj.policyNo != null){
								objGiuts003a.start = obj.start;
								showConfirmBox("", "The policy " +obj.policyNo+" has claims, do you want to continue spoilage?", "Yes", "No",
										function(){
											objGiuts003a.continueSpoilage = "Y";
											chkPackPolicyPostGiuts003a();
										},
										function(){
											objGiuts003a.continueSpoilage = "N";
											chkPackPolicyPostGiuts003a();
										}
								);
							}else{
								objGiuts003a.continueSpoilage = null;
							}
						}else{
							if(obj.msgConsidered != null){
								showMessageBox(obj.msgConsidered, "I");
							}
							objGiuts003a.annPremAmt = obj.annPremAmt;
							objGiuts003a.annTsiAmt = obj.annTsiAmt;
							showMessageBox("Policy/Endorsement has been spoiled.", "I");
							getPackPolicyDetailsGiuts003a();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("chkPackPolicyPostGiuts003a", e);
		}
	}
	
</script>