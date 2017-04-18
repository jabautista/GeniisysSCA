<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="updateInitialGeneralEndtInfoPackMainDiv" name="updateInitialGeneralEndtInfoPackMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label>Update Initial/General/Endorsement Information</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
	 			<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="mainInfoSectionDiv" class="sectionDiv" style="margin:0px auto 10px auto;">
		<div id="polMainInfoDiv" style="margin-bottom: 20px;">
			<table align="left" style="padding: 20px; padding-bottom:0px; width: 100%">
				<tr>
					<td class="rightAligned" style="width:70px;">Policy No.</td>
					<td class="leftAligned" style="border: none; width:420px;">
						<input class="polNoReq allCaps required" type="text" id="txtPackPolLineCd" name="txtPackPolLineCd" alt="Line Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="101" />
						<input class="allCaps" type="text" id="txtPackPolSublineCd" name="txtPackPolSublineCd" alt="Subline Code" style="width: 90px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="102" />
						<input class="allCaps" type="text" id="txtPackPolIssCd" name="txtPackPolIssCd" alt="Issue Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="103" />
						<input class="rightAligned" type="text" id="txtPackPolIssueYy" name="txtPackPolIssueYy" alt="Issue Year" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="104" />
						<input class="rightAligned" type="text" id="txtPackPolSeqNo" name="txtPackPolSeqNo" alt="Policy Sequence No." style="width: 85px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="105" />
						<input class="rightAligned" type="text" id="txtPackPolRenewNo" name="txtPackPolRenewNo" alt="Renew No." style="width: 40px; float: left;" maxlength="2" tabindex="106" />
						<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyNo" name="searchPolicyNo" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
						</span>
					</td>
					<td class="rightAligned" style="width:100px;">Endorsement No.</td>
					<td class="leftAligned" style="border: none; width:180px;">
						<input type="text" id="txtPackEndtIssCd" name="txtPackEndtIssCd" alt="Endorsement Issue Code" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="107" />
						<input class="rightAligned" type="text" id="txtPackEndtYy" name="txtPackEndtYy" alt="Endordement Year" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="108" />
						<input class="rightAligned" type="text" id="txtPackEndtSeqNo" name="txtPackEndtSeqNo" alt="Endorsement Sequence No." style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="6" tabindex="109" />
					</td>
				</tr>
			</table>
			<table style="width: 100%; float: left; margin-left: 25px;">
				<td class="rightAligned" style="width:36px;">PAR No.</td>
					<td class="leftAligned" style="border: none; width:420px;">
						<input type="text" id="txtPackParLineCd" name="txtPackParLineCd" alt="Line Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="110" />
						<input type="text" id="txtPackParIssCd" name="txtPackParIssCd" alt="Issue Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="111" />
						<input class="rightAligned" type="text" id="txtPackParYy" name="txtPackParYy" alt="PAR Year"  style="width: 90px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="112" />
						<input class="rightAligned" type="text" id="txtPackParSeqNo" name="txtPackParSeqNo" alt="PAR Sequence No."  style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="6" tabindex="113" />
						<input class="rightAligned" type="text" id="txtPackParQuoteSeqNo" name="txtPackParQuoteSeqNo" alt="Quote Sequence No."  style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="114" />
					</td>
			</table>
			<table style="width: 100%; float: left; margin-left: 25px; margin-bottom: 20px;">
				<tr>
					<td class="rightAligned" style="width:67px;">Assured</td>
					<td class="leftAligned" style="width: 770px;">
						<input type="text" id="txtAssdName" name="txtAssdName" style="width: 770px; float: left; margin: 2px 4px 0 0" maxlength="500" tabindex="115" />
					</td>
				</tr>
			</table>
		</div>
		
		<div id="tabComponentsDiv2" class="tabComponents1" style="align:center;width:100%">
			<ul>
				<li class="tab1 selectedTab1" style="width:25%"><a id="genInfoTab">General Information</a></li>
				<li class="tab1" style="width:25%"><a id="initialInfoTab">Initial Information</a></li>
				<li class="tab1" style="width:25%"><a id="endtInfoTab">Endorsement Information</a></li>		
			</ul>			
		</div>
		<div class="tabBorderBottom1"></div>
		<div id="tabPageContents" name="tabPageContents" style="width: 100%; float: left;">	
			<div id="tabGeneralInfoContents" name="tabGeneralInfoContents" style="width: 100%; float: left;">
				<table align="center" style="padding-left: 20px; padding-right: 20px; padding-top: 20px;">
					<tr>
						<td colspan="3">
							<textarea class="text" id="txtGeneralInfo" name="txtGeneralInfo" maxlength="32767" style="height: 300px; width: 730px; resize: none;"></textarea>
						</td>
					</tr>
				</table>
				<table style="margin-bottom: 20px;">
					<tr align="center">
						<td class="rightAligned" style="width:80px;">User ID</td>
						<td class="leftAligned" style="width: 58.5%">
							<input type="text" id="txtGenUserId" name="txtGenUserId" class="text" readonly="readonly" style="width: 180px;"/>
						</td>
						<td class="rightAligned" >Last Update 
							<input type="text" id="txtGenLastUpdate" name="txtGenLastUpdate" class="text" style="width: 180px;" readonly="readonly" />
						</td>
					</tr>
				</table>
			</div>
			<div id="tabInitialInfoContents" name="tabInitialInfoContents" style="width: 100%; float: left;">
				<table align="center" style="padding-left: 20px; padding-right: 20px; padding-top: 20px;">
					<tr>
						<td colspan="3">
							<textarea class="text" id="txtInitialInfo" name="txtInitialInfo" maxlength="32767" style="height: 300px; width: 730px; resize: none;"></textarea>
						</td>
					</tr>
				</table>
				<table style="margin-bottom: 20px;">
					<tr align="center">
						<td class="rightAligned" style="width:80px;">User ID</td>
						<td class="leftAligned" style="width: 58.5%">
							<input type="text" id="txtInitUserId" name="txtInitUserId" class="text" readonly="readonly" style="width: 180px;"/>
						</td>
						<td class="rightAligned" >Last Update 
							<input type="text" id="txtInitLastUpdate" name="txtInitLastUpdate" class="text" style="width: 180px;" readonly="readonly" />
						</td>
					</tr>
				</table>
			</div>
			<div id="tabEndtInfoContents" name="tabEndtInfoContents" style="width: 100%; float: left;">
				<table align="center" style="padding-left: 20px; padding-right: 20px; padding-top: 20px;">
					<tr>
						<td colspan="3">
							<textarea class="text" id="txtEndtInfo" name="txtEndtInfo" maxlength="32767" style="height: 300px; width: 730px; resize: none;"></textarea>
						</td>
					</tr>
				</table>
				<table style="margin-bottom: 20px;">
					<tr align="center">
						<td class="rightAligned" style="width:80px;">User ID</td>
						<td class="leftAligned" style="width: 58.5%">
							<input type="text" id="txtEndtUserId" name="txtEndtUserId" class="text" readonly="readonly" style="width: 180px;"/>
						</td>
						<td class="rightAligned" >Last Update 
							<input type="text" id="txtEndtLastUpdate" name="txtEndtLastUpdate" class="text" style="width: 180px;" readonly="readonly" />
						</td>
					</tr>
				</table>			
			</div>
		</div>
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnCancelUpdate" name="btnCancelUpdate" value="Cancel"/>
		<input type="button" class="button" id="btnSaveUpdate" name="btnSaveUpdate" value="Save"/>
	</div>
