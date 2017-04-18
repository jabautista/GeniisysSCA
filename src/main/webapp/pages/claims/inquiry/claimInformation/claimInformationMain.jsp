<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="claimInformationMainDiv" name="claimInformationMainDiv">
	<div id="claimInformationMainMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="claimInfoBack">Back</a></li>
				</ul>
			</div>
		</div>
	</div>	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label>Claim Information</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="claimInformationSectionDiv" class="sectionDiv" style="margin:3px auto 50px auto;">
		<div id="claimInfoDiv">
			<div id="claimNoDiv" class="toolbar" style="height: 25px;">
				<h3 id="ctrClaimNo" style="margin:2.5px auto auto auto; font-weight:bold; text-align: center;"></h3>
			</div>
			<div id="claimInfoHeaderDiv">
				<table cellspacing="2" border="0">
		 			<tr>
		 				<td class="rightAligned" style="width: 120px;">Assured</td>
						<td class="leftAligned">
							<input id="txtAssured" name="txtAssured" type="text" style="width: 330px;" value="" readonly="readonly" />
						</td>
						<td class="rightAligned" style="width: 120px;">Loss Category</td>
						<td class="leftAligned" style="width: 230px;">
							<input id="txtLossCategory" style="width: 230px;" type="text" value="" readonly="readonly" />
						</td>
					</tr>
					<tr>
		 				<td class="rightAligned" style="width: 120px;">In account of</td>
						<td class="leftAligned">
							<input id="txtAccountOf" name="txtAccountOf" type="text" style="width: 330px;" value="" readonly="readonly" />
						</td>
						<td class="rightAligned" style="width: 120px;">Loss Date</td>
						<td class="leftAligned" style="width: 230px;">
							<input id="txtLossDate" style="width: 230px;" type="text" value="" readonly="readonly" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		
		<div id="tabComponentsDiv2" class="tabComponents1" style="align:center;width:100%">
			<ul>
				<li class="tab1 selectedTab1" style="width:15%"><a id="basicInfoTab">Basic Information</a></li>
				<li class="tab1" style="width:9%"><a id="itemInfoTab">Item Info</a></li>
				<li class="tab1" style="width:13%"><a id="claimReserveTab">Claim Reserve</a></li>
				<li class="tab1" style="width:18%"><a id="lossExpHistTab">Loss/Expense History</a></li>
				<li class="tab1" style="width:13%"><a id="lossRecoveryTab">Loss Recovery</a></li>
				<li class="tab1" style="width:8%"><a id="payeesTab">Payees</a></li>
				<li class="tab1" style="width:15%"><a id="reqDocsTab">Req'd Documents</a></li>				
			</ul>			
		</div>
		<div class="tabBorderBottom1"></div>

		<div id="tabPageContents" name="tabPageContents" style="width: 100%; float: left;">	
			<div id="tabBasicInfoContents" 		name="tabBasicInfoContents" 	style="width: 100%; float: left;">
				<jsp:include page="/pages/claims/inquiry/claimInformation/basicInformation/basicInfoMain.jsp"></jsp:include>
			</div>
			<div id="tabItemInfoContents" 		name="tabItemInfoContents" 		style="width: 100%; float: left; display: none;"></div>
			<div id="tabClaimReserveContents" 	name="tabClaimReserveContents" 	style="width: 100%; float: left; display: none;"></div>
			<div id="tabLossExpHistContents" 	name="tabLossExpHistContents" 	style="width: 100%; float: left; display: none;"></div>
			<div id="tabLossRecoveryContents" 	name="tabLossRecoveryContents" 	style="width: 100%; float: left; display: none;"></div>
			<div id="tabPayeesContents" 		name="tabPayeesContents" 		style="width: 100%; float: left; display: none;"></div>
			<div id="tabReqDocsContents" 		name="tabReqDocsContents" 		style="width: 100%; float: left; display: none;"></div>
		</div>
	</div>
</div>

