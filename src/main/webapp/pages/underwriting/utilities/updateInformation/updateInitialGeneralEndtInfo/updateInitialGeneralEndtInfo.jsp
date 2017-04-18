<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="updateInitialGeneralEndtInfoMainDiv" name="updateInitialGeneralEndtInfoMainDiv">
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
						<input class="polNoReq allCaps required" type="text" id="txtPolLineCd" name="txtPolLineCd" alt="Line Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="101" />
						<input class="allCaps" type="text" id="txtPolSublineCd" name="txtPolSublineCd" alt="Subline Code" style="width: 90px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="102" />
						<input class="allCaps" type="text" id="txtPolIssCd" name="txtPolIssCd" alt="Issue Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="103" />
						<input class="rightAligned" type="text" id="txtPolIssueYy" name="txtPolIssueYy" alt="Issue Year" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="104" />
						<input class="rightAligned" type="text" id="txtPolSeqNo" name="txtPolSeqNo" alt="Policy Sequence No." style="width: 85px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="105" />
						<input class="rightAligned" type="text" id="txtPolRenewNo" name="txtPolRenewNo" alt="Renew No." style="width: 40px; float: left;" maxlength="2" tabindex="106" />
						<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyNo" name="searchPolicyNo" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
						</span>
					</td>
					<td class="rightAligned" style="width:100px;">Endorsement No.</td>
					<td class="leftAligned" style="border: none; width:180px;">
						<input type="text" id="txtEndtIssCd" name="txtEndtIssCd" alt="Endorsement Issue Code" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="107" />
						<input class="rightAligned" type="text" id="txtEndtYy" name="txtEndtYy" alt="Endordement Year" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="108" />
						<input class="rightAligned" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" alt="Endorsement Sequence No." style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="6" tabindex="109" />
					</td>
				</tr>
			</table>
			<table style="width: 100%; float: left; margin-left: 25px;">
				<td class="rightAligned" style="width:36px;">PAR No.</td>
					<td class="leftAligned" style="border: none; width:420px;">
						<input type="text" id="txtParLineCd" name="txtParLineCd" alt="Line Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="110" />
						<input type="text" id="txtParIssCd" name="txtParIssCd" alt="Issue Code" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="111" />
						<input class="rightAligned" type="text" id="txtParYy" name="txtParYy" alt="PAR Year"  style="width: 90px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="112" />
						<input class="rightAligned" type="text" id="txtParSeqNo" name="txtParSeqNo" alt="PAR Sequence No."  style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="6" tabindex="113" />
						<input class="rightAligned" type="text" id="txtParQuoteSeqNo" name="txtParQuoteSeqNo" alt="Quote Sequence No."  style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="114" />
						<!-- SR-21812 JET OCT-20-2016 -->
						<div style="float: right; margin-right: 60px;">
							<label name="lblPackPol" id="lblPackPol" style="opacity: 0; color: red; margin-top: 7px"><b>Package Policy:&nbsp;</b></label>
							<label name="lblPackPolNo" id="lblPackPolNo" style="opacity: 0; color: red; font-weight: bold; margin-top: 7px"></label>
						</div>
					</td>
			</table>
			<table style="width: 100%; float: left; margin-left: 25px; margin-bottom: 20px;">
				<tr>
					<td class="rightAligned" style="width:67px;">Assured</td>
					<td class="leftAligned" style="width: 770px;">
						<input type="text" id="txtAssured" name="txtAssured" style="width: 770px; float: left; margin: 2px 4px 0 0" maxlength="500" tabindex="115" />
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
	//initialization
	function initializeGIPIS161(){
		setModuleId("GIPIS161");
		setDocumentTitle("Update Initial,General,Endt Info");
		initializeAll();
		initializeTabs();
		initializeAccordion();
		policyId = null;
		packPolicyId = null;
		policyNo = null;
		packNo = null;
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
		$("txtPolLineCd").focus();
		
		/* SR-21812 JET OCT-20-2016 */
		disableInputField("txtGeneralInfo");
		disableInputField("txtInitialInfo");
		disableInputField("txtEndtInfo");
		disableButton("btnSaveUpdate"); 
	
	}initializeGIPIS161();
	
	function validateLineCd(lineCd){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: 	"validateCopyLineCd",
					lineCd:		$F("txtPolLineCd"),
					issCd:		$F("txtPolIssCd"),
					moduleId:   "GIPIS161"	//added by Gzelle 01052015
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating Line Code, please wait..."),
				onComplete: function(response){
					hideNotice("");		
					if(checkErrorOnResponse(response)){
						if(nvl(response.responseText, "SUCCESS") != "SUCCESS"){
							showMessageBox(response.responseText, "I");
							fireEvent($("btnToolbarEnterQuery"), "click");
						}
					}else{
						showMessageBox(response.responseText, "E");
						fireEvent($("btnToolbarEnterQuery"), "click");
					}
				}
			});
		}catch(e){
			showErrorMessage("validateLineCd",e);
		}		
	}
	
	function checkUserPerIssCd(){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: "checkUserPerIssCd",
					lineCd : $F("txtPolLineCd"),
					issCd: $F("txtPolIssCd"),
					moduleId: "GIPIS161"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating Issue Code, please wait..."),
				onComplete: function(response){
				hideNotice("");		
					if(response.responseText != "1"){
						showMessageBox( "You are not authorized to use this issue source.", "I");
						$("txtPolIssCd").value = "";
						$("txtPolIssCd").focus();
					}
				}
			});
		}catch(e){
			showErrorMessage("checkUserPerIssCd",e);
		}	
	}
	
	function showPolicyInfoLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getUpdateInitEtcPolicyLOV",
				polLineCd : $F("txtPolLineCd"),
				polSublineCd : $F("txtPolSublineCd"),
				polIssCd : $F("txtPolIssCd"),
				polIssueYy : $F("txtPolIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				polRenewNo : $F("txtPolRenewNo"),
				parLineCd : $F("txtParLineCd"),
				parIssCd : $F("txtParIssCd"),
				parYy : $F("txtParYy"),
				parSeqNo : $F("txtParSeqNo"),
				parQuoteSeqNo : $F("txtParQuoteSeqNo"),
				endtIssCd : $F("txtEndtIssCd"),
				endtYy : $F("txtEndtYy"),
				endtSeqNo : $F("txtEndtSeqNo"),
				assdName : $F("txtAssured")
			},
			title : "Policy Listing",
			width : 880,
			height : 386,
			columnModel : [
           		{
					id : "policyNo",
					title : "Policy No.",
					width : 180,
					filterOption : true
				},
				{
					id : 'endtNo',
					title : 'Endt No.',
					width : 105,
					filterOption : true
				},
				{
					id : 'parNo',
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
				populatePolicyFields(row);
				executeQueryMode(On); // added by j.diago 07.07.2014
				
				/* SR-21812 JET OCT-20-2016 */
				enableInputField("txtGeneralInfo");
				enableInputField("txtInitialInfo");
				enableInputField("txtEndtInfo");
				enableButton("btnSaveUpdate");
			},
			onCancel : function () {
				$("txtPolLineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtPolLineCd");
				$("txtPolLineCd").focus();
			}
		});
	}
	
	function populatePolicyFields(row) {
		$("txtPolLineCd").value 	= row.polLineCd;
		$("txtPolSublineCd").value 	= unescapeHTML2(row.polSublineCd); //benjo 09.08.2015 GENQA-SR-4896 added unescapeHTML2
		$("txtPolIssCd").value 		= row.polIssCd;
		$("txtPolIssueYy").value 	= formatNumberDigits(row.polIssueYy, 2);
		$("txtPolSeqNo").value 		= formatNumberDigits(row.polSeqNo, 7);
		$("txtPolRenewNo").value 	= formatNumberDigits(row.polRenewNo, 2);
		$("txtParLineCd").value 	= row.parLineCd;
		$("txtParIssCd").value 		= row.parIssCd;
		$("txtParYy").value 		= formatNumberDigits(row.parYy,2);
		$("txtParSeqNo").value 		= formatNumberDigits(row.parSeqNo,6);
		$("txtParQuoteSeqNo").value = formatNumberDigits(row.parQuoteSeqNo,2);
		if (row.endtSeqNo != null) {
			$("txtEndtIssCd").value 	= row.endtIssCd;
			$("txtEndtYy").value 		= formatNumberDigits(row.endtYy, 2);
			$("txtEndtSeqNo").value 	= formatNumberDigits(row.endtSeqNo, 6);
		}
		$("txtAssured").value 		= unescapeHTML2(row.assdName);
		policyId 					= row.policyId;
		packPolFlag					= row.packPolFlag;
		packPolicyId				= row.packPolicyId;
		policyNo					= row.policyNo;
		packNo						= row.packNo;
		enableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarExecuteQuery");
		// SR-21812 JET MAY-03-2016
		if (row.packNo) {
			var packPolNo = row.packNo;
			
			if (row.endtSeqNo) {
				packPolNo = packPolNo + "/" + row.endtIssCd + "-" + formatNumberDigits(row.endtYy, 2) + "-" + formatNumberDigits(row.endtSeqNo, 6);
			}
			
			$("lblPackPolNo").innerHTML	= packPolNo;
			$("lblPackPol").setStyle('opacity: 100;');
			$("lblPackPolNo").setStyle('opacity: 100;');
		}
	}
	
	generalInitialInfo = new Array();
	generalInitialPackInfo = new Array();
	endtInfo = new Array();
	
	function getGeneralInitialEndtInfo(tab) {
		if (tab == "genInfoTab" || tab == "initialInfoTab") {
			if (packPolFlag != "Y") {
				new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
					method: "POST",
					parameters:{
						action: "getGeneralInitialInfo",
						policyId : policyId
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							generalInitialInfo = JSON.parse(response.responseText);
							if (tab == "genInfoTab") {
								executeQueryOn(generalInitialInfo, 'genInfo', "txtGeneralInfo", "txtGenUserId", "txtGenLastUpdate");
							}else if (tab == "initialInfoTab") {
								executeQueryOn(generalInitialInfo, 'initialInfo', "txtInitialInfo", "txtInitUserId", "txtInitLastUpdate");
							}
						}
					}
				});
			}else {
				new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
					method: "POST",
					parameters:{
						action: "getGeneralInitialPackInfo",
						policyId : policyId
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
			}
		}else if (tab == "endtInfoTab") {
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action: "getEndtInfo",
					policyId : policyId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						endtInfo = JSON.parse(response.responseText);
						if ($("txtEndtSeqNo").value == "" && executeQuery == On) {
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
	
	function setGenInfo() {
		var row = new Object();
		var genInfo = $("txtGeneralInfo").value;
		row.policyId	= policyId;
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

	function setInitialInfo() {
		var row = new Object();
		var initialInfo = $("txtInitialInfo").value;
		row.policyId		= policyId;
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

	function setGenPackInfo() {
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
	
	function setInitialPackInfo() {
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
	
	function setEndtText() {
		var row = new Object();
		var endtText = $("txtEndtInfo").value;
		row.policyId	= policyId;
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
	
	// SR-21812 JET AUG-09-2016
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
	
	function saveGeneralInfo() {
		var objUpdate = new Object();
		var temp = new Array();
		if (packPolFlag != "Y") {
			temp.push(setGenInfo());
			objUpdate.setRows = temp;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveGenInfo",
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
		}else if (packPolFlag == "Y") {
			// SR-21812 JET JUN-30-2016
			temp.push(setGenInfo());
			objUpdate.setRows = temp;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveGenInfo",
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
			
			temp.push(setGenPackInfo());
			objUpdate.setRows = temp;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveGenPackInfo",
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
		
	}

	function saveInitialInfo() {
		var objUpdate = new Object();
		var temp = new Array();
		
		if (packPolFlag != "Y") {
			temp.push(setInitialInfo());
			objUpdate.setRows = temp;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveInitialInfo",
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
		}else if (packPolFlag == "Y") {
			// SR-21812 JET JUN-30-2016
			temp.push(setInitialInfo());
			objUpdate.setRows = temp;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveInitialInfo",
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
			
			temp.push(setInitialPackInfo());
			objUpdate.setRows = temp;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveInitialPackInfo",
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
	}
	
	function saveEndtText() {
		var objUpdate = new Object();
		var temp = new Array();
		
		// SR-21812 JET AUG-09-2016
		if (packPolFlag != "Y") {
			temp.push(setEndtText());
			objUpdate.setRows = temp;
				
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveEndtInfo",
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
		} else if (packPolFlag == "Y") {
			temp.push(setEndtText());
			objUpdate.setRows = temp;
				
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters:{
					action : "saveEndtInfo",
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
	}
	
 	function validatePackage(){
		new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
			method: "POST",
			parameters:{
				action :   "validatePackage",
				packPolicyId : packPolicyId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Validating Package Policy, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == 'Y') {
						showConfirmBox("Confirmation","This will override the existing initial/gen info for " + packNo + ". Continue?",
									"Yes", "No", function() {
										$$("div.tabComponents1 a").each(function(a){
											if (a.up("li").hasClassName("selectedTab1")){
												if (a.id == "genInfoTab") {
													saveGeneralInfo();
												}else if (a.id == "initialInfoTab") {
													saveInitialInfo();
												}else if (a.id == "endtInfoTab") {
													saveEndtText();
												}
											}
										});	
									}, function() {
										$$("div.tabComponents1 a").each(function(a){
											if (a.up("li").hasClassName("selectedTab1")){
												getGeneralInitialEndtInfo(a.id);
											}
										});	
									},
						"");
					} else {
						showConfirmBox("Confirmation","This info will be attached to the package  " + packNo + ". Continue?",
									"Yes", "No", function() {
										$$("div.tabComponents1 a").each(function(a){
											if (a.up("li").hasClassName("selectedTab1")){
												if (a.id == "genInfoTab") {
													saveGeneralInfo();
												}else if (a.id == "initialInfoTab") {
													saveInitialInfo();
												}else if (a.id == "endtInfoTab") {
													saveEndtText();
												}
											}
										});	
									}, function() {
										$$("div.tabComponents1 a").each(function(a){
											if (a.up("li").hasClassName("selectedTab1")){
												getGeneralInitialEndtInfo(a.id);
											}
										});	
									},
						"");
					} 
				}
			}
		});
	} 
	
	function saveGenInitEndtInfo() {
		if (packPolFlag == "Y") {
			validatePackage();
		}else {
			$$("div.tabComponents1 a").each(function(a){
				if (a.up("li").hasClassName("selectedTab1")){
					if (a.id == "genInfoTab") {
						saveGeneralInfo();
					}else if (a.id == "initialInfoTab") {
						saveInitialInfo();
					}else if (a.id == "endtInfoTab") {
						saveEndtText();
					}
				}
			});	
		}
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
			// SR-21812 JET JUN-02-2016
			$("lblPackPol").setStyle('opacity: 0;');
			$("lblPackPolNo").setStyle('opacity: 0;');
			
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
					if (a.id == "endtInfoTab" && $("txtEndtSeqNo").value == "") {
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
	
	function cancelGipis161() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				exitPage = exitPageFunc;
				saveGenInitEndtInfo();
			}, function() {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}

	$("searchPolicyNo").observe("click", function() {
		if($F("txtPolLineCd") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtPolLineCd");
		}else{
			showPolicyInfoLOV();	
		}
	});
	
	//$("txtPolLineCd").observe("change", function () {
	//	validateLineCd($F("txtPolLineCd"));
	//});
	
	//$("txtPolIssCd").observe("change", function () {
	//	checkUserPerIssCd();
	//});
	
	$("txtPolIssueYy").observe("change", function() {
		checkNumberFields("txtPolIssueYy", "Issue Year");
	});
	
	$("txtPolSeqNo").observe("change", function() {
		checkNumberFields("txtPolSeqNo", "Policy Sequence No.");
	});
	
	$("txtPolRenewNo").observe("change", function() {
		checkNumberFields("txtPolRenewNo", "Renew No.");
	});
	
	$("txtParYy").observe("change", function() {
		checkNumberFields("txtParYy", "PAR Year");
	});
	
	$("txtParSeqNo").observe("change", function() {
		checkNumberFields("txtParSeqNo", "PAR Sequence No.");
	});
	
	$("txtParQuoteSeqNo").observe("change", function() {
		checkNumberFields("txtParQuoteSeqNo", "Quote Sequence No.");
	});
	
	$("txtEndtYy").observe("change", function() {
		checkNumberFields("txtEndtYy", "Endorsement Year");
	});
	
	$("txtEndtSeqNo").observe("change", function() {
		checkNumberFields("txtEndtSeqNo", "Endorsement Sequence No.");
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
						saveGenInitEndtInfo();
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
			saveGenInitEndtInfo();
		}
	});
	
	$("btnCancelUpdate").observe("click", cancelGipis161);
	
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
		if ($("txtEndtSeqNo").value == "" && executeQuery == On) {
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
	
	changeTagFunc = saveGenInitEndtInfo;
	
	observeReloadForm("reloadForm", showUpdateInitialEtc);
	hideToolbarButton("btnToolbarExecuteQuery"); // added by j.diago 07.07.2014
</script>
