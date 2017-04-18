<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="generateBankRefNoMainDiv" name="generateBankRefNoMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Generate Bank Reference Number</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="generateBankRefNoDiv" name="generateBankRefNoDiv" class="sectionDiv" style="margin-bottom: 15px;">
		<div style="margin: 25px 0 0 0;">
			<label style="font-size: 20px; width: 100%; text-align: center;">Generate Bank Reference Number</label>
		</div>
	
		<div style="height: 418px; width: 100%; float: left; margin: 25px 0 0 0;" align="center">
			<fieldset style="width: 700px;">
				<legend style="font-weight: bold;">Input Details</legend>
				<table align="center" style="margin: 7px 0 7px 13px;">
					<tr>
						<td class="rightAligned">Acct. Issue Code</td>
						<td>
							<span class="required lovSpan" style="width: 70px;">
								<input id="acctIssCd" name="acctIssCd" class="required upper integerNoNegativeUnformatted" type="text" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="2" tabindex="101" lastValidValue=""/>
								<img id="searchAcctIssCd" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td>
							<div style="padding-bottom: 2px;">
								<input id="issCd" type="text" readonly="readonly" style="height: 14px; width: 70px;" tabindex="102">
								<input id="issName" type="text" readonly="readonly" style="height: 14px; width: 360px;" tabindex="103">
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch Code</td>
						<td>
							<span class="required lovSpan" style="width: 70px;">
								<input id="branchCd" name="branchCd" class="required upper integerNoNegativeUnformatted" type="text" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="4" tabindex="104" lastValidValue=""/>
								<img id="searchBranchCd" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td>
							<div style="padding-bottom: 2px;">
								<input id="branchDesc" type="text" readonly="readonly" style="height: 14px; width: 216px;" tabindex="105">
								<input id="areaDesc" type="text" readonly="readonly" style="height: 14px; width: 214px;" tabindex="106">
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="rightAligned">
							# of reference numbers to be generated
							<input id="noOfRefNo" type="text" class="integerNoNegativeUnformatted" value="001" style="height: 14px; width: 66px;" maxlength="3" tabindex="107">
						</td>
					</tr>
				</table>
			</fieldset>
			
			<fieldset style="width: 700px; margin-top: 5px;">
				<legend style="font-weight: bold;">Output Generated</legend>
				<table align="center" style="margin: 7px 0 7px 0;">
					<tr>
						<td class="rightAligned">Reference Number</td>
						<td>
							<input id="refNo" type="text" readonly="readonly" style="height: 14px; width: 520px; text-align: right;" tabindex="201">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Modules 10 Number</td>
						<td>
							<input id="modNo" type="text" readonly="readonly" style="height: 14px; width: 520px; text-align: right;" tabindex="202">
						</td>
					</tr>
				</table>
			</fieldset>
			
			
			<fieldset style="height: 135px; width: 700px; margin-top: 10px;">
				<div align="left">
					<table style="margin: 10px 0 14px 47px;">
						<tr>
							<td class="rightAligned">Date Generated</td>
							<td>
								<div id="dateGeneratedDiv" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
						    		<input style="height: 13px; width: 104px; border: none; float: left;" id="dateGenerated" name="dateGenerated" type="text" readonly="readonly" tabindex="301"/>
						    		<img name="hrefDateGenerated" id="hrefDateGenerated" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Exact Date" onClick="scwShow($('dateGenerated'),this, null);"/>
								</div>
							</td>
							<td></td>
							<td></td>
							<td>
								<input id="exactDate" name="rangeRG" value="1" title="Exact Date" type="radio" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" tabindex="305">
								<label for="exactDate" style="margin: 2px 0 4px 0">Exact Date</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">As of Date</td>
							<td>
								<div id="asOfDateDiv" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
						    		<input id="asOfDate" name="asOfDate" style="height: 13px; width: 104px; border: none; float: left;" type="text" readonly="readonly" tabindex="302"/>
						    		<img name="hrefAsOfDate" id="hrefAsOfDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" onClick="scwShow($('asOfDate'),this, null);"/>
								</div>
							</td>
							<td></td>
							<td></td>
							<td>
								<input id="onOrBefore" name="rangeRG" value="2" title="On or Before" type="radio" style="margin: 2px 5px 4px 40px; float: left;" tabindex="305">
								<label for="onOrBefore" style="margin: 2px 0 4px 0">On or Before</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">From - To Date</td>
							<td>
								<div id="fromDateDiv" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
						    		<input id="fromDate" name="fromDate" style="height: 13px; width: 104px; border: none; float: left;" type="text" readonly="readonly" tabindex="303"/>
						    		<img name="hrefFromDate" id="hrefFromDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('fromDate'),this, null);"/>
								</div>
							</td>
							<td class="rightAligned">to</td>
							<td>
								<div id="toDateDiv" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
						    		<input id="toDate" name="toDate" style="height: 13px; width: 104px; border: none; float: left;" type="text" readonly="readonly" tabindex="304"/>
						    		<img name="hrefToDate" id="hrefToDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('toDate'),this, null);"/>
								</div>
							</td>
							<td>
								<input id="exactRange" name="rangeRG" value="3" title="Exact Range" type="radio" style="margin: 2px 5px 4px 40px; float: left;" tabindex="305">
								<label for="exactRange" style="margin: 2px 0 4px 0">Exact Range</label>
							</td>
						</tr>
					</table>
				</div>
				
				<input id="btnPrintCSV" type="button" class="button" value="Print to CSV File" style="width: 130px;" tabindex="306">
			</fieldset>
		</div>
		
		<div id="buttonsDiv" name="buttonsDiv" align="center" style="margin: 15px 0 15px 0;">
			<input id="btnGenerate" type="button" class="button" value="Generate" style="width: 110px;" tabindex="401">
			<input id="btnHistory" type="button" class="button" value="History" style="width: 110px;" tabindex="402">
		</div>
	</div>
	