</div>

<script>
	function initializeGIPIS161A(){
		setModuleId("GIPIS161A");
		setDocumentTitle("Update Initial,General,Endt Info");
		initializeAll();
		initializeTabs();
		initializeAccordion();
		packPolicyId = null;
		packPolicyNo = null;
		On = "ON";
		Off = "OFF";
		executeQuery = Off;
		changeTag = 0;
		exitPage = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		hideToolbarButton("btnToolbarPrint");
		$("tabGeneralInfoContents").show();
		$("tabInitialInfoContents").hide();
		$("tabEndtInfoContents").hide();
		$("txtPackPolLineCd").focus();
		
		/* SR-21812 JET OCT-20-2016 */
		disableInputField("txtGeneralInfo");
		disableInputField("txtInitialInfo");
		disableInputField("txtEndtInfo");
		disableButton("btnSaveUpdate");
	}initializeGIPIS161A();

	function showPackPolicyInfoLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getUpdateInitEtcPackPolicyLOV",
				packPolLineCd : $F("txtPackPolLineCd"),
				packPolSublineCd : $F("txtPackPolSublineCd"),
				packPolIssCd : $F("txtPackPolIssCd"),
				packPolIssueYy : $F("txtPackPolIssueYy"),
				packPolSeqNo : $F("txtPackPolSeqNo"),
				packPolRenewNo : $F("txtPackPolRenewNo"),
				packParLineCd : $F("txtPackParLineCd"),
				packParIssCd : $F("txtPackParIssCd"),
				packParYy : $F("txtPackParYy"),
				packParSeqNo : $F("txtPackParSeqNo"),
				packParQuoteSeqNo : $F("txtPackParQuoteSeqNo"),
				packEndtIssCd : $F("txtPackEndtIssCd"),
				packEndtYy : $F("txtPackEndtYy"),
				packEndtSeqNo : $F("txtPackEndtSeqNo"),
				assdName : $F("txtAssdName")
			},
			title : "Policy Listing",
			width : 880,
			height : 386,
			columnModel : [
           		{
					id : 'packPolicyNo',
					title : 'Policy No.',
					width : 180,
					filterOption : true
				},
				{
					id : 'packEndtNo',
					title : 'Endt No.',
					width : 105,
					filterOption : true
				},
				{
					id : 'packParNo',
					title : 'PAR No.',
					width : 150,
					filterOption : true
				},
				{
					id : 'assdName',
					title : 'Assured Name',
					width : 423,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				}
      		],
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				populatePackPolicyFields(row);
				executeQueryMode(On);
				
				/* SR-21812 JET OCT-20-2016 */
				enableInputField("txtGeneralInfo");
				enableInputField("txtInitialInfo");
				enableInputField("txtEndtInfo");
				enableButton("btnSaveUpdate");
			},
			onCancel : function () {
				$("txtPackPolLineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtPackPolLineCd");
				$("txtPackPolLineCd").focus();
			}
		});
	}

	function populatePackPolicyFields(row) {
		$("txtPackPolLineCd").value 	= row.packPolLineCd;
		$("txtPackPolSublineCd").value 	= unescapeHTML2(row.packPolSublineCd);
		$("txtPackPolIssCd").value 		= row.packPolIssCd;
		$("txtPackPolIssueYy").value 	= formatNumberDigits(row.packPolIssueYy, 2);
		$("txtPackPolSeqNo").value 		= formatNumberDigits(row.packPolSeqNo, 7);
		$("txtPackPolRenewNo").value 	= formatNumberDigits(row.packPolRenewNo, 2);
		$("txtPackParLineCd").value 	= row.packParLineCd;
		$("txtPackParIssCd").value 		= row.packParIssCd;
		$("txtPackParYy").value 		= formatNumberDigits(row.packParYy,2);
		$("txtPackParSeqNo").value 		= formatNumberDigits(row.packParSeqNo,6);
		$("txtPackParQuoteSeqNo").value = formatNumberDigits(row.packParQuoteSeqNo,2);
		if (row.packEndtSeqNo != null) {
			$("txtPackEndtIssCd").value 	= row.packEndtIssCd;
			$("txtPackEndtYy").value 		= formatNumberDigits(row.packEndtYy, 2);
			$("txtPackEndtSeqNo").value 	= formatNumberDigits(row.packEndtSeqNo, 6);
		}
		$("txtAssdName").value 		= unescapeHTML2(row.assdName);
		packPolicyId				= row.packPolicyId
		packPolicyNo				= row.packPolicyNo;
		enableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarExecuteQuery");
	}

	generalInitialPackInfo = new Array();
	endtInfo = new Array();
	
	function getGeneralInitialEndtInfo(tab) {
		if (tab == "genInfoTab" || tab == "initialInfoTab") {
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action: "getPackGeneralInitialInfo",
					packPolicyId : packPolicyId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						generalInitialPackInfo = JSON.parse(response.responseText);
						if (tab == "genInfoTab") {
							executeQueryOn(generalInitialPackInfo, 'genInfo', "txtGeneralInfo", "txtGenUserId", "txtGenLastUpdate");
						}else if (tab == "initialInfoTab") {
							executeQueryOn(generalInitialPackInfo, 'initialInfo', "txtInitialInfo", "txtInitUserId", "txtInitLastUpdate");
						}
					}
				}
			});
		} else if (tab == "endtInfoTab") {
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action: "getPackEndtInfo",
					packPolicyId : packPolicyId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						endtInfo = JSON.parse(response.responseText);
						if ($("txtPackEndtSeqNo").value == "" && executeQuery == On) {
							showMessageBox("This is not an endorsement.", "I");	
							fireEvent($("genInfoTab"), "click");
						}else {
							executeQueryOn(endtInfo, 'endtText', "txtEndtInfo", "txtEndtUserId", "txtEndtLastUpdate");
						}
					}
				}
			});
		}
	}

	function executeQueryOn(array, info, txtInfo, txtUser, txtLastUpdate) {
		if (array.list.length != 0) {
			$(txtInfo).value = unescapeHTML2(array.list[0][info]);
			$(txtUser).value = array.list[0]['userId'];
			$(txtLastUpdate).value = array.list[0]['lastUpdate'];
		}else {
			$(txtUser).value = '${userId}';
			$(txtLastUpdate).value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
		}disableToolbarButton("btnToolbarExecuteQuery");
	}

	function setPackGenInfo() {
		var row = new Object();
		var genInfo = $("txtGeneralInfo").value;
		row.packPolicyId	= packPolicyId;
		row.genInfo 	= escapeHTML2(genInfo);
		row.genInfo01 	= escapeHTML2(genInfo.substring(0,2000));
		row.genInfo02 	= escapeHTML2(genInfo.substring(2000,4000));
		row.genInfo03 	= escapeHTML2(genInfo.substring(4000,6000));
		row.genInfo04 	= escapeHTML2(genInfo.substring(6000,8000));
		row.genInfo05 	= escapeHTML2(genInfo.substring(8000,10000));
		row.genInfo06 	= escapeHTML2(genInfo.substring(10000,12000));
		row.genInfo07 	= escapeHTML2(genInfo.substring(12000,14000));
		row.genInfo08 	= escapeHTML2(genInfo.substring(14000,16000));
		row.genInfo09 	= escapeHTML2(genInfo.substring(16000,18000));
		row.genInfo10 	= escapeHTML2(genInfo.substring(18000,20000));
		row.genInfo11 	= escapeHTML2(genInfo.substring(20000,22000));
		row.genInfo12 	= escapeHTML2(genInfo.substring(22000,24000));
		row.genInfo13 	= escapeHTML2(genInfo.substring(24000,26000));
		row.genInfo14 	= escapeHTML2(genInfo.substring(26000,28000));
		row.genInfo15 	= escapeHTML2(genInfo.substring(28000,30000));
		row.genInfo16 	= escapeHTML2(genInfo.substring(30000,32000));
		row.genInfo17 	= escapeHTML2(genInfo.substring(32000,32767));
		row.userId 		= '${userId}';
		row.lastUpdate 	= dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
		return row;
	}
	
	function setPackInitInfo() {
		var row = new Object();
		var initialInfo 	= $("txtInitialInfo").value;
		row.packPolicyId	= packPolicyId;
		row.initialInfo 	= escapeHTML2(initialInfo);
		row.initialInfo01 	= escapeHTML2(initialInfo.substring(0,2000));
		row.initialInfo02 	= escapeHTML2(initialInfo.substring(2000,4000));
		row.initialInfo03 	= escapeHTML2(initialInfo.substring(4000,6000));
		row.initialInfo04 	= escapeHTML2(initialInfo.substring(6000,8000));
		row.initialInfo05 	= escapeHTML2(initialInfo.substring(8000,10000));
		row.initialInfo06 	= escapeHTML2(initialInfo.substring(10000,12000));
		row.initialInfo07 	= escapeHTML2(initialInfo.substring(12000,14000));
		row.initialInfo08 	= escapeHTML2(initialInfo.substring(14000,16000));
		row.initialInfo09 	= escapeHTML2(initialInfo.substring(16000,18000));
		row.initialInfo10 	= escapeHTML2(initialInfo.substring(18000,20000));
		row.initialInfo11 	= escapeHTML2(initialInfo.substring(20000,22000));
		row.initialInfo12 	= escapeHTML2(initialInfo.substring(22000,24000));
		row.initialInfo13 	= escapeHTML2(initialInfo.substring(24000,26000));
		row.initialInfo14 	= escapeHTML2(initialInfo.substring(26000,28000));
		row.initialInfo15 	= escapeHTML2(initialInfo.substring(28000,30000));
		row.initialInfo16 	= escapeHTML2(initialInfo.substring(30000,32000));
		row.initialInfo17 	= escapeHTML2(initialInfo.substring(32000,32767));
		row.userId 		= '${userId}';
		row.lastUpdate 	= dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
		return row;
	}
	
	function setPackEndtText() {
		var row = new Object();
		var endtText = $("txtEndtInfo").value;
		row.packPolicyId = packPolicyId;
		row.endtText 	= escapeHTML2(endtText);
		row.endtText01 	= escapeHTML2(endtText.substring(0,2000));
		row.endtText02 	= escapeHTML2(endtText.substring(2000,4000));
		row.endtText03 	= escapeHTML2(endtText.substring(4000,6000));
		row.endtText04 	= escapeHTML2(endtText.substring(6000,8000));
		row.endtText05 	= escapeHTML2(endtText.substring(8000,10000));
		row.endtText06 	= escapeHTML2(endtText.substring(10000,12000));
		row.endtText07 	= escapeHTML2(endtText.substring(12000,14000));
		row.endtText08 	= escapeHTML2(endtText.substring(14000,16000));
		row.endtText09 	= escapeHTML2(endtText.substring(16000,18000));
		row.endtText10 	= escapeHTML2(endtText.substring(18000,20000));
		row.endtText11 	= escapeHTML2(endtText.substring(20000,22000));
		row.endtText12 	= escapeHTML2(endtText.substring(22000,24000));
		row.endtText13 	= escapeHTML2(endtText.substring(24000,26000));
		row.endtText14 	= escapeHTML2(endtText.substring(26000,28000));
		row.endtText15 	= escapeHTML2(endtText.substring(28000,30000));
		row.endtText16 	= escapeHTML2(endtText.substring(30000,32000));
		row.endtText17 	= escapeHTML2(endtText.substring(32000,32767));
		row.userId 		= '${userId}';
		row.lastUpdate 	= dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
		return row;
	}
	
	function savePackGenInfo() {
		var objUpdate = new Object();
		var temp = new Array();

		temp.push(setPackGenInfo());
		objUpdate.setRows = temp;
		
		new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
			method: "POST",
			parameters:{
				action : "savePackGenInfo",
				param : prepareJsonAsParameter(objUpdate)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Update General,Initial,Endt Info, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				temp = [];
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
							if (exitPage != null) {
								exitPage();
								exitPage = null;
							}
						});
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function savePackInitInfo() {
		var objUpdate = new Object();
		var temp = new Array();
		
		temp.push(setPackInitInfo());
		objUpdate.setRows = temp;
		
		new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
			method: "POST",
			parameters:{
				action : "savePackInitInfo",
				param : prepareJsonAsParameter(objUpdate)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Update General,Initial,Endt Info, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				temp = [];
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
							if (exitPage != null) {
								exitPage();
								exitPage = null;
							}
						});
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function savePackEndtText() {
		var objUpdate = new Object();
		var temp = new Array();
		
		temp.push(setPackEndtText());
		objUpdate.setRows = temp;
			
		new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
			method: "POST",
			parameters:{
				action : "savePackEndtText",
				param : prepareJsonAsParameter(objUpdate)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Update General,Initial,Endt Info, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				temp = [];
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
							if (exitPage != null) {
								exitPage();
								exitPage = null;
							}
						});
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	function savePackGenInitEndtInfo() {
		$$("div.tabComponents1 a").each(function(a){
			if (a.up("li").hasClassName("selectedTab1")){
				if (a.id == "genInfoTab") {
					savePackGenInfo();
				} else if (a.id == "initialInfoTab") {
					savePackInitInfo();
				} else if (a.id == "endtInfoTab") {
					savePackEndtText();
				}
			}
		});
	}

	function enterQueryMode(mode) {
		if (mode == On) {
			executeQuery = Off;
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableSearch("searchPolicyNo");
			$$("div#polMainInfoDiv input[type='text']").each(function(field) {
				$(field).value = "";
				enableInputField(field);
			});
			$$("div#tabPageContents input[type='text']").each(function(field) {
				$(field).value = "";
			});
			$$("div#tabPageContents textarea[class='text']").each(function(field) {
				$(field).value = "";
			});
			changeTag = 0;
			
			/* SR-21812 JET OCT-20-2016 */
			disableInputField("txtGeneralInfo");
			disableInputField("txtInitialInfo");
			disableInputField("txtEndtInfo");
			disableButton("btnSaveUpdate");
		}
	}

	function executeQueryMode(mode) {
		if (mode == On) {
			executeQuery = On;
			$$("div.tabComponents1 a").each(function(a){
				if (a.up("li").hasClassName("selectedTab1")){
					if (a.id == "endtInfoTab" && $("txtPackEndtSeqNo").value == "") {
						showMessageBox("This is not an endorsement.", "I");	
						fireEvent($("genInfoTab"), "click");
					}else {
						getGeneralInitialEndtInfo(a.id);
					}
				}
			});
			$$("div#polMainInfoDiv input[type='text']").each(function(field) {
				disableInputField(field);
			});
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("searchPolicyNo");
		}
	}
	
	function checkNumberFields(field, msg) {
		if ($(field).value != "") {
			if (isNaN($F(field))) {
				customShowMessageBox(msg + " must be a number.", imgMessage.INFO,field);
				$(field).clear();
			}
		}
	}
	
	function exitPageFunc() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}

	function cancelGipis161A() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				exitPage = exitPageFunc;
				savePackGenInitEndtInfo();
			}, function() {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("searchPolicyNo").observe("click", function() {
		if($F("txtPackPolLineCd") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtPackPolLineCd");
		}else{
			showPackPolicyInfoLOV();	
		}
	});
	
	//$("txtPackPolLineCd").observe("change", function () {
	//	validateLineCd($F("txtPackPolLineCd"));
	//});
	
	//$("txtPackPolIssCd").observe("change", function () {
	//	checkUserPerIssCd();
	//});
	
	$("txtPackPolIssueYy").observe("change", function() {
		checkNumberFields("txtPackPolIssueYy", "Issue Year");
	});
	
	$("txtPackPolSeqNo").observe("change", function() {
		checkNumberFields("txtPackPolSeqNo", "Policy Sequence No.");
	});
	
	$("txtPackPolRenewNo").observe("change", function() {
		checkNumberFields("txtPackPolRenewNo", "Renew No.");
	});
	
	$("txtPackParYy").observe("change", function() {
		checkNumberFields("txtPackParYy", "PAR Year");
	});
	
	$("txtPackParSeqNo").observe("change", function() {
		checkNumberFields("txtPackParSeqNo", "PAR Sequence No.");
	});
	
	$("txtPackParQuoteSeqNo").observe("change", function() {
		checkNumberFields("txtPackParQuoteSeqNo", "Quote Sequence No.");
	});
	
	$("txtPackEndtYy").observe("change", function() {
		checkNumberFields("txtPackEndtYy", "Endorsement Year");
	});
	
	$("txtPackEndtSeqNo").observe("change", function() {
		checkNumberFields("txtPackEndtSeqNo", "Endorsement Sequence No.");
	});
	
	$("txtGeneralInfo").observe("change", function() {
		changeTag = 1;
	});
	
	$("txtInitialInfo").observe("change", function() {
		changeTag = 1;
	});

	$("txtEndtInfo").observe("change", function() {
		changeTag = 1;
	});
	
	//buttons events
	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						exitPage = function() {
							enterQueryMode(On);
						};
						savePackGenInitEndtInfo();
						enterQueryMode(On);
					},
					function(){
						enterQueryMode(On);
					},
					""
				);
		}else {
			enterQueryMode(On);	
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		executeQueryMode(On);
	});
	
	$("btnSaveUpdate").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			savePackGenInitEndtInfo();
		}
	});
	$("btnCancelUpdate").observe("click", cancelGipis161A);
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancelUpdate"), "click");
	});
	
	//tab actions
	$("genInfoTab").observe("click", function () {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else {
			$("tabGeneralInfoContents").show();
			$("tabInitialInfoContents").hide();
			$("tabEndtInfoContents").hide();
			if (executeQuery == On) {
				getGeneralInitialEndtInfo("genInfoTab");
			}
		}
	});
	
	$("initialInfoTab").observe("click", function () {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else {
			$("tabGeneralInfoContents").hide();
			$("tabInitialInfoContents").show();
			$("tabEndtInfoContents").hide();
			if (executeQuery == On) {
				getGeneralInitialEndtInfo("initialInfoTab");
			}
		}
	});
	
	$("endtInfoTab").observe("click", function () {
		if ($("txtPackEndtSeqNo").value == "" && executeQuery == On) {
			showMessageBox("This is not an endorsement.", "I");	
			fireEvent($("genInfoTab"), "click");
		}else {
			if (changeTag == 1) {
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			}else {
				$("tabGeneralInfoContents").hide();
				$("tabInitialInfoContents").hide();
				$("tabEndtInfoContents").show();
				if (executeQuery == On) {
					getGeneralInitialEndtInfo("endtInfoTab");
				}
			}
		}
	});
	
	changeTagFunc = savePackGenInitEndtInfo;

	observeReloadForm("reloadForm", showUpdateInitialEtcPack);
	hideToolbarButton("btnToolbarExecuteQuery");
</script>
