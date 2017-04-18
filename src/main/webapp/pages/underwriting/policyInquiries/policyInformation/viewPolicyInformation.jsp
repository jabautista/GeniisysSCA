<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="viewPolInfoMainDiv" name="viewPolInfoMainDiv" style="">
<!-- 	<div id="regeneratePolicyDocumentsMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="queryPolicy">Query</a></li>
					<li><a id="parExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div> -->
	<div id="toolbarDiv" name="toolbarDiv">	
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery1">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQuery1Disabled">Enter Query</span>
		</div>
<%--		<div class="toolbarsep" id="btnToolbarEnterQuerySep1">&#160;</div>
 		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery1">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQuery1Disabled">Execute Query</span>
		</div> --%>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit1">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExit1Disabled">Exit</span>
		</div>
	 </div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label id="printPageId">Policy Information</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<form id="formPolicyInfo" name="formPolicyInfo">
		<input type="hidden" id="pageNo" name="pageNo">
		<input type="hidden" id="lineCd" name="lineCd" value="">
		<input type="hidden" id="menuLineCd" name="menuLineCd" value="">
		<div class="sectionDiv" id="policyInfoDiv" style="padding-bottom: 10px;">
			<div id="policyInformation">
				<!-- <div class="toolbar" style="width:100%;margin: 1px 1px 1px 1px;" id="toolbar" name="toolbar" >
					<span>
						<label id="queryPolicy" name="queryPolicy" style="width:100px; margin-left: 2px;">Query Policy</label>
						<label style="float: right; margin-right: 2px;" id="search" name="search">Search</label>
						<label style="float: right; margin-right: 2px;" id="filter" name="filter">Filter</label>
					</span>
				</div> -->
				<table style="margin-top: 10px;">
					<tr>
						<td id="tdPolicyNoLabel" class="rightAligned">Policy No.</td>
						<td style="width: 492px;" removeStyle="true">
							<input type="text" name="txtLineCd" id="txtLineCd" class="required" style="width: 30px;" title="Line" maxlength="2"/>
							<input type="text" name="txtSublineCd" id="txtSublineCd" class="required" style="width: 80px;" title="Subline" maxlength="7"/>
							<input type="text" name="txtIssCd" id="txtIssCd" class="required" style="width: 30px;" title="Issue Code" maxlength="2"/>
							<input type="text" name="txtIssueYy" id="txtIssueYy" class="required" style="width: 30px; text-align: right;" title="Issue Year" maxlength="2" class="integerNoNegativeUnformatted"/>
							<input type="text" name="txtPolSeqNo" id="txtPolSeqNo" class="required" style="width: 80px; text-align: right;" title="Sequence No" maxlength="6" class="integerNoNegativeUnformatted"/>
							<input type="text" name="txtRenewNo" id="txtRenewNo" class="required" style="width: 30px; text-align: right;" title="Renew No" maxlength="2" class="integerNoNegativeUnformatted"/>
							/				
							<input type="text" name="txtRefPolNo" id="txtRefPolNo" style="width: 100px;" title="Ref Pol No"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForPolicy" name="searchForPolicy" style="cursor: pointer;" title="Search Policy" alt="Go"/>
						</td>
						<td class="rightAligned">Term</td>
						<td><input type="text" name="txtDspInceptDate" id="txtDspInceptDate" title="Incept Date" maxlength="10" readonly="readonly" style="width:100px;"/></td>
						<td><input type="text" name="txtDspExpiryDate" id="txtDspExpiryDate" title="Expiry Date" maxlength="10" readonly="readonly" style="width:100px;"/></td>
					</tr>
					<tr>
						<td class="rightAligned">PAR No.</td>
						<td>
							<input type="text" name="txtNbtLineCd" id="txtNbtLineCd" style="width: 30px;" title="Par Line" maxlength="2"/>
							<input type="text" name="txtNbtIssCd" id="txtNbtIssCd" style="width: 30px;" title="Par Issue Code" maxlength="2"/>
							<input type="text" name="txtNbtParYy" id="txtNbtParYy" style="width: 65px;" title="Par Year" maxlength="2"/>
							<input type="text" name="txtNbtParSeqNo" id="txtNbtParSeqNo" style="width: 101px;" title="Par Sequence No" maxlength="6"/>
							<input type="text" name="txtNbtQuoteSeqNo" id="txtNbtQuoteSeqNo" style="width: 65px;" title="Quote Sequence No" maxlength="2"/>
						</td>
						<td class="rightAligned">Issue Date</td>
						<td><input type="text" name="txtIssueDate" id="txtIssueDate" title="Issue Date" maxlength="10" readonly="readonly" style="width:100px;"/></td>
					</tr>
					<tr>
						<td id="tdAssuredLabel" class="rightAligned">Assured</td>
						<td>
							<input type="text" name="txtDspAssdNo" id="txtDspAssdNo" style="text-align: right; width: 72px;" title="Assured No" readonly="readonly"/>
							<input type="text" name="txtDspAssdName" id="txtDspAssdName" style="width: 378px;" title="Assured Name" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Status</td>
						<td>
							<input type="text" name="txtDspMeanPolFlag" id="txtDspMeanPolFlag" style="width: 141px;" title="Pol Flag" maxlength="10" readonly="readonly"/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Renewal No.
							<input type="text" name="txtLineCdRn" id="txtLineCdRn" style="width: 30px;" title="Renewal Line Code" maxlength="2" readonly="readonly"/>
							<input type="text" name="txtIssCdRn" id="txtIssCdRn" style="width: 30px;" title="Renewal Issue Code" maxlength="2" readonly="readonly"/>
							<input type="text" name="txtRnYy" id="txtRnYy" style="width: 30px;" title="Renewal Year" maxlength="2" readonly="readonly"/>
							<input type="text" name="txtRnSeqNo" id="txtRnSeqNo" style="width: 80px;" title="Renewal Sequence No" maxlength="6" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 110px;">Crediting Branch</td>
						<td>
							<input type="text" name="txtCreditBranch" id="txtCreditBranch" style="width: 100px;" readonly="readonly"/>
						</td>
						<td colspan="3" align="right" >
							<label name="lblPackPol" id="lblPackPol" style="opacity:0; color: red;"><b>Package Policy:&nbsp;</b></label>
							<label name="lblPackPolNo" id="lblPackPolNo" style="opacity:0; color: red; font-weight: bold"></label>
						</td>
						<!-- <td colspan="2">
							
						</td> -->
					</tr>
					<tr></tr>
					<tr>
						<td colspan="5" align="center">
							<input id="btnMotorcar" class="button" type="button" value="Motorcar" name="btnMotorcar" style="width:15%"/>
							<input id="btnMarineHull" class="button" type="button" value="Marine Hull" name="btnMarineHull" style="width:15%"/>
							<input id="btnAssuredInAcctOf" class="button" type="button" value="Assured/In Acct. of" name="btnAssuredInAcctOf" style="width:15%"/>
							<input id="btnEndorsementType" class="button" type="button" value="Endorsement Type" name="btnEndorsement" style="width:15%"/>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="center">
							<input id="btnByAssured" class="button" type="button" value="By Assured" name="btnByAssured" style="width:15%"/>
							<input id="btnByObligee" class="button" type="button" value="By Obligee" name="btnByObligee" style="width:15%"/>
							<input id="btnInitialAcceptance" class="button" type="button" value="Initial Acceptance" name="btnInitialAcceptance" style="width:15%"/>
							<input id="btnNotes" class="button" type="button" value="Notes" name="btnNotes" style="width:15%"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	

	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label id="printPageId">Policy Details</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="relatedPolDiv" name="relatedPolDiv"></div>	