</div>

<script type="text/javascript">
	function newFormInstance(){
		initializeAll();
		makeInputFieldUpperCase();
		toggleAsOf(false);
		toggleFromTo(false);
		populateDates();
		$("acctIssCd").focus();
		setModuleId("GIUTS035");
		setDocumentTitle("Bank Reference Number");
	}
	
	function populateDates(){
		var sysdate = dateFormat(new Date(), 'mm-dd-yyyy');
		$("dateGenerated").value = sysdate;
		$("asOfDate").value = sysdate;
		$("toDate").value = sysdate;
	}
	
	function clearIssFields(){
		$("acctIssCd").value = "";
		$("acctIssCd").setAttribute("lastValidValue", "");
		$("issCd").value = "";
		$("issName").value = "";
	}
	
	function clearBranchFields(){
		$("branchCd").value = "";
		$("branchCd").setAttribute("lastValidValue", "");
		$("branchDesc").value = "";
		$("areaDesc").value = "";
	}
	
	function toggleExact(toggle){
		if(toggle){
			$("dateGenerated").enable();
			$("dateGeneratedDiv").setStyle("background-color: white");
			enableDate("hrefDateGenerated");
		}else{
			$("dateGenerated").disable();
			$("dateGeneratedDiv").setStyle("background-color: #F0F0F0");
			disableDate("hrefDateGenerated");
		}
	}
	
	function toggleAsOf(toggle){
		if(toggle){
			$("asOfDate").enable();
			$("asOfDateDiv").setStyle("background-color: white");
			enableDate("hrefAsOfDate");
		}else{
			$("asOfDate").disable();
			$("asOfDateDiv").setStyle("background-color: #F0F0F0");
			disableDate("hrefAsOfDate");
		}
	}
	
	function toggleFromTo(toggle){
		if(toggle){
			$("fromDate").enable();
			$("toDate").enable();
			$("fromDateDiv").setStyle("background-color: white");
			$("toDateDiv").setStyle("background-color: white");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
		}else{
			$("fromDate").disable();
			$("toDate").disable();
			$("fromDateDiv").setStyle("background-color: #F0F0F0");
			$("toDateDiv").setStyle("background-color: #F0F0F0");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		}
	}
	
	function showAcctIssCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGIUTS035AcctIssCdLOV",
					filterText: $F("acctIssCd") != $("acctIssCd").getAttribute("lastValidValue") ? nvl($F("acctIssCd"), "%") : "%"
				},
				title: "Account Issue Codes",
				width: 400,
				height: 386,
				columnModel:[
								{	id: "acctIssCd",
									title: "Acct. Issue Cd",
									width: "90px",
									align: 'right'
								},
				             	{	id: "issCd",
									title: "Issue Cd",
									width: "75px"
								},
								{	id: "issName",
									title: "Issue Name",
									width: "200px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("acctIssCd") != $("acctIssCd").getAttribute("lastValidValue") ? nvl($F("acctIssCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("acctIssCd").value = formatNumberDigits(row.acctIssCd, 2);
						$("acctIssCd").setAttribute("lastValidValue", $F("acctIssCd"));
						$("issCd").value = row.issCd;
						$("issName").value = unescapeHTML2(row.issName);
					}
				},
				onCancel: function(){
					$("acctIssCd").value = $("acctIssCd").getAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("acctIssCd").value = $("acctIssCd").getAttribute("lastValidValue");
					showMessageBox("No record selected.", "I");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showAcctIssCdLOV", e);
		}
	}
	
	function showBranchCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGIUTS035BancBranchLOV",
					filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%"
				},
				title: "Branch Issue Codes",
				width: 425,
				height: 386,
				columnModel:[
								{	id: "branchCd",
									title: "Branch Cd",
									width: "90px",
									align: 'right'
								},
				             	{	id: "branchDesc",
									title: "Branch Description",
									width: "150px"
								},
								{	id: "areaDesc",
									title: "Area Description",
									width: "150px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect: function(row){
					if(row != undefined) {
						$("branchCd").value = formatNumberDigits(row.branchCd, 4);
						$("branchCd").setAttribute("lastValidValue", $F("branchCd"));
						$("branchDesc").value = unescapeHTML2(row.branchDesc);
						$("areaDesc").value = unescapeHTML2(row.areaDesc);
					}
				},
				onCancel: function(){
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
					showMessageBox("No record selected.", "I");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showBranchCdLOV", e);
		}
	}
	
	function showHistoryOverlay(){
		refNoHistOverlay = Overlay.show(contextPath+"/GIPIRefNoHistController", {
			urlParameters: {
				action: "showRefNoHistOverlay"
			},
			title: "Reference Number History",
		    height: 320,
		    width: 773,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}
	
	function printCSV(){
		var range = $("exactDate").checked ? 1 : $("onOrBefore").checked ? 2 : 3; 
		
		new Ajax.Request(contextPath + "/GIPIRefNoHistController",{
			parameters : {
				action: "generateCSV",
				range: range,
				exactDate: $F("dateGenerated"),
				asOfDate: $F("asOfDate"),
				fromDate: $F("fromDate"),
				toDate: $F("toDate")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var url = response.responseText;
					if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
						showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
					} else {
						var message = $("geniisysAppletUtil").copyFileToLocal(url, "csv");
						if(message.include("SUCCESS")){
							showMessageBox("CSV file generated to " + message.substring(9), "I");	
						} else {
							showMessageBox(message, "E");
						}
					}
					deleteCSVFile(url);
				}
			}
		});
	}
	
	function deleteCSVFile(url){
		new Ajax.Request(contextPath + "/GIPIRefNoHistController", {
			parameters : {
				action: "deleteCSVFile",
				url: url
			}
		});
	}
	
	function confirmGeneration(){
		if(parseInt($F("noOfRefNo")) == 1){
			showConfirmBox("Confirmation", "Are you sure you want to generate the reference number with Acct Issue Cd = " +
					removeLeadingZero($F("acctIssCd")) +
					" and Branch Cd = " + removeLeadingZero($F("branchCd")) + "?", "Yes", "No", generateBankRefNo, null, "1");
		}else{
			showConfirmBox("Confirmation", "Are you sure you want to generate " + removeLeadingZero($F("noOfRefNo")) + 
					" reference numbers with Acct Issue Cd = " + removeLeadingZero($F("acctIssCd")) +
					" and Branch Cd = " + removeLeadingZero($F("branchCd")) + "?", "Yes", "No", generateBankRefNo, null, "1");
		}
	}
	
	function generateBankRefNo(){
		new Ajax.Request(contextPath + "/GIPIRefNoHistController",{
			parameters : {
				action: "generateBankRefNo",
				acctIssCd: $F("acctIssCd"),
				branchCd: $F("branchCd"),
				noOfRefNo: $F("noOfRefNo"),
				moduleId: "GIUTS035"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					postGenerate(obj);
				}
			}
		});
	}
	
	function postGenerate(obj){
		if(parseInt(obj.noOfRefNo) > 1){
			showWaitingMessageBox("Successfully generated (" + removeLeadingZero(obj.noOfRefNo) + ") bank reference numbers!", "S",
				function(){
					$("refNo").value = "Multiple reference numbers generated";
					$("modNo").value = "";
			});
		}else{
			var message = "Reference number (" + formatNumberDigits(obj.refNo, 7) + ") with Modulus10 number (" +
							formatNumberDigits(obj.modNo, 2) + ") generated successfully!";
			
			showWaitingMessageBox(message, "S", function(){
				$("refNo").value = formatNumberDigits(obj.refNo, 7);
				$("modNo").value = formatNumberDigits(obj.modNo, 2);
			});
		}
	}
	
	$("reloadForm").observe("click", function(){
		showGenerateBankRefNo();
	});
	
	$("acctIssCd").observe("change", function(){
		if($F("acctIssCd") != ""){
			showAcctIssCdLOV();
		}else{
			clearIssFields();
		}
	});
	
	$("branchCd").observe("change", function(){
		if($F("branchCd") != ""){
			showBranchCdLOV();
		}else{
			clearBranchFields();
		}
	});
	
	$("noOfRefNo").observe("change", function(){
		if($F("noOfRefNo") != ""){
			$("noOfRefNo").value = formatNumberDigits($F("noOfRefNo"), 3);
			
			if(parseInt($F("noOfRefNo")) == 0){
				showWaitingMessageBox("Invalid number of reference numbers. Valid value should be from 1 to 999.", "I", function(){
					$("noOfRefNo").value = "001";
				});
			}
		}else{
			$("noOfRefNo").value = "001";
		}
	});
	
	$("searchAcctIssCd").observe("click", function(){
		showAcctIssCdLOV();
	});
	
	$("searchBranchCd").observe("click", function(){
		showBranchCdLOV();
	});
	
	$("exactDate").observe("click", function(){
		toggleExact(true);
		toggleAsOf(false);
		toggleFromTo(false);
	});
	
	$("onOrBefore").observe("click", function(){
		toggleExact(false);
		toggleAsOf(true);
		toggleFromTo(false);
	});
	
	$("exactRange").observe("click", function(){
		toggleExact(false);
		toggleAsOf(false);
		toggleFromTo(true);
	});
	
	$("fromDate").observe("focus", function(){
		if(($F("fromDate") != "" && $F("toDate") != "") && (Date.parse($F("fromDate")) > Date.parse($F("toDate")))){
			showMessageBox("From Date should not be later than To Date.", "I");
			$("fromDate").value = "";
			$("fromDate").focus();
		}
	});
	
	$("toDate").observe("focus", function(){
		if(($F("fromDate") != "" && $F("toDate") != "") && (Date.parse($F("fromDate")) > Date.parse($F("toDate")))){
			showMessageBox("From Date should not be later than To Date.", "I");
			$("toDate").value = "";
			$("toDate").focus();
		}
	});
	
	$("btnPrintCSV").observe("click", function(){
		if($("exactRange").checked && ($F("fromDate") == "" || $F("toDate") == "")){
			showMessageBox("Please provide a date for the specified CSV report parameter.", "I");
		}else{
			printCSV();
		}
	});
	
	$("btnGenerate").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("generateBankRefNoDiv")){
			confirmGeneration();
		}
	});
	
	$("btnHistory").observe("click", function(){
		showHistoryOverlay();
	});
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	newFormInstance();
</script>