<script>
	setModuleId("GICLS260");
	setDocumentTitle("Claim Information");
	initializeTabs();
	initializeAccordion();
	
	objCLMGlobal = JSON.parse('${jsonGICLClaims}');
	objCLMGlobal.callingForm = '${callingForm}';
	objCLMGlobal.callingForm2 = '${callingForm2}';
	var objGICLS260Variables = JSON.parse('${variables}');
	
	function populateBasicInfo(obj){
		var lossDate = nvl(obj.strDspLossDate,null) != null ? obj.strDspLossDate.substr(0, obj.strDspLossDate.indexOf(" ")) :null;
		var lossTime = nvl(obj.strDspLossDate,null) != null ? obj.strLossDate.substr(obj.strDspLossDate.indexOf(" ")+1, obj.strDspLossDate.length) :null;
		var dateSettled = nvl(obj.strClaimSettlementDate,null) != null ? obj.strClaimSettlementDate.substr(0, obj.strClaimSettlementDate.indexOf(" ")) :null;
		
		$("ctrClaimNo").innerHTML = unescapeHTML2(obj.claimNo)+" / "+unescapeHTML2(obj.policyNo);
		$("txtAssured").value = unescapeHTML2(obj.assuredName);
		$("txtLossCategory").value = unescapeHTML2(obj.lossCatCd) +" - "+unescapeHTML2(obj.dspLossCatDesc);
		$("txtAccountOf").value = unescapeHTML2(obj.dspAcctOfCdName);
		$("txtLossDate").value = dateFormat(lossDate, "mmmm d, yyyy");
		$("txtEffectivityDate").value = obj == null ? "" : obj.strPolicyEffectivityDate;
		$("txtExpiryDate").value = obj == null ? "" : obj.strExpiryDate;
		$("txtDspLossDate").value = obj == null ? "" : lossDate;
		$("txtLossTime").value = obj == null ? "" : lossTime;
		$("txtInHouAdj").value = obj == null ? "" : unescapeHTML2(obj.inHouseAdjustment);
		$("txtInHouAdjName").value = obj == null ? "" : unescapeHTML2(obj.dspInHouAdjName);
		$("txtClmFileDate").value = obj == null ? "" : obj.strClaimFileDate;
		$("txtRiCd").value = obj == null ? "" : obj.riCd;
		$("txtRiName").value = obj == null ? "" : unescapeHTML2(obj.dspRiName);
		$("txtCatCd").value = obj == null ? "" : obj.catastrophicCd;
		$("txtCatDesc").value = obj == null ? "" : unescapeHTML2(obj.dspCatastrophicDesc);
		$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);
		$("txtOpNumber").value = obj == null ? "" : unescapeHTML2(obj.opNumber);
		$("txtPlateNumber").value = obj == null ? "" : unescapeHTML2(obj.plateNumber);
		$("txtLossCatCd").value = obj == null ? "" : unescapeHTML2(obj.lossCatCd);
		$("txtLossCatDesc").value = obj == null ? "" : unescapeHTML2(obj.dspLossCatDesc);
		$("txtLossDetails").value = obj == null ? "" : unescapeHTML2(obj.lossDetails);
		$("txtLocOfLoss1").value = obj == null ? "" : unescapeHTML2(obj.lossLocation1);
		$("txtLocOfLoss2").value = obj == null ? "" : unescapeHTML2(obj.lossLocation2);
		$("txtLocOfLoss3").value = obj == null ? "" : unescapeHTML2(obj.lossLocation3);
		$("txtClmStatCd").value = obj == null ? "" : unescapeHTML2(obj.claimStatusCd);
		$("txtClmStatDesc").value = obj == null ? "" : unescapeHTML2(obj.claimStatDesc);
		$("txtUserId").value = obj == null ? "" : unescapeHTML2(obj.userId);
		$("txtLastUpdate").value = obj == null ? "" : obj.strUserLastUpdate;
		$("txtCredBranchCd").value = obj == null ? "" : unescapeHTML2(obj.creditBranch);
		$("txtCredBranchName").value = obj == null ? "" : unescapeHTML2(obj.dspCredBrDesc);
		$("txtCloseDate").value = obj == null ? "" : obj.strCloseDate;
		$("txtLossResAmt").value = obj == null ? "" : formatCurrency(obj.lossResAmount);
		$("txtLossPdAmt").value = obj == null ? "" : formatCurrency(obj.lossPaidAmount);
		$("txtExpResAmt").value = obj == null ? "" : formatCurrency(obj.expenseResAmount);
		$("txtExpPdAmt").value = obj == null ? "" : formatCurrency(obj.expPaidAmount);
		$("txtEntryDate").value = obj == null ? "" : obj.strEntryDate;
		$("txtClmSetlDate").value = obj == null ? "" : dateSettled;
		
		if(objCLMGlobal.callingForm == "GICLS271" ? obj.lineCode == "MC" : ($F("lineCd")== "MC" || $F("menuLineCd")== "MC")){
			$("lblPlateNumber").innerHTML = "Plate Number";
			$("txtPlateNumber").show();
		}else{
			$("lblPlateNumber").innerHTML = "";
			$("txtPlateNumber").hide();
		}
		
		if(obj != null){
			$("chkLossRecovery").checked = nvl(obj.recoverySw, "N")== "Y" ? true : false;
			$("chkPackPol").checked = nvl(obj.packPolNo, "") != "" ? true : false;
			$("chkOkProcessing").checked = nvl(obj.claimStatDesc, "") != "NOT OK" ? true : false;
			$("chkTotalLoss").checked = nvl(obj.totalTag, "N") == "Y" ? true : false;
			
			if(obj.claimStatusCd == "CC" || obj.claimStatusCd == "CD" ||
			   obj.claimStatusCd == "WD" || obj.claimStatusCd == "DN"){
			    $("lblCloseDate").innerHTML = "Close Date";
				$("txtCloseDate").show();	
			}else{
				$("lblCloseDate").innerHTML = "";
				$("txtCloseDate").hide();
			}
			
			if(nvl(obj.dspOpNumber, "") == ""){
				$("lblOpNumber").innerHTML = "";
				$("txtOpNumber").hide();
			}
			
			getBalanceAmtDue(obj);
			
		}else{
			$("chkLossRecovery").checked = false;
			$("chkOkProcessing").checked = false;
			$("chkPackPol").checked = false;
			$("chkTotalLoss").checked = false;
			$("lblCloseDate").innerHTML = "";
			$("txtCloseDate").hide();
			$("lblOpNumber").innerHTML = "";
			$("txtOpNumber").hide();
		}
		
	}
	
	function getBalanceAmtDue(obj){
		new Ajax.Request(contextPath + "/GICLClaimsController?action=getUnpaidPremiumDtls", {
			method: "GET",
			parameters: {
				lineCd: obj.lineCode,
				sublineCd: obj.sublineCd,
				polIssCd: obj.policyIssueCode,
				issueYy: obj.issueYy,
				polSeqNo: obj.policySequenceNo,
				renewNo: obj.renewNo,
				issCd: 	obj.issueCode,
				clmFileDate: obj.strClaimFileDate
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response){
				var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				var balanceAmtDue = result.balanceAmtDue;
				if (balanceAmtDue > 0){
					if($("chkOkProcessing").checked == true){ 
						$("txtUnpaidPremium").value = "W/ UNPAID PREMIUM";						
					}
				} 
			}
		});
	}
	
	populateBasicInfo(objCLMGlobal);
	
	$("editTxtRemarks").observe("click", function(){showEditor($("txtRemarks"), 4000, 'true');});
	
	$("basicInfoTab").observe("click", function(){
		$("tabBasicInfoContents").show();
		$("tabItemInfoContents").hide();
		$("tabClaimReserveContents").hide();
		$("tabLossExpHistContents").hide();
		$("tabLossRecoveryContents").hide();
		$("tabPayeesContents").hide();
		$("tabReqDocsContents").hide();
	});
	
	$("itemInfoTab").observe("click", function(){
		$("tabBasicInfoContents").hide();
		$("tabItemInfoContents").show();
		$("tabClaimReserveContents").hide();
		$("tabLossExpHistContents").hide();
		$("tabLossRecoveryContents").hide();
		$("tabPayeesContents").hide();
		$("tabReqDocsContents").hide();
		
		var itemUrl = getItemInfoAction();
		
		if(itemUrl == ""){
			showMessageBox("The page you requested is not yet existing.", "E");
			return false;
		}
		
		new Ajax.Request( contextPath + itemUrl, {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				url : itemUrl,
				ajax: 1
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showLoading("tabItemInfoContents", "Loading, please wait...", "30px");
			},
			onComplete: function (response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("tabItemInfoContents").update(response.responseText);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
		
	});
	
	function getItemInfoAction(){
		var itemUrl = "";
		var lineCd =  objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : nvl($("menuLineCd").value, $("lineCd").value);
		
		if(lineCd == "MC" || lineCd == objLineCds.MC){
			itemUrl = "/GICLMotorCarDtlController?action=showGICLS260MotorCarItemInfo";
		}else if(lineCd == "FI" || lineCd == objLineCds.FI){
			itemUrl = "/GICLFireDtlController?action=showGICLS260FireItemInfo";
		}else if(lineCd == "AV" || lineCd == objLineCds.AV){
			itemUrl = "/GICLAviationDtlController?action=showGICLS260AviationItemInfo";
		}else if(lineCd == "CA" || lineCd == objLineCds.CA){
			itemUrl = "/GICLCasualtyDtlController?action=showGICLS260CasualtyItemInfo";
		}else if(lineCd == "EN" || lineCd == objLineCds.EN){
			itemUrl = "/GICLEngineeringDtlController?action=showGICLS260EngineeringItemInfo";
		}else if(lineCd == "MH" || lineCd == objLineCds.MH){
			itemUrl = "/GICLMarineHullDtlController?action=showGICLS260MarineHullItemInfo";
		}else if(lineCd == "MN" || lineCd == objLineCds.MN){
			itemUrl = "/GICLCargoDtlController?action=showGICLS260MarineCargoItemInfo";
		}else if(lineCd == "PA" || lineCd == objLineCds.PA || lineCd == "AC" || lineCd == objLineCds.AC){
			itemUrl = "/GICLAccidentDtlController?action=showGICLS260AccidentItemInfo";
		}else{
			itemUrl = "/GICLClaimsController?action=showGICLS260OtherLinesItemInfo";
		}
		
		return itemUrl;
	}
	
	$("claimReserveTab").observe("click", function(){
		$("tabBasicInfoContents").hide();
		$("tabItemInfoContents").hide();
		$("tabClaimReserveContents").show();
		$("tabLossExpHistContents").hide();
		$("tabLossRecoveryContents").hide();
		$("tabPayeesContents").hide();
		$("tabReqDocsContents").hide();
		new Ajax.Request( contextPath + "/GICLClaimReserveController?action=showGICLS260ClaimReserve", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				ajax: 1
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showLoading("tabClaimReserveContents", "Loading, please wait...", "30px");
			},
			onComplete: function (response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("tabClaimReserveContents").update(response.responseText);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	});
	
	$("lossExpHistTab").observe("click", function(){
		$("tabBasicInfoContents").hide();
		$("tabItemInfoContents").hide();
		$("tabClaimReserveContents").hide();
		$("tabLossExpHistContents").show();
		$("tabLossRecoveryContents").hide();
		$("tabPayeesContents").hide();
		$("tabReqDocsContents").hide();
		
		new Ajax.Request( contextPath + "/GICLClaimLossExpenseController?action=showGICLS260LossExpenseHistory", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				ajax: 1
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : function() {
				showLoading("tabLossExpHistContents", "Loading, please wait...", "30px");
			},
			onComplete: function (response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("tabLossExpHistContents").update(response.responseText);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	});
	
	$("lossRecoveryTab").observe("click", function(){
		$("tabBasicInfoContents").hide();
		$("tabItemInfoContents").hide();
		$("tabClaimReserveContents").hide();
		$("tabLossExpHistContents").hide();
		$("tabLossRecoveryContents").show();
		$("tabPayeesContents").hide();
		$("tabReqDocsContents").hide();
		
		new Ajax.Request( contextPath + "/GICLClmRecoveryController?action=showGICLS260LossRecovery", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				ajax: 1
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : function() {
				showLoading("tabLossRecoveryContents", "Loading, please wait...", "30px");
			},
			onComplete: function (response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("tabLossRecoveryContents").update(response.responseText);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	});
	
	$("payeesTab").observe("click", function(){
		$("tabBasicInfoContents").hide();
		$("tabItemInfoContents").hide();
		$("tabClaimReserveContents").hide();
		$("tabLossExpHistContents").hide();
		$("tabLossRecoveryContents").hide();
		$("tabPayeesContents").show();
		$("tabReqDocsContents").hide();
		
		new Ajax.Request( contextPath + "/GICLClmClaimantController?action=showGICLS260LossPayees", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				ajax: 1
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : function() {
				showLoading("tabPayeesContents", "Loading, please wait...", "30px");
			},
			onComplete: function (response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("tabPayeesContents").update(response.responseText);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	});
	
	$("reqDocsTab").observe("click", function(){
		$("tabBasicInfoContents").hide();
		$("tabItemInfoContents").hide();
		$("tabClaimReserveContents").hide();
		$("tabLossExpHistContents").hide();
		$("tabLossRecoveryContents").hide();
		$("tabPayeesContents").hide();
		$("tabReqDocsContents").show();
		
		new Ajax.Request( contextPath + "/GICLReqdDocsController?action=showGICLS260ReqDocumentsListing", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : function() {
				showLoading("tabReqDocsContents", "Loading, please wait...", "30px");
			},
			onComplete: function (response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("tabReqDocsContents").update(response.responseText);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	});
	
	$("claimInfoBack").observe("click", function(){
		if(objCLMGlobal.callingForm == "GICLS260"){
			$("claimInfoListingMainDiv").show();
			$("claimInfoMainDiv").update("");
			claimInfoTableGrid.clear();
			claimInfoTableGrid.refresh();
		}else if(objCLMGlobal.callingForm == "GIPIS100"){
			showGIPIS100ClaimInfoListing(objCLMGlobal.claimId);  //replaced codes below by robert SR 21694 03.28.16
			//$("viewPolInfoMainDiv").show();
			//$("polMainInfoDiv").hide();
			//$("polMainInfoDiv").update("");
			//setModuleId("GIPIS100");
			//setDocumentTitle("View Policy Information");
		}else if(objCLMGlobal.callingForm == "GICLS271"){
			$("perUserMainDiv").show();
			$("claimInfoNew").update("");
			setModuleId("GICLS271");
			setDocumentTitle("Claim Listing Per User");
		}else if(objCLMGlobal.callingForm == "GIPIS111"){
			if (objUWGlobal.hidGIPIS111Obj.exposureMode == "TEMP") {
				if (objUWGlobal.hidGIPIS111Obj.exposureType == "ITEM") {
					objUWGlobal.hidGIPIS111Obj.setCurrentTab("tabItemTemporaryExposure");
				} else if (objUWGlobal.hidGIPIS111Obj.exposureType == "PERIL") {
					objUWGlobal.hidGIPIS111Obj.setCurrentTab("tabPerilTemporaryExposure");
				}
			} else if(objUWGlobal.hidGIPIS111Obj.exposureMode == "ACTUAL") {
				if (objUWGlobal.hidGIPIS111Obj.exposureType == "ITEM") {
					objUWGlobal.hidGIPIS111Obj.setCurrentTab("tabItemActualExposure");
				} else if (objUWGlobal.hidGIPIS111Obj.exposureType == "PERIL") {
					objUWGlobal.hidGIPIS111Obj.setCurrentTab("tabPerilActualExposure");
				}
			}
			$("casualtyAccumulationDiv").show();
			$("claimInfoDummyMainDiv").update("");
			setModuleId("GIPIS111");
			setDocumentTitle("Casualty Accumulation");
		}else if(objCLMGlobal.callingForm == "GIPIS110"){
			if (objUWGlobal.hidGIPIS110Obj.exposureMode == "TEMP") {
				if (objUWGlobal.hidGIPIS110Obj.exposureType == "ITEM") {
					objUWGlobal.hidGIPIS110Obj.setCurrentTab("tabItemTemporaryExposure");
				} else if (objUWGlobal.hidGIPIS110Obj.exposureType == "PERIL") {
					objUWGlobal.hidGIPIS110Obj.setCurrentTab("tabPerilTemporaryExposure");
				}
			} else if(objUWGlobal.hidGIPIS110Obj.exposureMode == "ACTUAL") {
				if (objUWGlobal.hidGIPIS110Obj.exposureType == "ITEM") {
					objUWGlobal.hidGIPIS110Obj.setCurrentTab("tabItemActualExposure");
				} else if (objUWGlobal.hidGIPIS110Obj.exposureType == "PERIL") {
					objUWGlobal.hidGIPIS110Obj.setCurrentTab("tabPerilActualExposure");
				}
			}
			$("blockAccumulationDiv").show();
			$("claimInfoDummyMainDiv").update("");
			setModuleId("GIPIS110");
			setDocumentTitle("Block Accumulation");
		}else if(objCLMGlobal.callingForm == "GIEXS004"){	//Kenenth L. 10.21.2013
			$("processExpPolMainDiv").show();
			$("claimInfoDiv").update("");
			setModuleId("GIEXS004");
			setDocumentTitle("Tag Expired Policies for Renewal");
		}
	});
	
	if(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode == "MC" : ($F("lineCd")== "MC" || $F("menuLineCd")== "MC")){
		enableButton("btnSettSurvAgent");
	}else{
		disableButton("btnSettSurvAgent");
	}

	// bonok :: 10.25.2013 :: SR-GENQA-301
	if($F("menuLineCd") == objGICLS260Variables.giispLineCd || $F("lineCd") == objGICLS260Variables.giispLineCd){
		enableButton("btnSettSurvAgent");
	}
	
	if(nvl(objCLMGlobal.obligeeNo,null) != null){
		enableButton("btnBondPolicyData");
	}else{
		disableButton("btnBondPolicyData");
	}
	
	if(nvl(objCLMGlobal.giclMortgageeExist,"N") == "Y"){
		enableButton("btnMortgagee");
	}else{
		disableButton("btnMortgagee");
	}
	
	if(nvl(objCLMGlobal.withRecovery,"N") == "Y"){
		enableButton("btnRecoveryAmts");
	}else{
		disableButton("btnRecoveryAmts");
	}
	
	if(nvl(objCLMGlobal.basicIntmSw,"N") == "Y"){
		enableButton("btnIntermediaries");
	}else{
		disableButton("btnIntermediaries");
	}
	
	function disableClaimsInfoTab(tabId) {
		var alter = new Element("label");
		alter.update($(tabId).innerHTML);
		alter.setStyle("color: #B0B0B0; margin-top:5px;margin-left:5px;");
		alter.id = tabId + "Disabled";
		$(tabId).insert({after: alter});
		$(tabId).hide();
	}
	
	function observeClaimsInfoTabs(){
		if(objGICLS260Variables.clmReserveExist == "N"){disableClaimsInfoTab("claimReserveTab");};
		if(objGICLS260Variables.lossExpExist == "N"){disableClaimsInfoTab("lossExpHistTab");};
		if(objGICLS260Variables.lossRecoveryExist == "N"){disableClaimsInfoTab("lossRecoveryTab");};
		if(objGICLS260Variables.payeesExist == "N"){disableClaimsInfoTab("payeesTab");};
	}
	
	observeClaimsInfoTabs();
</script>