<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="packagePolicyInfoMainDiv" name="packagePolicyInfoMainDiv" style="height: 100%;" class="">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>View Package Policy Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		   		<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="packagePolicyInfoFormDiv" style="">
		<table id="packagePolicy" cellspacing="0" align="center" style="padding-top: 20px; width: 100%;">
			<tr>
				<td class="rightAligned" style="width:110px;">Pack Policy No.</td>
				<td class="leftAligned" style="border: none; width:611px;">
					<input class="allCaps required" type="text" id="txtPolLineCd" name="txtPolLineCd" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="101" />
					<input class="allCaps required" type="text" id="txtPolSublineCd" name="txtPolSublineCd" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="102" />
					<input class="allCaps required" type="text" id="txtPolIssCd" name="txtPolIssCd" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="103" />
					<input class="integerNoNegativeUnformattedNoComma" type="text" id="txtPolIssueYy" name="txtPolIssueYy" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="104" />
					<input class="integerNoNegativeUnformattedNoComma" type="text" id="txtPolSeqNo" name="txtPolSeqNo" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="105" />
					<input class="integerNoNegativeUnformattedNoComma" type="text" id="txtPolRenewNo" name="txtPolRenewNo" style="width: 50px; float: left;" maxlength="2" tabindex="106" />
					<label style="float: left; margin: 4px 4px 4px 4px">/</label>
					<input class="allCaps" type="text" id="txtPolRefNo" name="txtPolRefNo" style="width: 140px; float: left; margin: 2px 4px 0 0" maxlength="30" tabindex="107" readonly="readonly" />
					<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPackage" name="searchPackage" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
					</span>
				</td>
				<td class="rightAligned" style="width:55px;">Term</td>
				<td class="leftAligned"><input class="leftAligned" type="text" id="txtTermDate" name="txtTermDate" style="width: 100px; float: left; margin: 2px 4px 0 0" readonly="readonly" tabindex="108" readonly="readonly"/></td>
			</tr>
		</table>
		<table cellspacing="0" align="center" style="width: 100%; padding-bottom: 20px;">
			<tr>
				<td class="rightAligned" style="width:110px;">Pack PAR No.</td>
				<td class="leftAligned" style="border: none; width:601px;">
					<input class="allCaps" type="text" id="txtParLine" name="txtParLine" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="109" readonly="readonly"/>
					<input class="allCaps" type="text" id="txtParIssCd" name="txtParIssCd" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="110" readonly="readonly" />
					<input class="integerNoNegativeUnformattedNoComma" lpad="2" type="text" id="txtParYy" name="txtParYy" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="111" readonly="readonly"/>
					<input class="integerNoNegativeUnformattedNoComma" lpad="6" type="text" id="txtParSeqNo" name="txtParSeqNo" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="6" tabindex="112" readonly="readonly"/>
					<input class="integerNoNegativeUnformattedNoComma" lpad="2" type="text" id="txtParQuoteSeqNo" name="txtParQuoteSeqNo" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="113" readonly="readonly"/>
					<!-- start SR-19640 : shan 07.09.2015 -->
					<label style="float: left; margin: 6px 4px 4px 4px; width:84px;" class="rightAligned">Endt No.</label>
					<input class="allCaps" type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="120" readonly="readonly"/>
					<input class="integerNoNegativeUnformattedNoComma" lpad="2" type="text" id="txtEndtYy" name="txtEndtYy" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="121" readonly="readonly"/>
					<input class="integerNoNegativeUnformattedNoComma" lpad="7" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" style="width: 60px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="122" readonly="readonly"/>
					<!-- end SR-19640 : shan 07.09.2015 -->
				</td>
				<td class="rightAligned" style="width:55px;">To</td>
				<td class="leftAligned"><input class="leftAligned" type="text" id="txtToDate" name="txtToDate" style="width: 100px; float: left; margin: 2px 4px 0 0" maxlength="30" readonly="readonly" tabindex="114"  /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:110px;">Assured</td>
				<td class="leftAligned" style="border: none; width:612px;">
					<input class="integerNoNegativeUnformattedNoComma rightAligned" type="text" id="txtAssuredNo" name="txtAssuredNo" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="12" tabindex="115"/>
					<input class="allCaps" type="text" id="txtAssuredName" name="txtAssuredName" style="width: 510px; float: left; margin: 2px 4px 0 0" maxlength="500" tabindex="116"/>
					<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssdPackage" name="searchAssdPackage" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:110px;">Status</td>
				<td class="leftAligned" style="border: none; width:601px;">
					<input class="allCaps" type="text" id="txtStatFlag" name="txtStatFlag" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="1" tabindex="117" readonly="readonly"/>
					<input class="allCaps" type="text" id="txtStatus" name="txtStatus" style="width: 200px; float: left; margin: 2px 4px 0 0" maxlength="30" tabindex="118" readonly="readonly"/>
					<label style="float: left; margin: 6px 4px 4px 4px; width:94px;" class="rightAligned">Renewal No.</label>
					<input class="allCaps" type="text" id="txtRenLineCd" name="txtRenLineCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="119" readonly="readonly"/>
					<input class="allCaps" type="text" id="txtRenIssCd" name="txtRenIssCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="120" readonly="readonly"/>
					<input class="integerNoNegativeUnformattedNoComma" lpad="2" type="text" id="txtRenYy" name="txtRenYy" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="121" readonly="readonly"/>
					<input class="integerNoNegativeUnformattedNoComma" lpad="7" type="text" id="txtRenSeqNo" name="txtRenSeqNo" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="122" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:65px;">Issue Date</td>
				<td class="leftAligned"><input class="leftAligned" type="text" id="txtIssueDate" name="txtIssueDate" style="width: 100px; float: left; margin: 2px 4px 0 0" maxlength="30" readonly="readonly" tabindex="123" /></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div id="tablePackagePolicyInfoDiv" style="padding-top: 20px; padding-left:200px; height: 230px;">
			<div id="tablePackagePolicyInfo" style="width: 500px;"></div>
		</div>
		<div style="clear: both; text-align: center; margin: 0 auto 10px; padding-bottom: 20px;">
			<input type="button" class="button" id="btnPolicyItem" value="Package Policy Item" style="width: 150px;"/>
			<input type="button" class="button" id="btnPolicyInfo" value="View Policy Info" style="width: 150px;"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIPIS100A");
	setDocumentTitle("Package Policy Information");
	initializeAccordion();
	pageOnLoadSet();
	objGIPIS100.callingForm = "GIPIS100A";
	var exec = false;
	objParams = new Object();
	
	packPolId = '${packPolId}';
	if(packPolId!=""){
		showPackageLOV();
	}
	
	$$("input[type=text]").each(function(a){
		$(a).observe("change",function(){
			if($(a).value != ""){
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});
	
	//fields validation
	$("searchPackage").observe("click",function(){
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
		} else {
			if (trim($("txtPolSublineCd").value) == ""){
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolSublineCd");
			} else {
				if (trim($("txtPolIssCd").value) == ""){
					customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolIssCd");
				}else {
					showPackageLOV();
				}
			}
		}
	});
	
	//added by gab 08.10.2015
	$("searchAssdPackage").observe("click", function() {
		showPackageAssdLOV();
	});
	
	//added by gab 08.10.2015
	$("txtAssuredName").observe("change", function() {
		if($("txtAssuredName").value != ""){
			showPackageAssdLOV();
		}
	});
	
	//added by gab 08.10.2015
	$("txtAssuredNo").observe("change", function() {
		if($("txtAssuredNo").value != ""){
			showPackageAssdLOV();
		}
	});
	
	$("txtPolSublineCd").observe("change",function(){
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			$("txtPolSublineCd").clear();
		} 
	});
	
	$("txtPolIssCd").observe("change",function(){
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			$("txtPolIssCd").clear();
		} else {
			if (trim($("txtPolSublineCd").value) == ""){
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolSublineCd");
				$("txtPolIssCd").clear();
			}
		}
	});
	
	$("txtPolIssueYy").observe("change",function(){
		if($("txtPolIssueYy").value != ""){
			$("txtPolIssueYy").value = lpad(nvl($("txtPolIssueYy").value,""), 2, '0');
		}
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			$("txtPolIssueYy").clear();
		} else {
			if (trim($("txtPolSublineCd").value) == ""){
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolSublineCd");
				$("txtPolIssueYy").clear();
			} else {
				if (trim($("txtPolIssCd").value) == ""){
					customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolIssCd");
					$("txtPolIssueYy").clear();
				}
			}
		}
	});
	
	$("txtPolSeqNo").observe("change",function(){
		if($("txtPolSeqNo").value != ""){
			$("txtPolSeqNo").value = lpad(nvl($("txtPolSeqNo").value,""), 7, '0');
		}
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			$("txtPolSeqNo").clear();
		} else {
			if (trim($("txtPolSublineCd").value) == ""){
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolSublineCd");
				$("txtPolSeqNo").clear();
			} else {
				if (trim($("txtPolIssCd").value) == ""){
					customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolIssCd");
					$("txtPolSeqNo").clear();
				}
			}
		}
	});
	
	$("txtPolRenewNo").observe("change",function(){
		if($("txtPolRenewNo").value != ""){
			$("txtPolRenewNo").value = lpad(nvl($("txtPolRenewNo").value,""), 2, '0');
		}
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			$("txtPolRenewNo").clear();
		} else {
			if (trim($("txtPolSublineCd").value) == ""){
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolSublineCd");
				$("txtPolRenewNo").clear();
			} else {
				if (trim($("txtPolIssCd").value) == ""){
					customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolIssCd");
					$("txtPolRenewNo").clear();
				}
			}
		}
	});
	
	$("btnToolbarExit").observe("click",function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnToolbarEnterQuery").observe("click",function(){
		resetForm();
	});
	
	$("btnToolbarExecuteQuery").observe("click",function(){
		queryPackagePolInfoTable();
		enableButton("btnPolicyItem");
		exec = true;
	});
	
	$("btnPolicyItem").observe("click",function(){
		showPackagePolicyItem();
	});
	
	$("btnPolicyInfo").observe("click",function(){
		showPolicyInformation(objParams.policyId);
	});
	
	$("reloadForm").observe("click", function(){
		if(exec){
			resetForm();
		}
		else{
			return false;
		}
	});
	
	function pageOnLoadSet(){
		disableToolbar(true);
		tableGrid= JSON.parse('${jsonpackagePolicyTable}');
		showTableGrid();
		$("txtPolLineCd").focus();
		$$("table#packagePolicy input[type='text']").each(function(a) {
			$(a).readOnly = false;
		});
		$$("input[type='text']").each(function(a) {
			$(a).clear();
		});
		$("txtPolRefNo").readOnly = true;
		$("txtTermDate").readOnly = true;
		enableSearch("searchPackage");
		enableSearch("searchAssdPackage");
		disableButton("btnPolicyItem");
		disableButton("btnPolicyInfo");
		delete objParams;
		exec = false;
	}
	
	function resetForm(){
		disableToolbar(true);
		//tableGrid = [];
		showTableGrid();
		$("txtPolLineCd").focus();
		$$("table#packagePolicy input[type='text']").each(function(a) {
			$(a).readOnly = false;
		});
		$("txtAssuredNo").readOnly = false;
		$("txtAssuredName").readOnly = false;	
		$$("input[type='text']").each(function(a) {
			$(a).clear();
		});
		$("txtPolRefNo").readOnly = true;
		$("txtTermDate").readOnly = true;
		enableSearch("searchPackage");
		enableSearch("searchAssdPackage");
		disableButton("btnPolicyItem");
		disableButton("btnPolicyInfo");
		exec = false;
	}
	
	function showTableGrid(){
		try {
			packagePolicyInfoTable = {
				url : contextPath +"/GIPIPolbasicController?action=showPackagePolicyInformation&refresh=1",
				id: 1,
				options : {
					height : '200px',
					width : '500px',
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						objParams.policyId = tbgPackagePolicyInfoTable.geniisysRows[y].policyId;
						enableButton("btnPolicyInfo");
						tbgPackagePolicyInfoTable.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tbgPackagePolicyInfoTable.keys.releaseKeys();
						disableButton("btnPolicyInfo");
					},
					onSort : function(){
						tbgPackagePolicyInfoTable.keys.releaseKeys();
					},
					postPager : function() {
						tbgPackagePolicyInfoTable.keys.releaseKeys();
					},
					onRowDoubleClick : function(){ // added by jdiago 07.04.2014
						showPolicyInformation(objParams.policyId);
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "policyNo",
						title: "Policy No",
						width: '480px',
						filterOption : true,
						align : "left",
						titleAlign : "left"
					}
				],
				rows : tableGrid.rows
			};
			tbgPackagePolicyInfoTable = new MyTableGrid(packagePolicyInfoTable);
			tbgPackagePolicyInfoTable.pager = tableGrid;
			tbgPackagePolicyInfoTable.render('tablePackagePolicyInfo');
		} catch (e) {
			showErrorMessage("packagePolicyInformation.jsp", e);
		}
	}
	
	function disableToolbar(sw){
		if(sw){
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function queryPackagePolInfoTable(){
		tbgPackagePolicyInfoTable.url = contextPath +"/GIPIPolbasicController?action=showPackagePolicyInformation&refresh=1&onSearch=1&packPolId="+objParams.packPolId;
		tbgPackagePolicyInfoTable._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function showPackagePolicyItem() {
		try {
			overlayPackagePolItem = Overlay.show(contextPath
					+ "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {
					action : "showPackagePolicyItem",
					ajax : "1",
					packPolId : objParams.packPolId
					},
				title : "Package Policy Item Information",
				 height: 250,
				 width: 825,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	function showPolicyInformation(policyId){
		new Ajax.Request(contextPath+"/GIPIPolbasicController?action=showViewPolicyInformationPage",{
			method: "POST",
			parameters: {policyId : policyId},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Getting Policy Information page, please wait..."),
			onComplete: function (response) {
				try {			
					hideNotice();
					packPolId = objParams.packPolId;
					if(checkErrorOnResponse(response)){
						setDocumentTitle("View Policy Information");
						if(objGIPIS100.callingForm != "GIPIS000"){						
							if ($("claimViewPolicyInformationDiv") != null){
								$("basicInformationMainDiv").update("");
								$$("div[name='mainNav']").each(function(e){
									if(nvl(e.getAttribute("claimsBasicMenu"),"N") == "Y"){
										e.hide();
									}
								});
								$("claimViewPolicyInformationDiv").update(response.responseText);
								$("claimViewPolicyInformationDiv").show();
							} else {
								$("dynamicDiv").update(response.responseText);
							}
						} else {
							$("mainContents").update(response.responseText);
						}
					}
				} catch (e){
					showErrorMessage("showViewPolicyInformationPage - onComplete", e);
				}
			}
		});
	}
	
	function showPackageLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action   : "showPackageLOV",
					moduleId : "GIPIS100A",
					lineCd	  : $("txtPolLineCd").value ,
					sublineCd: $("txtPolSublineCd").value,
					issCd    : $("txtPolIssCd").value,
					issueYy  : $("txtPolIssueYy").value,
					polSeqNo : $("txtPolSeqNo").value,
					renewNo  : $("txtPolRenewNo").value,
					packPolId : packPolId
				},
				title: "List of Package Policy Number",
				id: "packageList",
				width: 590,	// SR-19640 : shan 07.09.2015
				height: 390,
				hideColumnChildTitle : true,
				columnModel: [
		 			{
						id : 'packNo',
						title: 'Package Policy No',
						align: 'right',
						titleAlign : 'center',
						children : [ {
							id : 'lineCd',
							title : 'Line Code',
							width : 30,
						}, {
							id : 'sublineCd',
							title : 'Subline Code',
							width : 50,
						}, {
							id : 'issCd',
							title : 'Issue Issue Code',
							width : 30,
						}, {
							id : 'issueYy',
							title : 'Issue Year',
							type : 'number',
							align : 'right',
							width : 30,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
						}, {
							id : 'polSeqNo',
							title : 'Policy Sequence No.',
							type : 'number',
							align : 'right',
							width : 60,
							renderer : function(value) {
								return formatNumberDigits(value, 7);
							},
						},{
							id : 'renewNo',
							title : 'Renew No',
							type : 'number',
							align : 'right',
							width : 30,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
						} ]
					},
					{
						id : 'parNo',
						title: 'Package Par No',
						align: 'right',
						titleAlign : 'center',
						children : [ {
							id : 'parLineCd',
							title : 'Line Code',
							width : 30,
						}, {
							id : 'parIssCd',
							title : 'Subline Code',
							width : 50,
						}, {
							id : 'parYy',
							title : 'Issue Issue Code',
							width : 30,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							}
						}, {
							id : 'parSeqNo',
							title : 'Issue Year',
							type : 'number',
							align : 'right',
							width : 60,
							renderer : function(value) {
								return formatNumberDigits(value, 7);
							},
						}, {
							id : 'quoteSeqNo',
							title : 'Policy Sequence No.',
							type : 'number',
							align : 'right',
							width : 30,
							filterOption : true,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
						} ]
					},
					{	// SR-19640 : shan 07.09.2015
						id : 'endtNo',
						title: 'Endt. No',
						align: 'right',
						titleAlign : 'center',
						children : [ {
							id : 'endtIssCd',
							title : 'Endt Iss Code',
							width : 30,
						}, {
							id : 'endtYy',
							title : 'Endt Yy',
							width : 30,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							}
						}, {
							id : 'endtSeqNo',
							title : 'Endt Seq No',
							type : 'number',
							align : 'right',
							width : 60,
							renderer : function(value) {
								return formatNumberDigits(value, 7);
							},
						}]
					}
				],
				autoSelectOneRecord: true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtPolLineCd").value = unescapeHTML2(row.lineCd);
						$("txtPolSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtPolIssCd").value = unescapeHTML2(row.issCd);
						$("txtPolIssueYy").value = formatNumberDigits(row.issueYy,2);
						$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo,7);
						$("txtPolRenewNo").value = formatNumberDigits(row.renewNo,2);
						$("txtPolRefNo").value = unescapeHTML2(row.refPolNo);
						
						$("txtParLine").value = unescapeHTML2(row.parLineCd);
						$("txtParIssCd").value = unescapeHTML2(row.parIssCd);
						$("txtParYy").value = formatNumberDigits(row.parYy,2);
						$("txtParSeqNo").value = formatNumberDigits(row.parSeqNo,7);
						$("txtParQuoteSeqNo").value = formatNumberDigits(row.quoteSeqNo,2);
						
						// SR-19640 : shan 07.09.2015
						$("txtEndtIssCd").value = unescapeHTML2(row.endtIssCd);
						$("txtEndtYy").value = formatNumberDigits(row.endtYy,2);
						$("txtEndtSeqNo").value = formatNumberDigits(row.endtSeqNo,7);
						// end SR-19640
						
						$("txtAssuredNo").value = formatNumberDigits(row.assdNo,7);
						$("txtAssuredName").value = unescapeHTML2(row.assdName);
						
						$("txtStatFlag").value = unescapeHTML2(row.polFlag);
						$("txtStatus").value = unescapeHTML2(row.polStatus);
						
						/* $("txtRenLineCd").value = unescapeHTML2(row.lineCdRn);
						$("txtRenIssCd").value = unescapeHTML2(row.issCdRn);
						$("txtRenYy").value = formatNumberDigits(row.rnYy,2);
						$("txtRenSeqNo").value = formatNumberDigits(row.rnSeqNo,7); */
						
						objParams.packPolId = unescapeHTML2(row.packPolicyId);
						objParams.packParId = unescapeHTML2(row.packParId);
						
						$("txtIssueDate").value = dateFormat(unescapeHTML2(row.issueDate), "mm-dd-yyyy");
						$("txtToDate").value = dateFormat(unescapeHTML2(row.expiryDate), "mm-dd-yyyy");
						$("txtTermDate").value = dateFormat(unescapeHTML2(row.inceptDate), "mm-dd-yyyy");
						
						$$("input[type='text']").each(function(x) {
							$(x).readOnly = true;
						});
						disableSearch("searchPackage");
						disableSearch("searchAssdPackage");
						disableToolbar(false);
						if(packPolId!=""){
							tableGrid= JSON.parse('${jsonpackagePolicyTable}');
							enableButton("btnPolicyItem");
							exec = true;
							packPolId = "";
							disableToolbarButton("btnToolbarExecuteQuery");
						}
					}
				},
				onCancel: function(){
					$("txtPolLineCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showPackageLOV",e);
		}
	}
	
	// added by gab 08.07.2015
	function showPackageAssdLOV(){
		try{
			LOV.show({
				controller : "UWPolicyInquiryLOVController",
				urlParameters : {
					action   : "showPackageAssdLOV",
					moduleId : "GIPIS100A",
					assdNo : $F('txtAssuredNo'),
					assdName : escapeHTML2($F('txtAssuredName')),
					packPolId : packPolId
				},
				title: "List of Package Policy Number",
				id: "packageList",
				width: 925,	
				height: 390,
				columnModel: [
		 			{
						id : 'assdNo',
						title: 'Assured Number',
						align: 'right',
						titleAlign : 'center',
						width : '80px'
						
					},
					{
						id : 'assdName',
						title: 'Assured Name',
						align: 'right',
						titleAlign : 'center',
						width : '250px'
					},
					{	
						id : 'policyNo',
						title: 'Policy Number',
						align: 'right',
						titleAlign : 'center',
						width : '120px'
					},
					{
						id : 'endtNo',
						title: 'Endorsement Number',
						align: 'right',
						titleAlign : 'center',
						width : '150px'
					},
					{
						id : 'issueDate',
						title: 'Issue Date',
						align: 'right',
						titleAlign : 'center',
						width : '100px'
					},
					{	
						id : 'effDate',
						title: 'Effectivity Date',
						align: 'right',
						titleAlign : 'center',
						width : '100px'
					},
					{	
						id : 'expiryDate',
						title: 'Expiry Date',
						align: 'right',
						titleAlign : 'center',
						width : '100px'
					}
				],
				autoSelectOneRecord: true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtPolLineCd").value = unescapeHTML2(row.lineCd);
						$("txtPolSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtPolIssCd").value = unescapeHTML2(row.issCd);
						$("txtPolIssueYy").value = formatNumberDigits(row.issueYy,2);
						$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo,7);
						$("txtPolRenewNo").value = formatNumberDigits(row.renewNo,2);
						$("txtPolRefNo").value = unescapeHTML2(row.refPolNo);
						$("txtParLine").value = unescapeHTML2(row.parLineCd);
						$("txtParIssCd").value = unescapeHTML2(row.parIssCd);
						$("txtParYy").value = formatNumberDigits(row.parYy,2);
						$("txtParSeqNo").value = formatNumberDigits(row.parSeqNo,7);
						$("txtParQuoteSeqNo").value = formatNumberDigits(row.quoteSeqNo,2);
						$("txtEndtIssCd").value = unescapeHTML2(row.endtIssCd);
						$("txtEndtYy").value = row.endtYy,2;
						$("txtEndtSeqNo").value = formatNumberDigits(row.endtSeqNo,7);
						$("txtAssuredNo").value = row.assdNo;
						$("txtAssuredName").value = unescapeHTML2(row.assdName);
						$("txtStatFlag").value = unescapeHTML2(row.polFlag);
						$("txtStatus").value = unescapeHTML2(row.polStatus);
						objParams.packPolId = unescapeHTML2(row.packPolicyId);
						objParams.packParId = unescapeHTML2(row.packParId);
						$("txtIssueDate").value = dateFormat(unescapeHTML2(row.issueDate), "mm-dd-yyyy");
						$("txtToDate").value = dateFormat(unescapeHTML2(row.expiryDate), "mm-dd-yyyy");
						$("txtTermDate").value = dateFormat(unescapeHTML2(row.inceptDate), "mm-dd-yyyy");
						
						$$("input[type='text']").each(function(x) {
							$(x).readOnly = true;
						});
						disableSearch("searchPackage");
						disableSearch("searchAssdPackage");	
						disableToolbar(false);
						if(packPolId!=""){
							tableGrid= JSON.parse('${jsonpackagePolicyTable}');
							enableButton("btnPolicyItem");
							exec = true;
							packPolId = ""; 
							disableToolbarButton("btnToolbarExecuteQuery");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("showPackageAssdLOV",e);
		}
	}
</script>