</div>
<div id="polMainInfoDiv"></div>
<div id="endtTypeDiv"></div>
<input id="noClaimClaimId" value="" type="hidden" />
<script>
	//disableToolbarButton("btnToolbarExecuteQuery1");
	
	function disableQueryButtons(){
		$("btnMotorcar").disable();
		$("btnMotorcar").writeAttribute("class","disabledButton");
		$("btnMarineHull").disable();
		$("btnMarineHull").writeAttribute("class","disabledButton");
		$("btnByAssured").disable();
		$("btnByAssured").writeAttribute("class","disabledButton");
		$("btnEndorsementType").disable();
		$("btnEndorsementType").writeAttribute("class","disabledButton");
		$("btnByAssured").disable();
		$("btnByAssured").writeAttribute("class","disabledButton");
		$("btnAssuredInAcctOf").disable();
		$("btnAssuredInAcctOf").writeAttribute("class","disabledButton");
		$("btnByObligee").disable();
		$("btnByObligee").writeAttribute("class","disabledButton");
		$("btnInitialAcceptance").disable();
		$("btnInitialAcceptance").writeAttribute("class","disabledButton");
		$("btnNotes").disable();
		$("btnNotes").writeAttribute("class","disabledButton");
	}
	function disableQueryFields(){
		$("txtLineCd").writeAttribute("readonly","readonly");
		$("txtSublineCd").writeAttribute("readonly","readonly");
		$("txtIssCd").writeAttribute("readonly","readonly");
		$("txtIssueYy").writeAttribute("readonly","readonly");
		$("txtPolSeqNo").writeAttribute("readonly","readonly");
		$("txtRenewNo").writeAttribute("readonly","readonly");
		$("txtRefPolNo").writeAttribute("readonly","readonly");
		$("txtNbtLineCd").writeAttribute("readonly","readonly");
		$("txtNbtIssCd").writeAttribute("readonly","readonly");
		$("txtNbtParYy").writeAttribute("readonly","readonly");
		$("txtNbtParSeqNo").writeAttribute("readonly","readonly");
		$("txtNbtQuoteSeqNo").writeAttribute("readonly","readonly");
	}
	
	objGIPIS100.disableQueryFields = disableQueryFields;  // andrew 04.20.2012
	objGIPIS100.disableQueryButtons = disableQueryButtons;  // andrew 04.20.2012

	if(objGIPIS100.callingForm != "GIPIS000"){ // andrew 04.20.2012
		if('${jsonPolicy}' != ''){
			var policy = JSON.parse('${jsonPolicy}');
			if(policy != null){
				loadPolicy(policy);
				searchRelatedPolicies();
				
				if(objGIPIS100.callingForm == "GIPIS130"){
					$("lblPackPol").setStyle('opacity:0;');
					$("lblPackPolNo").setStyle('opacity:0;');
				} else {
					$("btnToolbarEnterQuery1").hide();
					//$("btnToolbarExecuteQuery1").hide();
					$("searchForPolicy").hide();
					objGIPIS100.disableQueryFields();
					objGIPIS100.disableQueryButtons();						
				}				
			}
		}
	}
	
	//Initilization
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	$("btnInitialAcceptance").disable();
	$("btnInitialAcceptance").writeAttribute("class","disabledButton");
	
	try{
		var objPolicyEndtSeq0 = JSON.parse('${policyEndtSeq0}'.replace(/\\/g, '\\\\'));
	}catch(e){}
	if(objPolicyEndtSeq0 != null){
		loadPolicy(objPolicyEndtSeq0);
		searchRelatedPolicies();
	}
	
	validateFields();
	
	// Main buttons and Links
	$("btnToolbarEnterQuery1").observe("click", function(){
		try{
			if($("polTableGridListing") != null){
				polTableGrid.keys.removeFocus(polTableGrid.keys._nCurrentFocus, true);
				polTableGrid.keys.releaseKeys();				
			}
			showViewPolicyInformationPage(); //Added by Jerome Bautista 08.10.2015 SR 19751
			document.getElementById("formPolicyInfo").reset();
			$("relatedPolDiv").innerHTML = "";
			enableQueryButtons();
			enableQueryFields();
			$("lblPackPol").setStyle('opacity:0;');
			$("lblPackPolNo").setStyle('opacity:0;');
			$("txtLineCd").focus();
			//disableToolbarButton("btnToolbarExecuteQuery1");
			enableSearch("searchForPolicy");
		}catch(e){
			showErrorMessage("Query Policy", e);
		}
		
	});

	/*$("search").observe("click", function(){
		observeSearchForPolicyInformationPage();
	});*/
	/**
	 * Show policy listing for GIPIS010
	 * 
	 * @author Veronica V. Raymundo
	 * @date 05.23.2012
	 */
	function showPolicyListForViewPolicyInfo(moduleId) {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPolicyListForViewPolicyInfo",
				lineCd : $F("txtLineCd"),
				sublineCd : $F("txtSublineCd"),
				issCd : $F("txtIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo"),
				refPolNo : $F("txtRefPolNo"),
				nbtLineCd : $F("txtNbtLineCd"),
				nbtIssCd : $F("txtNbtIssCd"),
				parYy : $F("txtNbtParYy"),
				parSeqNo : $F("txtNbtParSeqNo"),
				quoteSeqNo : $F("txtNbtQuoteSeqNo"),
				moduleId: nvl(moduleId, "GIPIS100")
			},
			title : "Policy Listing",
			width : 750,
			height : 390,
			hideColumnChildTitle : true,
			filterVersion : "2",
			autoSelectOneRecord: true,
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'policyId',
				width : '0',
				visible : false
			}, {
				id : 'policyNo',
				title : 'Policy No.',
				titleAlign : 'center',
				width : 230,
				children : [ {
					id : 'lineCd',
					title : 'Line Code',
					width : 30,
					filterOption : true,
					editable : false
				}, {
					id : 'sublineCd',
					title : 'Subline Code',
					width : 50,
					filterOption : true,
					editable : false
				}, {
					id : 'issCd',
					title : 'Policy Issue Code',
					width : 30,
					filterOption : true,
					editable : false
				}, {
					id : 'issueYy',
					title : 'Issue Year',
					type : 'number',
					align : 'right',
					width : 30,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 2);
					},
					editable : false
				}, {
					id : 'polSeqNo',
					title : 'Policy Sequence No.',
					type : 'number',
					align : 'right',
					width : 60,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 7);
					},
					editable : false
				}, {
					id : 'renewNo',
					title : 'Renew No.',
					type : 'number',
					align : 'right',
					width : 28,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 2);
					},
					editable : false
				} ]
			}, {
				id : 'parNo',
				title : 'Par No.',
				titleAlign : 'center',
				width : '180px',
				children : [ {
					id : 'nbtLineCd',
					title : 'PAR Line Code',
					width : 30,
					editable : false
				}, {
					id : 'nbtIssCd',
					title : 'PAR Issue Code',
					width : 30,
					filterOption : true,
					editable : false
				}, {
					id : 'parYy',
					title : 'PAR Year',
					type : 'number',
					align : 'right',
					filterOption : true,
					filterOptionType : 'number',
					width : 30,
					renderer : function(value) {
						return value == "" ? null : formatNumberDigits(value, 2);
					},
					editable : false
				}, {
					id : 'parSeqNo',
					title : 'PAR Sequence No',
					type : 'number',
					align : 'right',
					filterOption : true,
					filterOptionType : 'number',
					width : 60,
					renderer : function(value) {
						return value == "" ? null : formatNumberDigits(value, 6);
					},
					editable : false
				}, {
					id : 'quoteSeqNo',
					title : 'Quote Sequence No.',
					type : 'number',
					align : 'right',
					width : 28,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 2);
					},
					editable : false
                }, { //--SR#22332. added Reference Policy No. in filter list. 05.31.16 apignas_jr.
                    id : 'refPolNo',
                    title : 'Reference Policy No.',
                    width : 50,
                    filterOption : true,
                    editable: false
				} ]
			}, {
				id : 'assdName',
				title : 'Assured Name',
				titleAlign : 'left',
				width : '300px'
			}, ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					loadPolicy(row);					
					//enableToolbarButton("btnToolbarExecuteQuery1");					
					//searchRelatedPolicies();
					//objGIPIS100.disableQueryFields();
					//objGIPIS100.disableQueryButtons();
					searchRelatedPolicies();
					objGIPIS100.disableQueryFields();
					objGIPIS100.disableQueryButtons();
					disableSearch("searchForPolicy");
				}
			}
		});
	}	
	

	$("searchForPolicy").observe("click", function(){
		if($F("txtLineCd").trim() == ""){ // ginawang required field ang line code para mapabilis ang loading ng LOV :: 03.20.2014 :: bonok
			customShowMessageBox("Please enter Line Code first.", "I", "txtLineCd");
			$("txtLineCd").clear();
		}else{
			showPolicyListForViewPolicyInfo();
		}
	});

	$("btnToolbarExit1").observe("click", function () {
		//considered objAC.fromACMenu by robert SR 21673 03.22.2016
		if(nvl(objAC.fromACMenu,'N') == 'N' && (objGIPIS100.callingForm == "GIPIS000" || objGIPIS100.callingForm == "GIPIS130" || objGIPIS100.callingForm == "GIPIS116")){
			if(objGIPIS100.query == "Y"){ //edited by gab 08.17.2015
				showByAssuredPage();
			} else {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}
		} else if(objGIPIS100.callingForm == "GIACS000" || nvl(objAC.fromACMenu,'N') == 'Y'){ //considered objAC.fromACMenu by robert SR 21673 03.22.2016
			if(objGIPIS100.query == "Y"){ //edited by gab 08.17.2015
				showByAssuredPage();
			} else {
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		} else if(objGIPIS100.callingForm == "GIPIS199"){	// shan 09.02.2014
			$("policyInfoDiv").hide();
			$("declarationPolicyPerOpenPolicyMainDiv").show();
		} else {
			if($("claimInfoDiv") != null && $("claimViewPolicyInformationDiv") != null){
				$("claimInfoDiv").show();
				$$("div[name='mainNav']").each(function(e){
					if(nvl(e.getAttribute("claimsBasicMenu"),"N") == "Y"){
						e.show();
					}
				});
				$("claimViewPolicyInformationDiv").hide();
			}
			if(objGIPIS100.callingForm == "GICLS032"){						
				showClaimAdvice();			
			} else if(objGIPIS100.callingForm == "GIPIS100"){	// gab 08.04.2015
				showByAssuredPage();
			} else if(objGIPIS100.callingForm == "GICLS010"){
				showClaimBasicInformation();
			} else if(objGIPIS100.callingForm == "GICLS011"){
				showClaimRequiredDocs();
			} else if(objGIPIS100.callingForm == "GICLS029"){
				showPreliminaryLossReport();
			} else if(objGIPIS100.callingForm == getClaimItemModuleId(objCLMGlobal.lineCd)){
				showClaimItemInfo();
			} else if(objGIPIS100.callingForm == "GICLS041"){
				printClaimsDocs();
			} else if(objGIPIS100.callingForm == "GICLS030"){
				showLossExpenseHistory();
			} else if(objGIPIS100.callingForm == "GICLS024"){
				showClaimReserve();
			} else if(objGIPIS100.callingForm == "GICLS029"){
				showPreliminaryLossReport();
			} else if(objGIPIS100.callingForm == "GICLS028"){
				showPrelimLossAdvice();
			} else if(objGIPIS100.callingForm == "GICLS034"){
				showFinalLossReport();
			} else if(objGIPIS100.callingForm == "GICLS025"){
				showRecoveryInformation();
			} else if(objGIPIS100.callingForm == "GICLS054"){
				showRecoveryDistribution();
			} else if(objGIPIS100.callingForm == "GICLS033"){
				showGenerateFLAPage();
			}else if(objGIPIS100.callingForm == "GIIMM001"){
				showCreateQuoteFromViewPolicy();
			}else if(objGIPIS100.callingForm == 'GICLS062'){
				viewNoClaimMultiYyPolicyListing($F("noClaimClaimId"));
				//$("txtRemarks").setAttribute("readonly","readonly"); comment out to allow updating of Remarks field regardless of its status by MAC 11/22/2013.
				//disableButton("noClaimMultiSave"); comment out to allow saving of any changes in No Claim Multi Year by MAC 11/22/2013.
				$("itemAssdNo").hide();
				//$("itemPlateNo").hide(); comment out to allow updating of Plate Number by MAC 11/22/2013.
				objCLMGlobal.noClaimTypeListSelectedIndex = null; //set Selected Policy details to null upon form reload by MAC 11/22/2013.
			} else if(objGIPIS100.callingForm == "GIPIS132"){
				//showGIPIS132(); removed by carloR 07.25.2016
				$("viewPolicyStatusMainDiv").show(); //Added by CarloR 07.25.2015
				$("policyInformationDiv").hide(); //end
			} else if(objGIPIS100.callingForm == "GIPIS100A"){
				showPackagePolicyInformation(packPolId);
			} else if(objGIPIS100.callingForm == "GIPIS199"){
				showViewDeclarationPolicyPerOpenPolicy();
			}
		}
		
		if(objGIPIS100.query != "Y"){  //edited by gab 08.17.2015
			objGIPIS100.callingForm = null;
		}
		
	});

	//Query Buttons action
	$("btnMotorcar").observe("click", function(){
		showMotorCarsPage();
	});
	$("btnMarineHull").observe("click", function(){
		showMarineHullsPage();
	});
	$("btnByAssured").observe("click", function(){
		objGIPIS100.query = "N"; //added by gab 08.17.2015
		showByAssuredPage();
	});
	$("btnByObligee").observe("click", function(){
		showByObligeePage();
	});
	 $("btnAssuredInAcctOf").observe("click",function(){ //Rey 08/11/2011
		showByAssuredAcctOfPage();
	}); 
	$("btnEndorsementType").observe("click",function(){ //Rey 07-19-2011
		objGIPIS100.fromEndtType = "Y";
		showByEndorsementTypePage();
	});
	$("btnNotes").observe("click", function(){
		showNotesPage();
	});
	//$("").observe("click",function(){
		
	//});
	
	//function definitions
	function validateFields(){
		$("txtLineCd").observe("keyup", function(){
			$("txtLineCd").value = $F("txtLineCd").toUpperCase();
		});
		$("txtSublineCd").observe("keyup", function(){
			$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
		});
		$("txtIssCd").observe("keyup", function(){
			$("txtIssCd").value = $F("txtIssCd").toUpperCase();
		});
		
		/* $("txtIssueYy").observe("keyup", function(){ by bonok :: 09.07.2012
			$("txtIssueYy").value = $F("txtIssueYy").toUpperCase();
		});
		$("txtPolSeqNo").observe("keyup", function(){
			$("txtPolSeqNo").value = $F("txtPolSeqNo").toUpperCase();
		});
		$("txtRenewNo").observe("keyup", function(){
			$("txtRenewNo").value = $F("txtRenewNo").toUpperCase();
		}); */

		
		$("txtRefPolNo").observe("keyup", function(){
			$("txtRefPolNo").value = $F("txtRefPolNo").toUpperCase();
		});
		$("txtNbtLineCd").observe("keyup", function(){
			$("txtNbtLineCd").value = $F("txtNbtLineCd").toUpperCase();
		});
		$("txtNbtIssCd").observe("keyup", function(){
			$("txtNbtIssCd").value = $F("txtNbtIssCd").toUpperCase();
		});

		/* $("txtNbtParYy").observe("keyup", function(){ by bonok :: 09.07.2012
			$("txtNbtParYy").value = $F("txtNbtParYy").toUpperCase();
		});
		$("txtNbtParSeqNo").observe("keyup", function(){
			$("txtNbtParSeqNo").value = $F("txtNbtParSeqNo").toUpperCase();
		});
		$("txtNbtQuoteSeqNo").observe("keyup", function(){
			$("txtNbtQuoteSeqNo").value = $F("txtNbtQuoteSeqNo").toUpperCase();
		}); */
		
		$("txtIssueYy").observe("change", function(){ // by bonok :: 09.07.2012
			if(isNaN($F("txtIssueYy"))){
				$("txtIssueYy").clear();
				customShowMessageBox("Field must be of form 09.", "E", "txtIssueYy");
			}else if($F("txtIssueYy") != ""){
				$("txtIssueYy").value = formatNumberDigits($F("txtIssueYy"),2);
			}
		});
		
		$("txtPolSeqNo").observe("change", function(){ // by bonok :: 09.07.2012
			if(isNaN($F("txtPolSeqNo"))){
				$("txtPolSeqNo").clear();
				customShowMessageBox("Field must be of form 000009.", "E", "txtPolSeqNo");
			}else if($F("txtPolSeqNo") != ""){
				$("txtPolSeqNo").value = formatNumberDigits($F("txtPolSeqNo"),6);
			}
		});
		
		$("txtRenewNo").observe("change", function(){ // by bonok :: 09.07.2012
			if(isNaN($F("txtRenewNo"))){
				$("txtRenewNo").clear();
				customShowMessageBox("Field must be of form 09.", "E", "txtRenewNo");
			}else if($F("txtRenewNo") != ""){
				$("txtRenewNo").value = formatNumberDigits($F("txtRenewNo"),2);
			}
		});
		
		$("txtNbtParYy").observe("change", function(){ // by bonok :: 09.07.2012
			if(isNaN($F("txtNbtParYy"))){
				$("txtNbtParYy").clear();
				customShowMessageBox("Field must be of form 09.", "E", "txtNbtParYy");
			}else{
				$("txtNbtParYy").value = formatNumberDigits($F("txtNbtParYy"),2);
			}
		});
		
		$("txtNbtParSeqNo").observe("change", function(){ // by bonok :: 09.07.2012
			if(isNaN($F("txtNbtParSeqNo"))){
				$("txtNbtParSeqNo").clear();
				customShowMessageBox("Field must be of form 000009.", "E", "txtNbtParSeqNo");
			}else{
				$("txtNbtParSeqNo").value = formatNumberDigits($F("txtNbtParSeqNo"),6);
			}
		});
		
		$("txtNbtQuoteSeqNo").observe("change", function(){ // by bonok :: 09.07.2012
			if(isNaN($F("txtNbtQuoteSeqNo"))){
				$("txtNbtQuoteSeqNo").clear();
				customShowMessageBox("Field must be of form 09.", "E", "txtNbtQuoteSeqNo");
			}else{
				$("txtNbtQuoteSeqNo").value = formatNumberDigits($F("txtNbtQuoteSeqNo"),2);
			}
		});
		
	}
	
	function enableQueryButtons(){
		$("btnMotorcar").enable();
		$("btnMotorcar").writeAttribute("class","button");
		$("btnMarineHull").enable();
		$("btnMarineHull").writeAttribute("class","button");
		$("btnAssuredInAcctOf").enable();
		$("btnAssuredInAcctOf").writeAttribute("class","button");
		$("btnEndorsementType").enable();
		$("btnEndorsementType").writeAttribute("class","button");
		$("btnByAssured").enable();
		$("btnByAssured").writeAttribute("class","button");
		$("btnByObligee").enable();
		$("btnByObligee").writeAttribute("class","button");
		$("btnNotes").enable();
		$("btnNotes").writeAttribute("class","button");
	}
	function enableQueryFields(){
		$("txtLineCd").writeAttribute("readonly",false);
		$("txtSublineCd").writeAttribute("readonly",false);
		$("txtIssCd").writeAttribute("readonly",false);
		$("txtIssueYy").writeAttribute("readonly",false);
		$("txtPolSeqNo").writeAttribute("readonly",false);
		$("txtRenewNo").writeAttribute("readonly",false);
		$("txtRefPolNo").writeAttribute("readonly",false);
		$("txtNbtLineCd").writeAttribute("readonly",false);
		$("txtNbtIssCd").writeAttribute("readonly",false);
		$("txtNbtParYy").writeAttribute("readonly",false);
		$("txtNbtParSeqNo").writeAttribute("readonly",false);
		$("txtNbtQuoteSeqNo").writeAttribute("readonly",false);
	}
	
	initializeAccordion();

	if(objGIPIS100.endtType == "Y"){
		objGIPIS100.disableQueryFields();
		objGIPIS100.disableQueryButtons();
		//$("viewPolInfoMainDiv").hide();
	}
	
	$("txtLineCd").focus();
	
/*	$("btnToolbarExecuteQuery1").observe("click", function(){
		searchRelatedPolicies();
		objGIPIS100.disableQueryFields();
		objGIPIS100.disableQueryButtons();
		disableToolbarButton("btnToolbarExecuteQuery1");
		disableSearch("searchForPolicy");
	});
	
	$$("div#policyInfoDiv input[type='text']").each(
		function(obj){
			if(obj.getAttribute("readonly") == null){
				obj.observe("change", function(){
					if($("btnToolbarExecuteQuery1").getStyle("display") == "block"){
						$("txtLineCd").clear();
						$("txtSublineCd").clear();
						$("txtIssCd").clear();
						$("txtIssueYy").clear();
						$("txtPolSeqNo").clear();
						$("txtRenewNo").clear();
						$("txtRefPolNo").clear();
						$("txtDspInceptDate").clear();
						$("txtDspExpiryDate").clear();
						$("txtNbtLineCd").clear();
						$("txtNbtIssCd").clear();
						$("txtNbtParYy").clear();
						$("txtNbtParSeqNo").clear();
						$("txtNbtQuoteSeqNo").clear();
						$("txtIssueDate").clear();
						$("txtDspAssdName").clear();
						$("txtDspMeanPolFlag").clear();
						$("txtLineCdRn").clear();
						$("txtIssCdRn").clear();
						$("txtRnYy").clear();
						$("txtRnSeqNo").clear();
						$("txtCreditBranch").clear();
						$("lblPackPolNo").value = "";
						$("tdPolicyNoLabel").innerHTML  = "Policy No.";
						$("tdAssuredLabel").innerHTML	= "Assured";
						disableToolbarButton("btnToolbarExecuteQuery1");
					}		
				});
			}
		}
	); */
</script>